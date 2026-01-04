import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var timerManager: TimerManager
    @ObservedObject var audioManager = AudioManager.shared
    @Binding var showingSettings: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showingSettings = false
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 12, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 13))
                    }
                    .foregroundColor(.accentColor)
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                Text("Settings")
                    .font(.system(size: 15, weight: .semibold))
                
                Spacer()
                
                // Invisible spacer for centering
                Text("Back")
                    .font(.system(size: 13))
                    .opacity(0)
            }
            .padding(.bottom, 4)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Duration Settings
                    VStack(alignment: .leading, spacing: 12) {
                        Text("DURATIONS")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.secondary)
                            .tracking(1)
                        
                        DurationStepper(
                            label: "Work",
                            value: $timerManager.workDuration,
                            icon: "brain.head.profile",
                            color: Color(red: 0.92, green: 0.28, blue: 0.29)
                        )
                        
                        DurationStepper(
                            label: "Short Break",
                            value: $timerManager.shortBreakDuration,
                            icon: "cup.and.saucer.fill",
                            color: Color(red: 0.30, green: 0.78, blue: 0.55)
                        )
                        
                        DurationStepper(
                            label: "Long Break",
                            value: $timerManager.longBreakDuration,
                            icon: "figure.walk",
                            color: Color(red: 0.36, green: 0.55, blue: 0.86)
                        )
                    }
                    
                    Divider()
                    
                    // Auto-start Settings
                    VStack(alignment: .leading, spacing: 12) {
                        Text("AUTO-START")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.secondary)
                            .tracking(1)
                        
                        SettingsToggle(
                            title: "Auto-start breaks",
                            isOn: $timerManager.autoStartBreaks
                        )
                        
                        SettingsToggle(
                            title: "Auto-start pomodoros",
                            isOn: $timerManager.autoStartPomodoros
                        )
                    }
                    
                    Divider()
                    
                    // Sound Settings
                    VStack(alignment: .leading, spacing: 12) {
                        Text("NOTIFICATIONS")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.secondary)
                            .tracking(1)
                        
                        SettingsToggle(
                            title: "Sound enabled",
                            isOn: $timerManager.soundEnabled
                        )
                    }
                    
                    Divider()
                    
                    // Lofi Radio Settings
                    VStack(alignment: .leading, spacing: 12) {
                        Text("FOCUS MUSIC")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.secondary)
                            .tracking(1)
                        
                        SettingsToggle(
                            title: "Lofi radio during work",
                            isOn: $audioManager.lofiEnabled
                        )
                        
                        if audioManager.lofiEnabled {
                            HStack {
                                Text("Station")
                                    .font(.system(size: 13))
                                
                                Spacer()
                                
                                Picker("", selection: $audioManager.selectedStationRaw) {
                                    ForEach(LofiStation.allCases, id: \.rawValue) { station in
                                        Text(station.rawValue).tag(station.rawValue)
                                    }
                                }
                                .pickerStyle(.menu)
                                .frame(width: 120)
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .onChange(of: timerManager.workDuration) { _ in
            timerManager.updateDurations()
        }
        .onChange(of: timerManager.shortBreakDuration) { _ in
            timerManager.updateDurations()
        }
        .onChange(of: timerManager.longBreakDuration) { _ in
            timerManager.updateDurations()
        }
    }
}

struct SettingsToggle: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 13))
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(.switch)
                .labelsHidden()
                .scaleEffect(0.8)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isOn.toggle()
        }
    }
}

struct DurationStepper: View {
    let label: String
    @Binding var value: Int
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(label)
                .font(.system(size: 13))
            
            Spacer()
            
            HStack(spacing: 8) {
                Button(action: {
                    if value > 1 { value -= 1 }
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.secondary)
                        .frame(width: 22, height: 22)
                        .background(Circle().fill(Color.secondary.opacity(0.15)))
                }
                .buttonStyle(.plain)
                
                Text("\(value)")
                    .font(.system(size: 13, weight: .medium).monospacedDigit())
                    .frame(width: 24)
                
                Button(action: {
                    if value < 60 { value += 1 }
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.secondary)
                        .frame(width: 22, height: 22)
                        .background(Circle().fill(Color.secondary.opacity(0.15)))
                }
                .buttonStyle(.plain)
                
                Text("min")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .frame(width: 22, alignment: .leading)
            }
        }
    }
}

#Preview {
    SettingsView(showingSettings: .constant(true))
        .environmentObject(TimerManager())
        .frame(width: 280)
}
