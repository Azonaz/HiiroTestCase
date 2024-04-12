import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = TrainingViewModel()
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                // текущие месяц и год
                Text(viewModel.currentMonthAndYear)
                    .foregroundColor(.white)
                    .font(UIFont.medium16)
                    .padding(.leading, 24)
                    .padding(.top, 80)
                
                HStack(spacing: 6) {
                    // прямоугольники с датами на неделю
                    ForEach(viewModel.dates, id: \.self) { date in
                        DateRectangleView(date: date, selectedDate: $viewModel.selectedDate)
                    }
                }
                .padding(.horizontal,8)
                .padding([.top, .bottom], 20)
                
                // список тренировок
                Text("Activities")
                    .foregroundColor(.white)
                    .font(UIFont.medium16)
                    .padding(.leading, 24)
                    .padding([.top, .bottom], 16)
                
                List(viewModel.filteredTrainings) { training in
                    TrainView(training: training)
                        .listRowBackground(Color.black)
                        .padding(.bottom, 20)
                }
                .listStyle(.inset)
                .scrollContentBackground(.hidden)
            }
            .background(Color.black)
            .environmentObject(viewModel)
            // обработчик жестов для перехода к предыдущей/следующей неделе
            .gesture(DragGesture().onEnded{ value in
                if value.translation.width > 50 {
                    viewModel.goToPreviousWeek()
                } else if value.translation.width < -50 {
                    viewModel.goToNextWeek()
                }
            }
            )
        }
    }
}

struct DateRectangleView: View {
    let date: Date
    @Binding var selectedDate: Date?
    @EnvironmentObject var viewModel: TrainingViewModel
    
    var body: some View {
        let dateInfo = viewModel.formatDate(date)
        let checkTraining = viewModel.checkTraining(on: date)
        
        return RoundedRectangle(cornerRadius: 100)
            // выбор цвета прямоугольника в зависимости от наличия тренировки в дату
            .foregroundColor(checkTraining ? .purpleUniv : .grayUniv)
            .frame(height: 72)
            .overlay(
                VStack {
                    // день недели
                    Text(dateInfo.dayOfWeek)
                        .font(UIFont.book11)
                        .opacity(0.6)
                        .padding(.bottom, 2)
                    // число
                    Text(dateInfo.dayOfMonth)
                        .font(UIFont.book14)
                }
                    .foregroundColor(.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 100)
                    // отображение выделения выбранной даты
                    .stroke(selectedDate == date ? Color.white.opacity(0.4) : .clear, lineWidth: 2)
                    .padding(-3)
            )
            // обработка нажатия на прямоугольник с датой
            .onTapGesture {
                if selectedDate == date {
                    selectedDate = nil
                } else {
                    selectedDate = date
                }
            }
    }
}

#Preview {
    ContentView()
}
