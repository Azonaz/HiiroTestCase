import Foundation

struct Training: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var imageName: String
    var info: String
    var description: String
    var date: Date
}
