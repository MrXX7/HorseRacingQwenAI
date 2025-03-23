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
                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        TrackView(positions: $positions,
                                isRacing: $isRacing,
                                horseNames: horseNames,
                                trackWidth: trackWidth,
                                horseSpacing: horseSpacing,
                                horseSize: horseSize)
                        .frame(width: trackWidth) // Match the track width
                    }
                    .onChange(of: positions) { newPositions in
                        if isRacing {
                            // Find the leading horse's position
                            let leadingHorsePosition = newPositions.max() ?? 0
                            // Scroll to the leading horse's position
                            withAnimation {
                                scrollProxy.scrollTo(leadingHorsePosition, anchor: .leading)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                HStack(spacing: 20) {
                    // Start Race Button
                    Button(action: {
                        startRace()
                    }) {
                        Text(isRacing ? "Racing..." : "Start Race")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                            .background(isRacing ? Color.gray : Color.green)
                            .cornerRadius(10)
                    }
                    .disabled(isRacing)
                    
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
            }
            .padding(.vertical)
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

    private func startRaceSetup() {
        isRacing = true
        winner = nil
        raceFinished = false
        positions = Array(repeating: 20, count: 8)
        horseSpeeds = (0..<8).map { _ in Double.random(in: 0.5...1.2) } // Adjust horse speeds
    }

    private func updateHorsePositions() {
        let finishLine = trackWidth - horseSize - 40 // Bitiş çizgisi konumu
        
        for index in positions.indices {
            // Eğer at zaten bitiş çizgisini geçtiyse, diğer atlara odaklan
            if positions[index] >= finishLine {
                continue // Bu atı atla ve diğer atları güncellemeye devam et
            }
            
            // Rastgele hız ayarlaması yap
            let speedAdjustment = Double.random(in: -0.1...0.1) // Daha küçük ayarlama
            horseSpeeds[index] += speedAdjustment
            horseSpeeds[index] = max(0.5, min(1.2, horseSpeeds[index])) // Hızı sınırla
            
            // Atın konumunu güncelle
            positions[index] += CGFloat(horseSpeeds[index])
            
            // Debug: At hızı ve konumunu logla
            print("Horse \(index) speed: \(horseSpeeds[index]), position: \(positions[index])")
            
            // Bitiş çizgisini geçti mi kontrol et
            if positions[index] >= finishLine {
                // Kazanan atı işle (birden fazla at bitirebilir)
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
        }
    }

    private func resetRace() {
            withAnimation {
                positions = Array(repeating: 0, count: 8)
                isRacing = false
                raceFinished = false
                finishedHorses.removeAll() // Bitiren atların listesini temizle
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
