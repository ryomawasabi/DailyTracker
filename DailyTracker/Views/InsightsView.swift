import SwiftUI
import Charts

struct InsightsView: View {
    let records: [DailyRecord]
    
    var averageMood: Double {
        guard !records.isEmpty else { return 0 }
        return Double(records.reduce(0) { $0 + $1.mood }) / Double(records.count)
    }
    
    var moodDistribution: [(mood: Int, count: Int)] {
        var distribution: [Int: Int] = [:]
        for record in records {
            distribution[record.mood, default: 0] += 1
        }
        return (1...5).map { mood in
            (mood, distribution[mood] ?? 0)
        }
    }
    
    var lastSevenDaysMood: [(day: String, mood: Double)] {
        let calendar = Calendar.current
        var moodByDay: [String: [Int]] = [:]
        
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -i, to: Date())!
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEE"
            let dayString = dayFormatter.string(from: date)
            moodByDay[dayString] = []
        }
        
        for record in records {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEE"
            let dayString = dayFormatter.string(from: record.date)
            moodByDay[dayString]?.append(record.mood)
        }
        
        return moodByDay.sorted(by: { a, b in
            let order = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            return order.firstIndex(of: a.key) ?? 7 < order.firstIndex(of: b.key) ?? 7
        }).map { day, moods in
            (day, moods.isEmpty ? 0 : Double(moods.reduce(0, +)) / Double(moods.count))
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Average Mood Card
                    VStack(alignment: .center, spacing: 12) {
                        Text("Average Mood")
                            .font(.headline)
                        HStack(spacing: 12) {
                            Text(getMoodEmoji(Int(averageMood.rounded())))
                                .font(.system(size: 48))
                            Text(String(format: "%.1f", averageMood))
                                .font(.system(size: 36, weight: .bold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Mood Distribution Chart
                    if !records.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Mood Distribution")
                                .font(.headline)
                            
                            Chart(moodDistribution, id: \.mood) { item in
                                BarMark(
                                    x: .value("Mood", getMoodEmoji(item.mood)),
                                    y: .value("Count", item.count)
                                )
                                .foregroundStyle(getMoodColor(item.mood))
                            }
                            .frame(height: 200)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Last 7 Days Chart
                    if !lastSevenDaysMood.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Last 7 Days Trend")
                                .font(.headline)
                            
                            Chart(lastSevenDaysMood, id: \.day) { item in
                                PointMark(
                                    x: .value("Day", item.day),
                                    y: .value("Mood", item.mood)
                                )
                                .foregroundStyle(.blue)
                                
                                LineMark(
                                    x: .value("Day", item.day),
                                    y: .value("Mood", item.mood)
                                )
                                .foregroundStyle(.blue.opacity(0.3))
                            }
                            .frame(height: 200)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Insights")
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
    
    private func getMoodColor(_ mood: Int) -> Color {
        switch mood {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        default: return .gray
        }
    }
}

#Preview {
    InsightsView(records: [])
}
