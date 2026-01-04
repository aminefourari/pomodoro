import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func sendNotification(title: String, body: String, sound: Bool = true) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        if sound {
            content.sound = .default
        }
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil // Deliver immediately
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to send notification: \(error.localizedDescription)")
            }
        }
    }
    
    func sendFiveMinuteWarning() {
        sendNotification(
            title: "⏰ 5 Minutes Left!",
            body: "Finish up your current task. Break time is coming soon."
        )
    }
    
    func sendSessionCompleteNotification(for sessionType: SessionType, nextSession: SessionType) {
        let title: String
        let body: String
        
        switch sessionType {
        case .work:
            title = "🍅 Pomodoro Complete!"
            body = "Great work! Time for a \(nextSession.rawValue.lowercased())."
        case .shortBreak:
            title = "☕ Break Over"
            body = "Ready to focus? Let's start another pomodoro!"
        case .longBreak:
            title = "🚶 Long Break Over"
            body = "Feeling refreshed? Time to get back to work!"
        }
        
        sendNotification(title: title, body: body)
    }
}
