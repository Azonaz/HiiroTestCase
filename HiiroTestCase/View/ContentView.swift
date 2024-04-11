import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = TrainingViewModel()
    
    var currentMonthAndYear: String {
        let formatter = DateFormatter.currentMonthAndYearFormatter()
        return formatter.string(from: Date())
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text(currentMonthAndYear)
                    .foregroundColor(.white)
                    .font(UIFont.medium16)
                    .padding(.leading, 24)
                    .padding(.top, 80)
                
                HStack(spacing: 6) {
                    ForEach(viewModel.dates, id: \.self) { date in
                        DateRectangleView(date: date, selectedDate: $viewModel.selectedDate)
                    }
                }
                .padding(.horizontal,8)
                .padding([.top, .bottom], 20)
                
                Text("Activities")
                    .foregroundColor(.white)
                    .font(UIFont.medium16)
                    .padding(.leading, 24)
                    .padding([.top, .bottom], 16)
                
                List(viewModel.trainings) { training in
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
    }
}

struct DateRectangleView: View {
    let date: Date
    @Binding var selectedDate: Date?
    @EnvironmentObject var viewModel: TrainingViewModel
    
    var body: some View {
        let dateInfo = viewModel.formatDate(date)
        
        return RoundedRectangle(cornerRadius: 100)
            .foregroundColor(.grayUniv)
            .frame(height: 72)
            .overlay(
                VStack {
                    Text(dateInfo.dayOfWeek)
                        .font(UIFont.book11)
                        .opacity(0.6)
                        .padding(.bottom, 2)
                    Text(dateInfo.dayOfMonth)
                        .font(UIFont.book14)
                }
                    .foregroundColor(.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 100)
                    .stroke(selectedDate == date ? Color.white.opacity(0.4) : .clear, lineWidth: 2)
                    .padding(-3)
            )
            .onTapGesture {
                selectedDate = date
            }
    }
}

#Preview {
    ContentView()
}
