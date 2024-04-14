import SwiftUI

final class TrainingViewModel: ObservableObject {
    let calendar = Calendar.current
    @Published var trainings: [Training]
    @Published var dates: [Date] = []
    @Published var selectedDate: Date?
    let baseDate = Date.now
    let numberOfDayCells = 21
    
    // получаем текущий месяц и год для показа во вью
    var currentMonthAndYear: String {
        guard let firstDate = dates.first else { return "" }
        return DateFormatter.monthYearFormatter.string(from: firstDate)
    }
    
    // фильтруем по дате
    var filteredTrainings: [Training] {
        // выбрана дата в календаре
        if let selectedDate = selectedDate {
            return trainings.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
        } else {
            // все, начиная с даты показываемой недели
            guard let startDate = dates.first else { return [] }
            return trainings.filter { training in
                let trainingDate = Calendar.current.startOfDay(for: training.date)
                return trainingDate >= startDate
            }
        }
    }
    
    private var snappedDayOffset = 0
    private var draggedDayOffset = Double.zero
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    init() {
        // создаем моковые объекты типа Training
        self.trainings = [
            Training(type: "Easy run", iconName: "easyRun", info: "10km", description: "HR zone 2", date: dateFormatter.date(from: "01.04.2024") ?? Date()),
            Training(type: "Tempo run", iconName: "tempoRun", info: "6km", description: "HR zone 3-4", date: dateFormatter.date(from: "03.04.2024") ?? Date()),
            Training(type: "Longrun", iconName: "longRun", info: "17km", description: "65%", date: dateFormatter.date(from: "05.04.2024") ?? Date()),
            Training(type: "Strength training", iconName: "strength", info: "1 hour", description: "dumbbells, free weight", date: dateFormatter.date(from: "06.04.2024") ?? Date()),
            Training(type: "Intervals", iconName: "intervals", info: "8km", description: "200/400 rest", date: dateFormatter.date(from: "08.04.2024") ?? Date()),
            Training(type: "Easy run", iconName: "easyRun", info: "10km", description: "HR zone 2", date: dateFormatter.date(from: "10.04.2024") ?? Date()),
            Training(type: "Tempo run", iconName: "tempoRun", info: "6km", description: "HR zone 3-4", date: dateFormatter.date(from: "12.04.2024") ?? Date()),
            Training(type: "Longrun", iconName: "longRun", info: "17km", description: "65%", date: dateFormatter.date(from: "13.04.2024") ?? Date()),
            Training(type: "Strength training", iconName: "strength", info: "1 hour", description: "dumbbells, free weight", date: dateFormatter.date(from: "15.04.2024") ?? Date()),
            Training(type: "Intervals", iconName: "intervals", info: "8km", description: "200/400 rest", date: dateFormatter.date(from: "17.04.2024") ?? Date()),
            Training(type: "Easy run", iconName: "easyRun", info: "10km", description: "HR zone 2", date: dateFormatter.date(from: "19.04.2024") ?? Date()),
            Training(type: "Tempo run", iconName: "tempoRun", info: "6km", description: "HR zone 3-4", date: dateFormatter.date(from: "21.04.2024") ?? Date()),
            Training(type: "Longrun", iconName: "longRun", info: "17km", description: "65%", date: dateFormatter.date(from: "23.04.2024") ?? Date()),
            Training(type: "Strength training", iconName: "strength", info: "1 hour", description: "dumbbells, free weight", date: dateFormatter.date(from: "25.04.2024") ?? Date()),
            Training(type: "Intervals", iconName: "intervals", info: "8km", description: "200/400 rest", date: dateFormatter.date(from: "26.04.2024") ?? Date()),
            Training(type: "Tempo run", iconName: "tempoRun", info: "6km", description: "HR zone 3-4", date: dateFormatter.date(from: "28.04.2024") ?? Date()),
            Training(type: "Longrun", iconName: "longRun", info: "17km", description: "65%", date: dateFormatter.date(from: "30.04.2024") ?? Date())
        ]
        // заполняем массив дат на текущую неделю
        self.dates = getCurrentWeekDates() ?? []
    }
    
    // возврат даты в формате краткого дня недели и числа
    func formatDate(_ date: Date) -> (dayOfWeek: String, dayOfMonth: String) {
        let dayOfWeek = dateFormatter.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1].uppercased()
        let dayOfMonth = DateFormatter.dayFormatter.string(from: date)
        return (dayOfWeek, dayOfMonth)
    }
    
    // проверка наличия тренировки на дату
    func checkTraining(on date: Date) -> Bool {
        let startOfDate = calendar.startOfDay(for: date)
        return trainings.contains { calendar.startOfDay(for: $0.date) == startOfDate }
    }
    
    // вычисление даты для отображения в ячейке календаря с учетом индекса ячейки и смещения дня
    func getDateToDisplay(for index: Int, with dayAdjustment: Int) -> Date {
        let baseDate = self.baseDate
        return Calendar.current.date(byAdding: .day, value: dayAdjustment, to: baseDate) ?? baseDate
    }
    
    // переход к следующей неделе
    func goToNextWeek() {
        guard let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: dates.first ?? Date()) else { return }
        dates = getWeekDates(from: nextWeek)
        selectedDate = nil
    }
    
    // переход к предыдущей неделе
    func goToPreviousWeek() {
        guard let previousWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: dates.first ?? Date()) else { return }
        dates = getWeekDates(from: previousWeek)
        selectedDate = nil
    }
   
    // расчет смещения по оси X для каждой ячейки в календаре
    func xOffsetForIndex(index: Int, cellWidth: CGFloat, gapSize: CGFloat) -> Double {
        let positionWidth = CGFloat(cellWidth + gapSize)
        let midIndex = Double(numberOfDayCells / 2)
        var dIndex = (Double(index) - draggedDayOffset - midIndex).truncatingRemainder(dividingBy: Double(numberOfDayCells))
        if dIndex < -midIndex {
            dIndex += Double(numberOfDayCells)
        } else if dIndex > midIndex {
            dIndex -= Double(numberOfDayCells)
        }
        return dIndex * positionWidth
    }
    
    // смещение дня относительно центральной ячейки
    func dayAdjustmentForIndex(index: Int) -> Int {
        let midIndex = numberOfDayCells / 2
        var dIndex = (index - snappedDayOffset - midIndex) % numberOfDayCells
        if dIndex < -midIndex {
            dIndex += numberOfDayCells
        } else if dIndex > midIndex {
            dIndex -= numberOfDayCells
        }
        return dIndex + snappedDayOffset
    }
    
    // обработка прокрутки влево/вправо для навигации между неделями
    func dragged(cellWidth: CGFloat, gapSize: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged() { value in
                self.draggedDayOffset = Double(self.snappedDayOffset) - (value.translation.width / (cellWidth + gapSize))
            }
            .onEnded { value in
                if value.startLocation.x > value.location.x {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        self.draggedDayOffset = Double(self.snappedDayOffset + 7)
                        self.snappedDayOffset = Int(self.draggedDayOffset)
                        self.goToNextWeek()
                        self.selectedDate = nil
                    }
                } else {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        self.draggedDayOffset = Double(self.snappedDayOffset - 7)
                        self.snappedDayOffset = Int(self.draggedDayOffset)
                        self.goToPreviousWeek()
                        self.selectedDate = nil
                    }
                }
            }
    }
    
    // получение дат определенной недели
    private func getWeekDates(from date: Date) -> [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: date) else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekInterval.start) }
    }
    
    // получение дат текущей недели
    private func getCurrentWeekDates() -> [Date]? {
        let today = Date()
        return getWeekDates(from: today)
    }
}
