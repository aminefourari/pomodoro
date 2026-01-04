enum SessionType: String, CaseIterable {
    case work = "Work"
    case shortBreak = "Short Break"
    case longBreak = "Long Break"
    
    var defaultDuration: Int {
        switch self {
        case .work:
            return 25 * 60 // 25 minutes
        case .shortBreak:
            return 5 * 60  // 5 minutes
        case .longBreak:
            return 15 * 60 // 15 minutes
        }
    }
    
    var colorName: String {
        switch self {
        case .work:
            return "WorkColor"
        case .shortBreak:
            return "ShortBreakColor"
        case .longBreak:
            return "LongBreakColor"
        }
    }
    
    var icon: String {
        switch self {
        case .work:
            return "brain.head.profile"
        case .shortBreak:
            return "cup.and.saucer.fill"
        case .longBreak:
            return "figure.walk"
        }
    }
    
    var emoji: String {
        switch self {
        case .work:
            return "🍅"
        case .shortBreak:
            return "☕"
        case .longBreak:
            return "🚶"
        }
    }
}
