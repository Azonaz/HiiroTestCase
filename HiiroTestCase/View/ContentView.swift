import SwiftUI

struct ContentView: View {
    let dayCellWidth: CGFloat = (UIScreen.main.bounds.width - 60) / 7
    let dayCellHeight: CGFloat = 72
    let gapSize: CGFloat = 8
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

                // ячейки с датами на неделю
                GeometryReader { proxy in
                    let halfFullWidth = proxy.size.width / 2
                    ZStack {
                        ForEach(0..<viewModel.numberOfDayCells, id: \.self) { index in
                            dateView(index: index, halfFullWidth: halfFullWidth)
                        }
                        .frame(maxWidth: UIScreen.main.bounds.width)
                        .padding(.top, 25)
                    }
                    // обработка скролла
                    .gesture(viewModel.dragged(cellWidth: dayCellWidth, gapSize: gapSize))
                }
                .frame(height: dayCellHeight)

                // список тренировок
                Text(Constants.activities)
                    .foregroundColor(.white)
                    .font(UIFont.medium16)
                    .padding(.leading, 24)
                    .padding(.bottom, 16)
                    .padding(.top, 60)

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
        }
        // обновляем представление при тапе на дату
        .onChange(of: viewModel.selectedDate) { newValue in
            viewModel.selectedDate = newValue
        }
    }

    private func dateView(index: Int, halfFullWidth: CGFloat) -> some View {
        let xOffset = viewModel.xOffsetForIndex(index: index, cellWidth: dayCellWidth, gapSize: gapSize)
        let dayAdjustment = viewModel.dayAdjustmentForIndex(index: index)
        let dateToDisplay = viewModel.getDateToDisplay(for: index, with: dayAdjustment)
        let dayInfo = viewModel.formatDate(dateToDisplay)
        let checkTraining = viewModel.checkTraining(on: dateToDisplay)
        return ZStack {
            RoundedRectangle(cornerRadius: 100)
            // выбор цвета прямоугольника в зависимости от наличия тренировки в дату
                .foregroundColor(checkTraining ? .purpleUniversal : .grayUniversal)
                .frame(height: 72)
                .overlay(
                    VStack {
                        // день недели
                        Text(dayInfo.dayOfWeek)
                            .font(UIFont.book11)
                            .opacity(0.6)
                            .padding(.bottom, 8)
                        // число
                        Text(dayInfo.dayOfMonth)
                            .font(UIFont.book14)
                    }
                        .foregroundColor(.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                    // отображение выделения выбранной даты
                        .stroke(viewModel.selectedDate == dateToDisplay
                                ? Color.white.opacity(0.4) : .clear, lineWidth: 2)
                        .padding(-3)
                )
                .onTapGesture {
                    // снятие выделения при повторном клике / выборе другой ячейки
                    if viewModel.selectedDate == dateToDisplay {
                        viewModel.selectedDate = nil
                    } else {
                        viewModel.selectedDate = dateToDisplay
                    }
                }
        }
        .frame(width: dayCellWidth, height: dayCellHeight)
        .offset(x: xOffset)
    }
}

#Preview {
    ContentView()
}
