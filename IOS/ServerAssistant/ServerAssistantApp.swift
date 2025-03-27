//Entry point of app, handles microphone permissions and injects TableManager
import SwiftUI
import AVFAudio

@main
struct ServerAssistantApp: App {
    @StateObject var tableManager = TableManager() // Create and store TableManager

    init() {
        requestMicrophonePermission()
    }

    var body: some Scene {
        WindowGroup {
            SplashScreenView() // Start with splash screen
                .environmentObject(tableManager)
        }
    }
    
    private func requestMicrophonePermission() {
        #if os(iOS)
        if #available(iOS 17.0, *) {
            AVAudioApplication.requestRecordPermission { granted in
                if granted {
                    print("Microphone permission granted!")
                } else {
                    print("Microphone permission denied. Please enable it in Settings.")
                }
            }
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                if granted {
                    print("Microphone permission granted!")
                } else {
                    print("Microphone permission denied. Please enable it in Settings.")
                }
            }
        }
        #endif
    }
}
