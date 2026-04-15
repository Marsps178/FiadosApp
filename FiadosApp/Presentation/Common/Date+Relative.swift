import Foundation

extension Date {
    var relativeFormatted: String {
        if Calendar.current.isDateInToday(self) {
            return "Hoy"
        }
        if Calendar.current.isDateInYesterday(self) {
            return "Ayer"
        }
        return self.formatted(.dateTime.day().month(.abbreviated).year())
    }
}
