import Foundation

class TrainingViewModel: ObservableObject {
    @Published var trainings: [Training]
    @Published var selectedDate: Date?
    @Published var dates: [Date] = []
    
    init() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        self.trainings = [
            Training(name: "Intervals", imageName: "intervals", info: "8km", description: "200/400 rest", date: dateFormatter.date(from: "08.04.2024") ?? Date()),
            Training(name: "Easy run", imageName: "easyRun", info: "10km", description: "HR zone 2", date: dateFormatter.date(from: "10.04.2024") ?? Date()),
            Training(name: "Tempo run", imageName: "tempoRun", info: "6km", description: "HR zone 3-4", date: dateFormatter.date(from: "12.04.2024") ?? Date()),
            Training(name: "Longrun", imageName: "longRun", info: "17km", description: "65%", date: dateFormatter.date(from: "13.04.2024") ?? Date()),
            Training(name: "Strength training", imageName: "strength", info: "1 hour", description: "dumbbells, free weight", date: dateFormatter.date(from: "15.04.2024") ?? Date())
        ]
        self.dates = getCurrentWeekDates() ?? []
    }
    
    func getCurrentWeekDates() -> [Date]? {
        let calendar = Calendar.current
        let today = Date()
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: today) else { return nil }
        var weekDates: [Date] = []
        for i in 0..<7 {
            if let weekDay = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                weekDates.append(weekDay)
            }
        }
        return weekDates
    }
    
    func formatDate(_ date: Date) -> (dayOfWeek: String, dayOfMonth: String) {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter.customDateFormatter()
        let dayOfWeek = dateFormatter.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1].uppercased()
        let dayOfMonth = dateFormatter.string(from: date)
        return (dayOfWeek, dayOfMonth)
    }
}
