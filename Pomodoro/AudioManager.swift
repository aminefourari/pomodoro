import AVFoundation
import SwiftUI

enum LofiStation: String, CaseIterable {
    case lofi247 = "Lofi 247"
    
    var streamURL: URL {
        switch self {
        case .lofi247:
            return URL(string: "https://usa9.fastcast4u.com/proxy/jamz?mp=/1")!
        }
    }
}

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    @Published var isPlaying: Bool = false
    @AppStorage("lofiEnabled") var lofiEnabled: Bool = false
    @AppStorage("selectedStation") var selectedStationRaw: String = LofiStation.lofi247.rawValue
    @AppStorage("lofiVolume") var volume: Double = 0.7
    
    var selectedStation: LofiStation {
        get { LofiStation(rawValue: selectedStationRaw) ?? .lofi247 }
        set { selectedStationRaw = newValue.rawValue }
    }
    
    private var player: AVPlayer?
    
    private init() {}
    
    func play() {
        guard lofiEnabled else { return }
        
        let playerItem = AVPlayerItem(url: selectedStation.streamURL)
        player = AVPlayer(playerItem: playerItem)
        player?.volume = Float(volume)
        player?.play()
        isPlaying = true
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func resume() {
        guard lofiEnabled, player != nil else { 
            play()
            return 
        }
        player?.play()
        isPlaying = true
    }
    
    func stop() {
        player?.pause()
        player = nil
        isPlaying = false
    }
    
    func toggle() {
        if isPlaying {
            pause()
        } else {
            resume()
        }
    }
    
    func setVolume(_ newVolume: Double) {
        volume = newVolume
        player?.volume = Float(newVolume)
    }
}
