import Foundation

final class TrainingViewModel: ObservableObject {
    let calendar = Calendar.current
    @Published var trainings: [Training]
    @Published var dates: [Date] = []
    @Published var selectedDate: Date?
    
    var currentMonthAndYear: String {
        guard let firstDate = dates.first else { return "" }
        return DateFormatter.monthYearFormatter.string(from: firstDate)
    }
    
    var filteredTrainings: [Training] {
        if let selectedDate = selectedDate {
            return trainings.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
        } else {
            guard let startDate = dates.first else { return [] }
            return trainings.filter { training in
                let trainingDate = Calendar.current.startOfDay(for: training.date)
                return trainingDate >= startDate
            }
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    init() {
        self.trainings = [
            Training(name: "Easy run", imageName: "easyRun", info: "10km", description: "HR zone 2", date: dateFormatter.date(from: "01.04.2024") ?? Date()),
            Training(name: "Tempo run", imageName: "tempoRun", info: "6km", description: "HR zone 3-4", date: dateFormatter.date(from: "03.04.2024") ?? Date()),
            Training(name: "Longrun", imageName: "longRun", info: "17km", description: "65%", date: dateFormatter.date(from: "05.04.2024") ?? Date()),
            Training(name: "Strength training", imageName: "strength", info: "1 hour", description: "dumbbells, free weight", date: dateFormatter.date(from: "06.04.2024") ?? Date()),
            Training(name: "Intervals", imageName: "intervals", info: "8km", description: "200/400 rest", date: dateFormatter.date(from: "08.04.2024") ?? Date()),
            Training(name: "Easy run", imageName: "easyRun", info: "10km", description: "HR zone 2", date: dateFormatter.date(from: "10.04.2024") ?? Date()),
            Training(name: "Tempo run", imageName: "tempoRun", info: "6km", description: "HR zone 3-4", date: dateFormatter.date(from: "12.04.2024") ?? Date()),
            Training(name: "Longrun", imageName: "longRun", info: "17km", description: "65%", date: dateFormatter.date(from: "13.04.2024") ?? Date()),
            Training(name: "Strength training", imageName: "strength", info: "1 hour", description: "dumbbells, free weight", date: dateFormatter.date(from: "15.04.2024") ?? Date()),
            Training(name: "Intervals", imageName: "intervals", info: "8km", description: "200/400 rest", date: dateFormatter.date(from: "17.04.2024") ?? Date()),
            Training(name: "Easy run", imageName: "easyRun", info: "10km", description: "HR zone 2", date: dateFormatter.date(from: "19.04.2024") ?? Date()),
            Training(name: "Tempo run", imageName: "tempoRun", info: "6km", description: "HR zone 3-4", date: dateFormatter.date(from: "21.04.2024") ?? Date()),
            Training(name: "Longrun", imageName: "longRun", info: "17km", description: "65%", date: dateFormatter.date(from: "23.04.2024") ?? Date()),
            Training(name: "Strength training", imageName: "strength", info: "1 hour", description: "dumbbells, free weight", date: dateFormatter.date(from: "25.04.2024") ?? Date()),
            Training(name: "Intervals", imageName: "intervals", info: "8km", description: "200/400 rest", date: dateFormatter.date(from: "26.04.2024") ?? Date()),
            Training(name: "Tempo run", imageName: "tempoRun", info: "6km", description: "HR zone 3-4", date: dateFormatter.date(from: "28.04.2024") ?? Date()),
            Training(name: "Longrun", imageName: "longRun", info: "17km", description: "65%", date: dateFormatter.date(from: "30.04.2024") ?? Date())
        ]
        self.dates = getCurrentWeekDates() ?? []
    }
    
    func formatDate(_ date: Date) -> (dayOfWeek: String, dayOfMonth: String) {
        let dayOfWeek = DateFormatter().shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1].uppercased()
        let dayOfMonth = DateFormatter.dayFormatter.string(from: date)
        return (dayOfWeek, dayOfMonth)
    }
    
    func checkTraining(on date: Date) -> Bool {
        let startOfDate = calendar.startOfDay(for: date)
        return trainings.contains { training in
            let startOfTrainingDate = calendar.startOfDay(for: training.date)
            return startOfTrainingDate == startOfDate
        }
    }
    
    func goToNextWeek() {
        guard let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: dates.first ?? Date()) else { return }
        dates = getWeekDates(from: nextWeek)
        selectedDate = nil
    }
    
    func goToPreviousWeek() {
        guard let previousWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: dates.first ?? Date()) else { return }
        dates = getWeekDates(from: previousWeek)
        selectedDate = nil
    }
    
    private func getWeekDates(from date: Date) -> [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: date) else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekInterval.start) }
    }
    
    private func getCurrentWeekDates() -> [Date]? {
        let today = Date()
        return getWeekDates(from: today)
    }
}
