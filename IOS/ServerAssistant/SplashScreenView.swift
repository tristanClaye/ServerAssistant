// Splash screen that fades to main screen after 2 seconds

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            Screen2() // Transition to the main screen after delay
        } else {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [.indigo.opacity(0.85), .blue.opacity(0.9), .secondary]),
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                )
                .ignoresSafeArea()
                
                // Foreground Content
                VStack {
                    Text("Server Assistant")
                        .font(.system(.largeTitle, design: .monospaced, weight: .medium))
                        .foregroundColor(.white)
                        .foregroundStyle(.primary.opacity(0.9))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                        .shadow(color: .black.opacity(0.5), radius: 1, x: 2, y: 2)
                        .fixedSize(horizontal: true, vertical: true)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isActive = true // Change state after delay
                    }
                }
            }
        }
    }
}
