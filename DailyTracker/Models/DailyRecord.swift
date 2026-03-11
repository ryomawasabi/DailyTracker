import Foundation
import SwiftData

@Model
final class DailyRecord {
    var date: Date
    var title: String
    var description: String
    var mood: Int // 1-5 scale
    var activities: [String]
    var createdAt: Date
    
    init(date: Date, title: String, description: String, mood: Int, activities: [String] = []) {
        self.date = date
        self.title = title
        self.description = description
        self.mood = max(1, min(5, mood))
        self.activities = activities
        self.createdAt = Date()
    }
}
