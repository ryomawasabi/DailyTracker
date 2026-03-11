import Foundation
import SwiftData

@Observable
class RecordViewModel {
    var records: [DailyRecord] = []
    var selectedDate: Date = Date()
    
    func addRecord(_ record: DailyRecord) {
        records.append(record)
    }
    
    func deleteRecord(_ record: DailyRecord) {
        records.removeAll { $0 == record }
    }
    
    func getRecordsForDate(_ date: Date) -> [DailyRecord] {
        let calendar = Calendar.current
        return records.filter { record in
            calendar.isDate(record.date, inSameDayAs: date)
        }
    }
    
    func getAverageMood() -> Double {
        guard !records.isEmpty else { return 0 }
        let sum = records.reduce(0) { $0 + $1.mood }
        return Double(sum) / Double(records.count)
    }
    
    func getMoodTrend() -> [Int] {
        let last7Days = (0..<7).map { Calendar.current.date(byAdding: .day, value: -$0, to: Date())! }
        return last7Days.reversed().map { date in
            let dayRecords = getRecordsForDate(date)
            return dayRecords.isEmpty ? 0 : dayRecords.reduce(0) { $0 + $1.mood } / dayRecords.count
        }
    }
}
