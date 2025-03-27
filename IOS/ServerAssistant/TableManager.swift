// Stores important data like table num, ppl at table, and items ordered

import Foundation

class TableManager: ObservableObject {
    @Published var tables: [TableData] = []
    
    func addTable(number: Int, people: Int) {
        if !tableExists(number: number) {
            let newTable = TableData(tableNumber: number, numPeople: people, transcript: nil)
            tables.append(newTable)
        }
    }
    
    func updateTableTranscript(tableID: UUID, transcript: String) {
        if let index = tables.firstIndex(where: { $0.id == tableID }) {
            if let existingTranscript = tables[index].transcript {
                tables[index].transcript = existingTranscript + "\n" + transcript // Append properly
            } else {
                tables[index].transcript = transcript // First-time assignment
            }
            objectWillChange.send() //  Notify SwiftUI to update UI
        }
        }
    
    func tableExists(number: Int) -> Bool {
            return tables.contains(where: { $0.tableNumber == number })
        }
    }
    
    
    struct TableData: Identifiable {
        let id = UUID()
        let tableNumber: Int // Changed from String to Int for consistency
        let numPeople: Int
        var transcript: String? = nil // Will store orders in the future
    }

