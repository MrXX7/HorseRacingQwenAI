//
//  ContentView.swift
//  HorseRacing
//
//  Created by Oncu Can on 3.02.2025.
//

import SwiftUI
import AVFAudio

struct HorseRacingView: View {
    @State private var positions: [CGFloat] = Array(repeating: 35, count: 8)
    @State private var isRacing = false
    @State private var winner: Int? = nil
    @State private var audioPlayer: AVAudioPlayer?
    @State private var raceFinished = false
    @State private var selectedHorse: Int? = nil
    @State private var showBettingView = false
    @State private var coins = 1000
    @State private var betAmount = 0
    @State private var horseNames = [
        "Thunder Bolt", "Silver Star", "Golden Flash",
        "Night Rider", "Wind Runner", "Storm Chaser",
        "Lightning Strike", "Desert King"
    ]
    @State private var horseSpeeds: [Double] = Array(repeating: 0, count: 8)
    @State private var timer: Timer? = nil
    
    let trackWidth: CGFloat = UIScreen.main.bounds.width * 2 // Yarış pistini daha uzun yap
    let horseSpacing: CGFloat = 20
    let horseSize: CGFloat = 60
    
    var body: some View {
        ZStack {
            // Arka plan
            LinearGradient(gradient: Gradient(colors: [
                Color(hex: "87CEEB"),
                Color(hex: "90EE90")
            ]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            
            // Bulutlar
            ForEach(0..<5) { i in
                Image(systemName: "cloud.fill")
                    .foregroundColor(.white.opacity(0.7))
                    .offset(x: CGFloat(i * 100) - 200, y: -200)
            }
            
            VStack(spacing: 20) {
                // Başlık
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
                
                // Coin Gösterimi
                HStack {
                    Image(systemName: "bitcoinsign.circle.fill")
                        .foregroundColor(.yellow)
                    Text("\(coins) Coins")
                        .font(.system(.title3, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .background(Color.black.opacity(0.3))
                .cornerRadius(15)
                
                // Yarış Pistini Kaydırma
                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        TrackView(positions: $positions,
                                isRacing: $isRacing,
                                horseNames: horseNames,
                                trackWidth: trackWidth,
                                horseSpacing: horseSpacing,
                                horseSize: horseSize)
                        .frame(width: trackWidth) // Pist genişliği
                    }
                    .onChange(of: positions) { newPositions in
                        if isRacing {
                            // Lider atın konumunu bul
                            let leadingHorsePosition = newPositions.max() ?? 0
                            // ScrollView'ı lider atın konumuna kaydır
                            withAnimation {
                                scrollProxy.scrollTo(leadingHorsePosition, anchor: .leading)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Kazananı Göster
                if raceFinished, let winner = winner {
                    WinnerView(horseNames: horseNames,
                             winner: winner,
                             selectedHorse: selectedHorse,
                             betAmount: betAmount)
                }
                
                // Kontrol Butonları
                HStack(spacing: 20) {
                    // Bahis Butonu
                    Button(action: {
                        showBettingView = true
                    }) {
                        Text("Place Bet")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    // Yarışı Başlat Butonu
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
                    
                    // Sıfırla Butonu
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
        .sheet(isPresented: $showBettingView) {
            BettingView(
                horseNames: horseNames,
                selectedHorse: $selectedHorse,
                betAmount: $betAmount,
                coins: $coins,
                isPresented: $showBettingView
            )
        }
    }
    
    func startRace() {
        guard !isRacing else { return }
        
        // Bahis kontrolü
        if let selectedHorse = selectedHorse {
            guard coins >= betAmount else { return }
            coins -= betAmount
        }
        
        startRaceSetup()
        
        // Yarış zamanlayıcısını başlat
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            updateHorsePositions()
        }
    }

    private func startRaceSetup() {
        isRacing = true
        winner = nil
        raceFinished = false
        positions = Array(repeating: 35, count: 8)
        horseSpeeds = (0..<8).map { _ in Double.random(in: 0.5...1.5) } // Atların hızını ayarla
    }

    private func updateHorsePositions() {
        for index in positions.indices {
            // Atların hızını rastgele ayarla
            let speedAdjustment = Double.random(in: -0.5...0.5)
            horseSpeeds[index] += speedAdjustment
            horseSpeeds[index] = max(0.5, min(2, horseSpeeds[index])) // Hız sınırlarını koru
            
            positions[index] += CGFloat(horseSpeeds[index])
            
            // Atların bitiş çizgisini geçip geçmediğini kontrol et
            if positions[index] >= trackWidth - horseSize - 40 {
                finishRace(winningHorse: index)
                return
            }
        }
    }

    private func finishRace(winningHorse: Int) {
        timer?.invalidate()
        timer = nil
        winner = winningHorse
        raceFinished = true
        processBetResult(winningIndex: winningHorse)
        
        // Otomatik olarak 2 saniye sonra sıfırla
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            resetRace()
        }
    }

    private func processBetResult(winningIndex: Int) {
        if let selectedHorse = selectedHorse {
            if selectedHorse == winningIndex {
                coins += betAmount * 2
                playSound(sound: "win", type: "mp3")
            } else {
                playSound(sound: "lose", type: "mp3")
            }
        }
    }

    private func resetRace() {
        withAnimation {
            positions = Array(repeating: 35, count: 8)
            isRacing = false
            raceFinished = false
            selectedHorse = nil
            betAmount = 0
        }
    }
    
    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch {
                print("Ses çalınamadı")
            }
        }
    }
}

struct HorseRacingView_Previews: PreviewProvider {
    static var previews: some View {
        HorseRacingView()
    }
}
