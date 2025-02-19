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
    
    let trackWidth: CGFloat = UIScreen.main.bounds.width - 40
    let horseSpacing: CGFloat = 10
    
    var body: some View {
        ZStack {
            // Arka plan
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.green.opacity(0.3)]),
                          startPoint: .top,
                          endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Başlık
                Text("🏇 Horse Racing 🏇")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 5, x: 0, y: 2)
                
                // Yarış Pisti
                ZStack {
                    // Çim pist arka planı
                    RoundedRectangle(cornerRadius: 15)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [
                                Color.green.opacity(0.7),
                                Color.green.opacity(0.8)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(height: 200)
                        .overlay(
                            // Pist çizgileri
                            VStack(spacing: horseSpacing) {
                                ForEach(0..<6) { _ in
                                    Rectangle()
                                        .fill(Color.white.opacity(0.3))
                                        .frame(height: 1)
                                }
                            }
                        )
                        .overlay(
                            // Çim dokusu efekti
                            Rectangle()
                                .fill(Color.green.opacity(0.2))
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.green.opacity(0.1),
                                            Color.green.opacity(0.3)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        )
                    
                    // Bitiş çizgisi
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 4)
                        .offset(x: trackWidth/2 - 20)
                    
                    // Atlar
                    ForEach(0..<5) { index in
                        Text(horseIcons[index])
                            .font(.system(size: 30))
                            .offset(x: positions[index] - trackWidth/2,
                                    y: CGFloat(index * 35) - 80)
                            .animation(.linear(duration: Double.random(in: 2...5)), value: positions[index])
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
    
    let horseIcons: [String] = ["🏇", "🏇", "🏇", "🏇", "🏇"]
    
    func startRace() {
        isRacing = true
        winner = nil
        positions = [0, 0, 0, 0, 0]
        
        playSound(sound: "race-start", type: "mp3")
        
        let finishLine: CGFloat = trackWidth - 40
        var winnerIndex: Int? = nil
        
        for index in positions.indices {
            let randomDuration = Double.random(in: 2...5)
            withAnimation(Animation.linear(duration: randomDuration)) {
                positions[index] = finishLine
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + randomDuration) {
                if winnerIndex == nil {
                    winnerIndex = index
                    winner = winnerIndex
                    playSound(sound: "race-end", type: "mp3")
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            positions = [0, 0, 0, 0, 0]
            isRacing = false
        }
    }
    
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
