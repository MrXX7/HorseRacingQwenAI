//
//  ContentView.swift
//  HorseRacing
//
//  Created by Oncu Can on 3.02.2025.
//

import SwiftUI
import AVFAudio

struct HorseRacingView: View {
    @State private var positions: [CGFloat] = Array(repeating: 20, count: 8)
    @State private var isRacing = false
    @State private var isPaused = false
    @State private var winner: Int? = nil
    @State private var audioPlayer: AVAudioPlayer?
    @State private var raceFinished = false
    @State private var horseNames = [
        "Thunder Bolt", "Silver Star", "Golden Flash",
        "Night Rider", "Wind Runner", "Storm Chaser",
        "Lightning Strike", "Desert King"
    ]
    @State private var horseSpeeds: [Double] = Array(repeating: 0, count: 8)
    @State private var timer: Timer? = nil
    @State private var finishedHorses: [Int] = []
    
    let trackWidth: CGFloat = UIScreen.main.bounds.width * 2 // Track width
    let horseSpacing: CGFloat = 20
    let horseSize: CGFloat = 60
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(gradient: Gradient(colors: [
                Color(hex: "87CEEB"),
                Color(hex: "90EE90")
            ]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            
            // Clouds
            ForEach(0..<5) { i in
                Image(systemName: "cloud.fill")
                    .foregroundColor(.white.opacity(0.7))
                    .offset(x: CGFloat(i * 100) - 200, y: -200)
            }
            
            VStack(spacing: 20) {
                // Title
                HStack {
                    Image(systemName: "flag.fill")
                        .foregroundColor(.yellow)
                    Text("Horse Racing")
                        .font(.custom("AvenirNext-Bold", size: 40))
                        .foregroundColor(.white)
                    Image(systemName: "flag.fill")
                        .foregroundColor(.yellow)
                }
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                
                // Race Track with ScrollView
                ScrollView(.horizontal, showsIndicators: false) {
                    TrackView(positions: $positions,
                              isRacing: $isRacing,
                              horseNames: horseNames,
                              trackWidth: trackWidth,
                              horseSpacing: horseSpacing,
                              horseSize: horseSize)
                    .frame(width: trackWidth)
                }
                .padding(.horizontal)
                
                HStack(spacing: 20) {
                    // Start/Continue Race Button
                    Button(action: {
                        if !isRacing {
                            startRace()
                        } else if isPaused {
                            continuRace()
                        }
                    }) {
                        Text(determineStartButtonText())
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                            .background(determineStartButtonColor())
                            .cornerRadius(10)
                    }
                    .disabled(raceFinished)
                    
                    // Pause Button
                    if isRacing && !raceFinished {
                        Button(action: {
                            pauseRace()
                        }) {
                            Text("Pause")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(10)
                        }
                    }
                    
                    // Reset Button
                    if raceFinished {
                        Button(action: {
                            resetRace()
                        }) {
                            Text("Reset")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.vertical)
            }
        }
    }
    
    private func determineStartButtonText() -> String {
        if !isRacing {
            return "Start Race"
        } else if isPaused {
            return "Continue"
        } else {
            return "Racing..."
        }
    }
    
    private func determineStartButtonColor() -> Color {
        if !isRacing {
            return .green
        } else if isPaused {
            return .green
        } else {
            return .gray
        }
    }
    
    func startRace() {
        guard !isRacing else { return }
        
        startRaceSetup()
        
        // Start the race timer
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            updateHorsePositions()
        }
    }
    
    func pauseRace() {
        isPaused = true
        timer?.invalidate()
        timer = nil
    }
    
    func continuRace() {
        isPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            updateHorsePositions()
        }
    }

    private func startRaceSetup() {
        isRacing = true
        isPaused = false
        winner = nil
        raceFinished = false
        positions = Array(repeating: 20, count: 8)
        horseSpeeds = (0..<8).map { _ in Double.random(in: 0.5...1.2) }
        finishedHorses.removeAll()
    }

    func updateHorsePositions() {
        guard isRacing, !isPaused else { return }
        
        let finishLine = trackWidth - horseSize - 40 // Bitiş çizgisi konumu
        
        for index in positions.indices {
            // Eğer at zaten bitiş çizgisini geçtiyse, diğer atlara odaklan
            if positions[index] >= finishLine {
                continue
            }
            
            // Rastgele hız ayarlaması yap - daha dengeli bir aralık kullanıyoruz
            let speedAdjustment = Double.random(in: -0.08...0.12)
            horseSpeeds[index] += speedAdjustment
            
            // Hız sınırları - minimum ve maksimum değerleri ayarladık
            horseSpeeds[index] = max(0.6, min(1.5, horseSpeeds[index]))
            
            // Atın konumunu güncelle
            positions[index] += CGFloat(horseSpeeds[index])
            
            // Bitiş çizgisini geçti mi kontrol et
            if positions[index] >= finishLine {
                // Atın tam olarak bitiş çizgisinde durmasını sağla
                positions[index] = finishLine
                // Kazanan atı işle
                finishRace(winningHorse: index)
            }
        }
    }

    private func finishRace(winningHorse: Int) {
        // Kazanan atı listeye ekle
        if !finishedHorses.contains(winningHorse) {
            finishedHorses.append(winningHorse)
        }
        
        // Tüm atlar bitirdiyse yarışı sonlandır
        if finishedHorses.count == horseNames.count {
            timer?.invalidate()
            timer = nil
            raceFinished = true
            isRacing = false
        }
    }

    private func resetRace() {
        withAnimation {
            positions = Array(repeating: 20, count: 8)
            isRacing = false
            isPaused = false
            raceFinished = false
            finishedHorses.removeAll()
            horseSpeeds = Array(repeating: 0, count: 8)
            timer?.invalidate()
            timer = nil
        }
    }
    
    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch {
                print("Failed to play sound")
            }
        }
    }
}

struct HorseRacingView_Previews: PreviewProvider {
    static var previews: some View {
        HorseRacingView()
    }
}
