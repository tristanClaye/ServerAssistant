// Screen to create a new table


import SwiftUI

struct NewTable: View {
    @EnvironmentObject var tableManager: TableManager // Shared Data
    @Environment(\.presentationMode) var presentationMode // Allows dismissing the view
    @State private var tableNumber: String = ""
    @State private var numPeople: String = ""
    @State private var errorMessage: String? // tracks error messages

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [.indigo.opacity(0.85), .blue.opacity(0.9), .secondary]),
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("New Table")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()

                // Table Number Input
                TextField("Enter Table Number", text: $tableNumber)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .keyboardType(.numberPad)
                    .padding(.horizontal, 40)
                    .foregroundColor(.white)

                // Number of Guests Input
                TextField("Enter Number of Guests", text: $numPeople)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .keyboardType(.numberPad)
                    .padding(.horizontal, 40)
                    .foregroundColor(.white)
                
                // Error message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .bold()
                        .padding(.horizontal, 40)
                }

                // Add Table Button
                Button(action: {
                    if let tableNum = Int(tableNumber), let numGuests = Int(numPeople) {
                        if tableManager.tableExists(number: tableNum){
                            errorMessage = "Table \(tableNum) already exists."
                        }else{tableManager.addTable(number: tableNum, people: numGuests)
                            presentationMode.wrappedValue.dismiss() //Navigate back}
                        }
                    }
                }) {
                    Text("+ Add Table")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 225)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.5)))
                        .offset(x:0,y:6)
                }
                .disabled(tableNumber.isEmpty || numPeople.isEmpty)

                // Back Button
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Navigate back
                }) {
                    Text("Back")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white.opacity(0.7))
                        .padding()
                        .frame(width: 200)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.5)))
                }
                .padding(.top, 20)
            }
            .padding()
        }
    }
}

#Preview {
    NewTable().environmentObject(TableManager()) // Ensures TableManager is available for preview
}
