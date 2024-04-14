import SwiftUI

struct TrainView: View {
    @EnvironmentObject var viewModel: TrainingViewModel
    var training: Training

    var body: some View {
        let imageHeight: CGFloat = 48
        let trainingDateInfo = viewModel.formatDate(training.date)

        HStack(spacing: 16) {
            // иконка тренировки
            Image(training.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: imageHeight, height: imageHeight)

            VStack(alignment: .leading, spacing: 8) {
                // тип тренировки
                Text(training.type)
                    .font(UIFont.book14)
                HStack(spacing: 16) {
                    // информация о тренировке
                    Text(training.info)
                    Text(training.description)
                }
                .font(UIFont.book14)
                .opacity(0.4)
            }

            Spacer()

            VStack(alignment: .center, spacing: 8) {
                // число и день недели
                Text(trainingDateInfo.dayOfMonth)
                    .font(UIFont.book14)
                Text(trainingDateInfo.dayOfWeek)
                    .font(UIFont.book11)
                    .opacity(0.6)
                    .padding(.bottom, 2)
            }
        }
        .foregroundColor(.white)
        .background(.black)
    }
}

#Preview {
    TrainView(training: Training(type: "Intervals",
                                 iconName: "intervals",
                                 info: "8km",
                                 description: "200/400 rest",
                                 date: DateFormatter.dayFormatter.date(from: "08.04.2024") ?? Date()))
        .padding()
        .environmentObject(TrainingViewModel())
}
