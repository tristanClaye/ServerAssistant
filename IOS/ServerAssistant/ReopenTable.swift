// Reopen table screen
// Contains a scrollable list of already created tables
// Lets user reopen a table (opening the dashboard screen) or delete it
import SwiftUI

struct ReopenTable: View {
    @EnvironmentObject var tableManager: TableManager // Shared Data
    @State private var selectedTableID: UUID? // Track selected table
    @Environment(\.presentationMode) var presentationMode // Allows dismissing the view
    @State private var navigateToDashboard = false // Added missing state variable
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                //Background Gradient (Replacing BackgroundGradient())
                LinearGradient(
                    gradient: Gradient(colors: [.indigo.opacity(0.85), .blue.opacity(0.9), .secondary]),
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                )
                .ignoresSafeArea()
                
                VStack {
                    //Title
                    Text("Reopen Table")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    // Scrollable List of Tables
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(tableManager.tables.reversed(), id: \.id) { table in //Newest at the top
                                Button(action: {
                                    selectedTableID = table.id // Select table
                                }) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("Table \(table.tableNumber)") // Fixing 'number' reference
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            Text("\(table.numPeople) people") // Fixing 'people' reference
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        if selectedTableID == table.id {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedTableID == table.id ? Color.blue.opacity(0.3) : Color.white.opacity(0.5))
                                    )
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(maxHeight: 300) // Set max height for scrolling
                    let selectedTable = tableManager.tables.first(where: { $0.id == selectedTableID })

                    // Navigation to DashboardScreen
                        NavigationLink(
                            destination: selectedTable.map { DashboardScreen(table: $0).environmentObject(tableManager) },
                            isActive: $navigateToDashboard
                        ) {
                            EmptyView()
                        }
                    
                    
                    // Action Buttons
                    HStack(spacing: 20) {
                        Button(action: {
                            if selectedTableID != nil {
                                navigateToDashboard = true // Navigate when open is pressed
                            }
                        }) {
                            Text("Open")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 120)
                                .background(Color.green)
                                .cornerRadius(12)
                        }
                        .disabled(selectedTableID == nil)
                        
                        Button(action: {
                            if let selectedID = selectedTableID {
                                tableManager.tables.removeAll { $0.id == selectedID }
                                selectedTableID = nil
                            }
                        }) {
                            Text("Delete")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white.opacity(0.7))
                                .padding()
                                .frame(width: 120)
                                .background(Color.red.opacity(0.7))
                                .cornerRadius(12)
                        }
                        .disabled(selectedTableID == nil)
                    }
                    .padding()
                    
                    // Back Button
                    Button(action: {
                        // Explicit navigation back to Screen2 instead of dismissing
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = UIHostingController(rootView: Screen2().environmentObject(tableManager))
                            window.makeKeyAndVisible()
                        }
                    }) {
                        Text("Back")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white.opacity(0.7))
                            .padding()
                            .frame(width: 200)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.5)))
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
        }
    }
}
                    
