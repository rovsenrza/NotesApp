import Foundation
struct Notes: Codable {
    var name: String
    var desc: String
    var edit: Date
    var id = UUID()
}

var sampleData: [Notes] = [
    Notes(name: "Welcome to Notes", desc: "This is your first note. Tap to edit or create a new one!",edit: Date()),
    Notes(name: "Meeting Notes", desc: "Discuss project timeline and deliverables for Q1",edit: Date()),
    Notes(name: "Shopping List", desc: "Milk, eggs, bread, coffee, fresh vegetables",edit: Date()),
]

