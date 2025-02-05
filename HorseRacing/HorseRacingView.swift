//
//  ContentView.swift
//  HorseRacing
//
//  Created by Oncu Can on 3.02.2025.
//

import SwiftUI
import AVFoundation

struct HorseRacingView: View {
    @State private var positions: [CGFloat] = [0, 0, 0, 0, 0]
    @State private var isRacing = false
    @State private var winner: Int? = nil
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        ZStack {
            // Arka plan
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.green.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Başlık
                Text("🏇 Horse Racing 🏇")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 5, x: 0, y: 2)
                
                // Yarış Pistleri
                VStack(spacing: 10) {
                    ForEach(0..<5) { index in
                        TrackView(horsePosition: $positions[index], isRacing: $isRacing, horseColor: colors[index], horseIcon: horseIcons[index])
                    }
                }
                .padding(.horizontal)
                
                // Kazananı Göster
                if let winner = winner {
                    Text("🏆 Horse \(winner + 1) wins! 🏆")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.yellow)
                        .shadow(color: .black, radius: 5, x: 0, y: 2)
                        .transition(.opacity)
                        .padding(.top, 20)
                }
                
                // Başlat Butonu
                Button(action: {
                    self.startRace()
                }) {
                    Text(isRacing ? "Racing..." : "Start Race")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isRacing ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(color: .black, radius: 5, x: 0, y: 5)
                }
                .disabled(isRacing)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
    
    // Atların renkleri
    let colors: [Color] = [.red, .green, .blue, .orange, .purple]
    
    // Atların ikonları
    let horseIcons: [String] = ["🐎", "🏇", "🦄", "🐴", "🚀"]
    
    func startRace() {
        isRacing = true
        winner = nil
        
        // Pozisyonları sıfırla
        positions = [0, 0, 0, 0, 0]
        
        // Ses efekti çal
        playSound(sound: "race-start", type: "mp3")
        
        // Bitiş çizgisi
        let finishLine: CGFloat = 300
        var winnerIndex: Int? = nil
        
        for index in positions.indices {
            let randomDuration = Double.random(in: 2...5)
            withAnimation(Animation.linear(duration: randomDuration)) {
                positions[index] = finishLine
            }
            
            // Kazananı belirle
            DispatchQueue.main.asyncAfter(deadline: .now() + randomDuration) {
                if winnerIndex == nil {
                    winnerIndex = index
                    winner = winnerIndex
                    playSound(sound: "race-end", type: "mp3") // Kazanan sesi
                }
            }
        }
        
        // Yarışı sıfırla
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            positions = [0, 0, 0, 0, 0]
            isRacing = false
        }
    }
    
    // Ses çalma fonksiyonu
    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch {
                print("Ses dosyası çalınamadı.")
            }
        }
    }
}




struct HorseRacingView_Previews: PreviewProvider {
    static var previews: some View {
        HorseRacingView()
    }
}
