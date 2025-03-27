// Handles recording audio using Deepgram ai for transcription
// Sends Deepgram transcript to OpenAI endpoint to format as shorthand
// Result is then posted

import AVFoundation
import Alamofire


class SpeechToTextService: NSObject, AVAudioRecorderDelegate {
    @Published var transcript: String? = nil
    
    private let apiKey = "7d2e6c208fc194be1daeb71224d38d93d3902df5"
    private var audioRecorder: AVAudioRecorder?
    private var audioFileUrl: URL?

    func startRecording() {
        do {
            print("Starting recording...")
            let audioSession = AVAudioSession.sharedInstance()

            // Set category to `.playAndRecord` instead of `.record`
            try audioSession.setCategory(.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
            try audioSession.setActive(true)

            // Ensure a valid file path
            let fileName = "recording.wav"
            audioFileUrl = getDocumentsDirectory().appendingPathComponent(fileName)
            print("Audio file path: \(audioFileUrl!.path)")

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 16000.0,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: audioFileUrl!, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()

            print("Recording started successfully.")
        } catch {
            print("Error starting recording: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        print("Stopping recording...")
        audioRecorder?.stop()

        if let recordedFile = audioFileUrl {
            print("Audio file recorded: \(recordedFile.path)")
            sendAudioToDeepgram(audioFileUrl: recordedFile)
        } else {
            print("No recorded file found!")
        }
    }

    private func sendAudioToDeepgram(audioFileUrl: URL) {
        print("Uploading audio to Deepgram...")

        // Ensure the file exists before trying to send it
        guard let audioData = try? Data(contentsOf: audioFileUrl) else {
            print("Failed to read audio file.")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Token \(apiKey)",
            "Content-Type": "audio/wav"
        ]

        struct DeepgramResponse: Decodable {
            let results: Results
        }
        struct Results: Decodable {
            let channels: [Channel]
        }
        struct Channel: Decodable {
            let alternatives: [Alternative]
        }
        struct Alternative: Decodable {
            let transcript: String?
        }

        print("Successfully read audio file. Uploading now...")

        AF.upload(audioData, to: "https://api.deepgram.com/v1/listen", headers: headers)
            .validate()
            .responseDecodable(of: DeepgramResponse.self) { response in
                print("Deepgram Response Status Code: \(response.response?.statusCode ?? 0)")
                
                switch response.result {
                case .success(let deepgramResponse):
                    if let transcript = deepgramResponse.results.channels.first?.alternatives.first?.transcript, !transcript.isEmpty {
                        print("Deepgram Transcript: \(transcript)")
                        
                        // Send transcript to AI order parser
                        self.sendToOrderParser(transcript)
                    } else {
                        print("No transcript found in Deepgram response.")
                    }
                case .failure(let error):
                    print("Deepgram API Error: \(error.localizedDescription)")
                }
            }
    }
    private func sendToOrderParser(_ transcript: String) {
        print("Sending transcript to AI order parser...")

        let parameters: [String: Any] = ["transcript": transcript]
        let apiUrl = "https://serverassistant-production.up.railway.app/process_order"
        struct OrderParserResponse: Decodable {
            let order: String?
            let error: String?
        }

        AF.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: OrderParserResponse.self) { response in
                switch response.result {
                case .success(let parsedData):
                    if let order = parsedData.order, !order.isEmpty {
                        print("AI Order Parser Response: \(order)")
                        
                        // Send transcript to UI via NotificationCenter
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .newOrderParsed, object: order)
                        }
                    } else if let error = parsedData.error {
                        print("AI Order Parser Error: \(error)")
                    } else {
                        print("Unexpected empty response from API.")
                    }

                case .failure(let error): // Fix incorrect syntax
                    print("AI Order Parser Error: \(error.localizedDescription)")
                }
            }
    }

    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
