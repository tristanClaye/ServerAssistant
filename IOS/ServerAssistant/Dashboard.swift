// Dashboard for an open table.
// Displays the table number, guest num, and transcript of recorded orders

import Foundation
import SwiftUI

struct DashboardScreen: View {
    @EnvironmentObject var tableManager: TableManager // Access table data
    let table: TableData // Selected table
    @State private var transcript: String = ""// Default transcript
    
    let speechService = SpeechToTextService()
    @Environment(\.presentationMode) var presentationMode // Fix Back Navigation
    @State private var navigateBack = false
    
    init(table: TableData) {
            self.table = table
        _transcript = State(initialValue: table.transcript ?? "")
        }


    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [.indigo.opacity(0.85), .blue.opacity(0.9), .secondary]),
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                // Table Number & Guest Count (Top Left)
                VStack(alignment: .leading) {
                    Text("Table \(table.tableNumber)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("\(table.numPeople) Guests")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.leading, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                // Transcript Box (Center)
                VStack {
                    Text("Transcript")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    ScrollView{
                        Text(transcript)
                            .font(.body)
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 350)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(12)
                    }
                    .frame(maxWidth: .infinity, minHeight: 350, maxHeight: 500)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                    .onReceive(NotificationCenter.default.publisher(for: .newOrderParsed)) { notification in
                        if let newTranscript = notification.object as? String {
                            transcript += "\n" + newTranscript // Append new transcript
                            tableManager.updateTableTranscript(tableID: table.id, transcript: newTranscript) // Save it
                        }
                    }
                
                // Start & Stop Recording Buttons
                HStack {
                    Button(action: {
                        speechService.startRecording()
                    }) {
                        Text("Start Recording")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 180)
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        speechService.stopRecording()
                    }) {
                        Text("Stop Recording")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 180)
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                }
                .padding(.bottom, 20)
                
                // Back Button (Bottom Center)
                Button(action: {
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Back")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.bottom, 40)
                
                // ✅ NavigationLink to go back to ReopenTable
                NavigationLink(destination: ReopenTable().environmentObject(tableManager), isActive: $navigateBack) {
                    EmptyView()
                }
            }
        }
        .navigationBarHidden(true)
        .onReceive(NotificationCenter.default.publisher(for: .newOrderParsed)) { notification in
            if let newTranscript = notification.object as? String {
                DispatchQueue.main.async {
                    if !self.transcript.contains(newTranscript) { // Prevent duplicate entries
                        self.transcript += "\n" + newTranscript
                        tableManager.updateTableTranscript(tableID: table.id, transcript: newTranscript)
                    }
                }
            }
        }
    }
}
