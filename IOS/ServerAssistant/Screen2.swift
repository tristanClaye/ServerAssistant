// Main menu screen with options to start a new table, or reopen an existing one

import SwiftUI

struct Screen2: View {
    @State private var navigateToContentView = false
    @EnvironmentObject var tableManager: TableManager // ✅ Ensure shared data is available

    var body: some View {
        NavigationView{
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [.indigo.opacity(0.85), .blue.opacity(0.9), .secondary]),
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                )
                .ignoresSafeArea()
                
                // Foreground Content
                    VStack(spacing: 20) {
                        NavigationLink(destination: NewTable()){
                            Text("+ New Table")
                                .font(.system(.title, design: .monospaced, weight: .semibold))
                                .padding(10)
                                .frame(width: 230, height: 70)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.5)))
                        }
                        
                        NavigationLink(destination: ReopenTable().environmentObject(tableManager)) {
                            Text("Reopen Table")
                                .font(.system(.title, design: .monospaced, weight: .semibold))
                                .padding(10)
                                .frame(width: 230, height: 70)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.5)))
                        }
                    }
                    .offset(y: -200)
                    
                    NavigationLink(destination: ContentView(),isActive: $navigateToContentView) {
                        EmptyView()
                    }
                }
                .navigationBarHidden(true)
            }
        }
    }
