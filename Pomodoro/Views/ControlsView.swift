import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var timerManager: TimerManager
    
    var sessionColor: Color {
        switch timerManager.sessionType {
        case .work:
            return Color(red: 0.92, green: 0.28, blue: 0.29)
        case .shortBreak:
            return Color(red: 0.30, green: 0.78, blue: 0.55)
        case .longBreak:
            return Color(red: 0.36, green: 0.55, blue: 0.86)
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Reset button
            Button(action: {
                timerManager.reset()
            }) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.secondary)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color.secondary.opacity(0.1))
                    )
            }
            .buttonStyle(.plain)
            .help("Reset timer")
            
            // Play/Pause button
            Button(action: {
                timerManager.toggle()
            }) {
                Image(systemName: timerManager.isRunning ? "pause.fill" : "play.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [sessionColor, sessionColor.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: sessionColor.opacity(0.4), radius: 8, y: 4)
                    )
            }
            .buttonStyle(.plain)
            .help(timerManager.isRunning ? "Pause" : "Start")
            
            // Skip button
            Button(action: {
                timerManager.skip()
            }) {
                Image(systemName: "forward.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.secondary)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color.secondary.opacity(0.1))
                    )
            }
            .buttonStyle(.plain)
            .help("Skip to next session")
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ControlsView()
        .environmentObject(TimerManager())
        .padding()
}
