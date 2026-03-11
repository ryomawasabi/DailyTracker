import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \DailyRecord.date, order: .reverse) var records: [DailyRecord]
    @State private var showingAddRecord = false
    
    var body: some View {
        NavigationStack {
            if records.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "book.closed")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("No Records Yet")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Start tracking your daily activities")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(records) { record in
                        NavigationLink(destination: RecordDetailView(record: record)) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(record.title)
                                        .font(.headline)
                                    Spacer()
                                    Text(getMoodEmoji(record.mood))
                                        .font(.title3)
                                }
                                Text(record.date.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .onDelete(perform: deleteRecords)
                }
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddRecord = true }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingAddRecord) {
                RecordInputView()
            }
        }
    }
    
    private func deleteRecords(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(records[index])
        }
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

struct RecordDetailView: View {
    let record: DailyRecord
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(record.title)
                            .font(.title)
                            .fontWeight(.bold)
                        Text(record.date.formatted(date: .complete, time: .omitted))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(getMoodEmoji(record.mood))
                        .font(.system(size: 48))
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.headline)
                    Text(record.description)
                        .lineLimit(nil)
                }
                
                if !record.activities.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Activities")
                            .font(.headline)
                        VStack(alignment: .leading) {
                            ForEach(record.activities, id: \.self) { activity in
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text(activity)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Record Details")
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
    HistoryView()
        .modelContainer(for: DailyRecord.self, inMemory: true)
}
