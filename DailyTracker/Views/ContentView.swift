import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var dailyRecords: [DailyRecord]
    
    var body: some View {
        TabView {
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "list.bullet")
                }
            
            InsightsView(records: dailyRecords)
                .tabItem {
                    Label("Insights", systemImage: "chart.bar")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: DailyRecord.self, inMemory: true)
}
