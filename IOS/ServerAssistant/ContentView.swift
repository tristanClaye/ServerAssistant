// Content view
import SwiftUI

struct ContentView: View {
    let speechService = SpeechToTextService()
    @State private var parsedOrder: String = "No order yet"

    var body: some View {
        VStack(spacing: 20) {
            Text("Parsed Order:")
                .font(.headline)

            Text(parsedOrder)
                .font(.title)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

            Button("Start Recording") {
                speechService.startRecording()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)

            Button("Stop Recording") {
                speechService.stopRecording()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .onReceive(NotificationCenter.default.publisher(for: .newOrderParsed)) { notification in
            if let order = notification.object as? String {
                self.parsedOrder = order
            }
        }
    }
}

extension Notification.Name {
    static let newOrderParsed = Notification.Name("newOrderParsed")
}
