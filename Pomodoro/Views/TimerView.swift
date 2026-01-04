import SwiftUI

struct TimerView: View {
    @EnvironmentObject var timerManager: TimerManager
    
    var sessionColor: Color {
        switch timerManager.sessionType {
        case .work:
            return Color(red: 0.92, green: 0.28, blue: 0.29) // Tomato red
        case .shortBreak:
            return Color(red: 0.30, green: 0.78, blue: 0.55) // Fresh green
        case .longBreak:
            return Color(red: 0.36, green: 0.55, blue: 0.86) // Calm blue
        }
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(
                    sessionColor.opacity(0.2),
                    lineWidth: 12
                )
            
            // Progress circle
            Circle()
                .trim(from: 0, to: timerManager.progress)
                .stroke(
                    sessionColor,
                    style: StrokeStyle(
                        lineWidth: 12,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.3), value: timerManager.progress)
            
            // Time display
            VStack(spacing: 4) {
                Text(timerManager.formattedTime)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .monospacedDigit()
                
                Text(timerManager.sessionType.rawValue.uppercased())
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(sessionColor)
                    .tracking(1.5)
            }
        }
        .frame(width: 140, height: 140)
        .padding(.vertical, 8)
    }
}

#Preview {
    TimerView()
        .environmentObject(TimerManager())
        .padding()
}
