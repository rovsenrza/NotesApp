import Foundation

extension Date {
    func timeAgo() -> String {
        let seconds = Int(Date().timeIntervalSince(self))

        if seconds < 60 {
            return "Just now"
        }

        let minutes = seconds / 60
        if minutes < 60 {
            return "\(minutes) min ago"
        }

        let hours = minutes / 60
        if hours < 24 {
            return "\(hours) h ago"
        }

        let days = hours / 24
        if days < 7 {
            return days == 1 ? "Yesterday" : "\(days) days ago"
        }

        let weeks = days / 7
        if weeks < 4 {
            return "\(weeks) weeks ago"
        }

        let months = days / 30
        if months < 12 {
            return "\(months) months ago"
        }

        let years = days / 365
        return "\(years) years ago"
    }
}
