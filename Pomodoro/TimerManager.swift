import Foundation
import SwiftUI
import Combine

class TimerManager: ObservableObject {
    // MARK: - Published Properties
    @Published var timeRemaining: Int
    @Published var isRunning: Bool = false
    @Published var sessionType: SessionType = .work
    @Published var completedPomodoros: Int = 0
    
    // MARK: - Settings (persisted)
    @AppStorage("workDuration") var workDuration: Int = 25
    @AppStorage("shortBreakDuration") var shortBreakDuration: Int = 5
    @AppStorage("longBreakDuration") var longBreakDuration: Int = 15
    @AppStorage("autoStartBreaks") var autoStartBreaks: Bool = true
    @AppStorage("autoStartPomodoros") var autoStartPomodoros: Bool = false
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    
    // MARK: - Private Properties
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    var menuBarTitle: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var menuBarIcon: String {
        if isRunning {
            return sessionType == .work ? "timer" : "cup.and.saucer.fill"
        } else {
            return "timer"
        }
    }
    
    var progress: Double {
        let total = currentSessionDuration
        guard total > 0 else { return 0 }
        return Double(total - timeRemaining) / Double(total)
    }
    
    var currentSessionDuration: Int {
        switch sessionType {
        case .work:
            return workDuration * 60
        case .shortBreak:
            return shortBreakDuration * 60
        case .longBreak:
            return longBreakDuration * 60
        }
    }
    
    var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Initialization
    init() {
        self.timeRemaining = 25 * 60 // Default to 25 minutes
        NotificationManager.shared.requestPermission()
    }
    
    // MARK: - Timer Controls
    func start() {
        guard !isRunning else { return }
        isRunning = true
        
        // Play lofi music when starting a work session
        if sessionType == .work {
            AudioManager.shared.play()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    func pause() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        AudioManager.shared.stop()
    }
    
    func reset() {
        pause()
        timeRemaining = currentSessionDuration
    }
    
    func skip() {
        pause()
        advanceToNextSession()
    }
    
    func toggle() {
        if isRunning {
            pause()
        } else {
            start()
        }
    }
    
    // MARK: - Private Methods
    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            
            // Send 5-minute warning during work sessions
            if sessionType == .work && timeRemaining == 300 {
                NotificationManager.shared.sendFiveMinuteWarning()
            }
        } else {
            completeSession()
        }
    }
    
    private func completeSession() {
        pause()
        
        let nextSession = determineNextSession()
        
        // Send notification
        NotificationManager.shared.sendSessionCompleteNotification(
            for: sessionType,
            nextSession: nextSession
        )
        
        // Increment pomodoro count if completed a work session
        if sessionType == .work {
            completedPomodoros += 1
        }
        
        // Advance to next session
        sessionType = nextSession
        timeRemaining = currentSessionDuration
        
        // Auto-start if enabled
        let shouldAutoStart = (sessionType == .work && autoStartPomodoros) ||
                             (sessionType != .work && autoStartBreaks)
        if shouldAutoStart {
            start()
        }
    }
    
    private func determineNextSession() -> SessionType {
        switch sessionType {
        case .work:
            // Every 4th pomodoro, take a long break
            if (completedPomodoros + 1) % 4 == 0 {
                return .longBreak
            }
            return .shortBreak
        case .shortBreak, .longBreak:
            return .work
        }
    }
    
    private func advanceToNextSession() {
        sessionType = determineNextSession()
        timeRemaining = currentSessionDuration
    }
    
    // MARK: - Settings Updates
    func updateDurations() {
        if !isRunning {
            timeRemaining = currentSessionDuration
        }
    }
}
