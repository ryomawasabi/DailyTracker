import SwiftUI
import SwiftData

struct RecordInputView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedMood: Int = 3
    @State private var selectedDate: Date = Date()
    @State private var activities: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Date") {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                }
                
                Section("Title") {
                    TextField("What's on your mind?", text: $title)
                }
                
                Section("Description") {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                }
                
                Section("Mood") {
                    HStack {
                        Text("😞")
                        Slider(value: Double($selectedMood), in: 1...5, step: 1)
                        Text("😄")
                    }
                    Text("Current Mood: \(getMoodEmoji(selectedMood))")
                        .font(.title2)
                }
                
                Section("Activities") {
                    TextField("Separate with commas", text: $activities)
                }
            }
            .navigationTitle("New Record")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveRecord()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveRecord() {
        let activityList = activities.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
        let newRecord = DailyRecord(
            date: selectedDate,
            title: title,
            description: description,
            mood: selectedMood,
            activities: activityList
        )
        modelContext.insert(newRecord)
        dismiss()
    }
    
    private func getMoodEmoji(_ mood: Int) -> String {
        switch mood {
        case 1: return "😞"
        case 2: return "😐"
        case 3: return "🙂"
        case 4: return "😊"
        case 5: return "😄"
        default: return "🙂"
        }
    }
}

#Preview {
    RecordInputView()
}
