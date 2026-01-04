import SwiftUI

@main
struct PomodoroApp: App {
    @StateObject private var timerManager = TimerManager()
    
    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environmentObject(timerManager)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: timerManager.menuBarIcon)
                Text(timerManager.menuBarTitle)
                    .monospacedDigit()
            }
        }
        .menuBarExtraStyle(.window)
    }
}
