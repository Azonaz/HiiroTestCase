import Foundation

struct Training: Identifiable, Hashable {
    var id = UUID()
    var type: String
    var iconName: String
    var info: String
    var description: String
    var date: Date
}
