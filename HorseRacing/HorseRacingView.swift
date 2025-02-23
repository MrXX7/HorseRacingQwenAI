//
//  ContentView.swift
//  HorseRacing
//
//  Created by Oncu Can on 3.02.2025.
//

import SwiftUI
import AVFAudio

// Renk hex değeri için extension
struct HorseRacingView: View {
    @State private var positions: [CGFloat] = Array(repeating: 0, count: 8)
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
    @State private var startingPositions: [CGFloat] = Array(repeating: 0, count: 8)
    @State private var scrollOffset: CGFloat = 0
    
    let trackWidth: CGFloat = UIScreen.main.bounds.width * 1.5
    let horseSpacing: CGFloat = 20
    let horseSize: CGFloat = 60
    
    var body: some View {
        ZStack {
            // Arkaplan
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
                
                // Coin Göstergesi
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
                
                // Yarış Pisti
                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        TrackView(positions: $positions,
                                isRacing: $isRacing,
                                horseNames: horseNames,
                                trackWidth: trackWidth,
                                horseSpacing: horseSpacing,
                                horseSize: horseSize)
                    }
                    .onChange(of: positions) { newPositions in
                        if isRacing {
                            let leadingHorsePosition = newPositions.max() ?? 0
                            let scrollPosition = max(0, leadingHorsePosition - UIScreen.main.bounds.width / 2)
                            withAnimation {
                                scrollProxy.scrollTo("horse0", anchor: .leading)
                                scrollOffset = scrollPosition
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Kazanan Göstergesi
                if raceFinished, let winner = winner {
                    WinnerView(horseNames: horseNames,
                             winner: winner,
                             selectedHorse: selectedHorse,
                             betAmount: betAmount)
                }
                
                // Kontrol Butonları
                ControlButtonsView(isRacing: $isRacing,
                                 showBettingView: $showBettingView,
                                 startRace: startRace)
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
        
        let finishLine = calculateFinishLine()
        let raceDurations = generateRaceDurations()
        
        animateHorsesToFinishLine(finishLine: finishLine, raceDurations: raceDurations)
        
        determineWinner(raceDurations: raceDurations)
        
        resetRaceAfterCompletion(raceDurations: raceDurations)
    }

    private func startRaceSetup() {
        isRacing = true
        winner = nil
        raceFinished = false
        startingPositions = positions
    }

    private func calculateFinishLine() -> CGFloat {
        return trackWidth - horseSize - 40
    }

    private func generateRaceDurations() -> [Double] {
        return (0..<8).map { _ in Double.random(in: 15...20) }
    }

    private func animateHorsesToFinishLine(finishLine: CGFloat, raceDurations: [Double]) {
        for index in positions.indices {
            let distanceToFinish = finishLine - startingPositions[index]
            withAnimation(Animation.linear(duration: raceDurations[index]).delay(0.1)) {
                positions[index] += distanceToFinish
            }
        }
    }

    private func determineWinner(raceDurations: [Double]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + raceDurations.min()!) {
            if let winningIndex = raceDurations.firstIndex(of: raceDurations.min()!) {
                winner = winningIndex
                raceFinished = true
                processBetResult(winningIndex: winningIndex)
            }
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

    private func resetRaceAfterCompletion(raceDurations: [Double]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + raceDurations.max()! + 2) {
            withAnimation {
                positions = Array(repeating: 0, count: 8)
                isRacing = false
                selectedHorse = nil
                betAmount = 0
            }
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
