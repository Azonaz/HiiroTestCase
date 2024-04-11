import SwiftUI

struct TrainView: View {
    var training: Training
    @EnvironmentObject var viewModel: TrainingViewModel
    
    var body: some View {
        let imageHeight: CGFloat = 48
        let dateInfo = viewModel.formatDate(training.date)
        
        HStack (spacing: 16) {
            Image(training.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: imageHeight, height: imageHeight)
                .cornerRadius(imageHeight/2)
            
            VStack (alignment: .leading, spacing: 8) {
                Text(training.name)
                    .font(UIFont.book14)
                HStack (spacing: 16) {
                    Text(training.info)
                    Text(training.description)
                }
                .opacity(0.4)
                .font(UIFont.book14)
            }
            
            Spacer()
            
            VStack (alignment: .center, spacing: 8) {
                Text(dateInfo.dayOfWeek)
                    .font(UIFont.book11)
                    .opacity(0.6)
                    .padding(.bottom, 2)
                Text(dateInfo.dayOfMonth)
                    .font(UIFont.book14)
            }
        }
        .foregroundColor(.white)
        .background(.black)
    }
}

#Preview {
    TrainView(training: Training(name: "Intervals", imageName: "intervals", info: "8km", description: "200/400 rest", date: DateFormatter().date(from: "08.04.2024") ?? Date()))
        .padding()
        .environmentObject(TrainingViewModel())
}
