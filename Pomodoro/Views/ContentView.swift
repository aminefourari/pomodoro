import SwiftUI

struct ContentView: View {
    @EnvironmentObject var timerManager: TimerManager
    @ObservedObject var audioManager = AudioManager.shared
    @State private var showingSettings = false
    
    var body: some View {
        Group {
            if showingSettings {
                SettingsView(showingSettings: $showingSettings)
                    .environmentObject(timerManager)
            } else {
                mainView
            }
        }
        .frame(width: 280, height: 420)
        .background(
            VisualEffectBlur()
        )
    }
    
    var mainView: some View {
        VStack(spacing: 0) {
            // Main content
            VStack(spacing: 16) {
                // Session type header
                HStack {
                    Text(timerManager.sessionType.emoji)
                        .font(.system(size: 20))
                    Text(timerManager.sessionType.rawValue.uppercased())
                        .font(.system(size: 12, weight: .bold))
                        .tracking(2)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 16)
                
                // Timer display
                TimerView()
                
                // Controls
                ControlsView()
                
                // Pomodoro counter
                PomodoroCounter(count: timerManager.completedPomodoros)
                    .padding(.bottom, 4)
                
                // Music controls (compact)
                if audioManager.lofiEnabled {
                    HStack(spacing: 12) {
                        Button(action: { audioManager.toggle() }) {
                            Image(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.accentColor)
                        }
                        .buttonStyle(.plain)
                        
                        Image(systemName: "speaker.fill")
                            .font(.system(size: 8))
                            .foregroundColor(.secondary)
                        
                        Slider(value: $audioManager.volume, in: 0...1) { _ in
                            audioManager.setVolume(audioManager.volume)
                        }
                        .frame(width: 80)
                        
                        Image(systemName: "speaker.wave.3.fill")
                            .font(.system(size: 8))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Divider()
                .padding(.vertical, 8)
            
            // Bottom bar
            HStack {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showingSettings = true
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "power")
                        Text("Quit")
                    }
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
    }
}

struct PomodoroCounter: View {
    let count: Int
    
    var body: some View {
        HStack(spacing: 4) {
            Text("Pomodoros:")
                .font(.system(size: 11))
                .foregroundColor(.secondary)
            
            HStack(spacing: 4) {
                ForEach(0..<4) { index in
                    Circle()
                        .fill(index < (count % 4) || (count > 0 && count % 4 == 0 && index < 4) 
                              ? Color(red: 0.92, green: 0.28, blue: 0.29) 
                              : Color.secondary.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            
            if count >= 4 {
                Text("×\(count / 4)")
                    .font(.system(size: 11, weight: .bold).monospacedDigit())
                    .foregroundColor(Color(red: 0.92, green: 0.28, blue: 0.29))
            }
        }
    }
}

struct VisualEffectBlur: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        view.state = .active
        view.material = .popover
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}

#Preview {
    ContentView()
        .environmentObject(TimerManager())
}
