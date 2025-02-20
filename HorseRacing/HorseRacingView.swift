//
//  ContentView.swift
//  HorseRacing
//
//  Created by Oncu Can on 3.02.2025.
//

import SwiftUI
import AVFoundation

struct HorseRacingView: View {
    @State private var positions: [CGFloat] = Array(repeating: 0, count: 8)
    @State private var isRacing = false
    @State private var winner: Int? = nil
    @State private var audioPlayer: AVAudioPlayer?
    @State private var raceFinished = false
    
    let trackWidth: CGFloat = UIScreen.main.bounds.width - 40
    let horseSpacing: CGFloat = 20 // Increased spacing for larger horses
    let horseSize: CGFloat = 60 // Doubled from 30 to 60
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.green.opacity(0.3)]),
                          startPoint: .top,
                          endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Title
                HStack {
                    Text("Horse Racing")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 5, x: 0, y: 2)
                }
                
                // Race Track
                ZStack {
                    // Track background
                    RoundedRectangle(cornerRadius: 15)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [
                                Color.green.opacity(0.7),
                                Color.green.opacity(0.8)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(height: 400) // Increased height for larger horses
                        .overlay(
                            VStack(spacing: horseSpacing) {
                                ForEach(0..<9) { _ in
                                    Rectangle()
                                        .fill(Color.white.opacity(0.3))
                                        .frame(height: 1)
                                }
                            }
                        )
                        .overlay(
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
                    
                    // Finish line
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 4)
                        .offset(x: trackWidth/2 - 20)
                    
                    // Horses
                    ForEach(0..<8) { index in
                        Image("a")
                            .resizable()
                            .scaledToFit()
                            .frame(width: horseSize, height: horseSize)
                            .offset(x: positions[index] - trackWidth/2,
                                   y: CGFloat(index * 45) - 170) // Adjusted spacing and starting position
                    }
                }
                .padding(.horizontal)
                
                // Show Winner
                if raceFinished, let winner = winner {
                    Text("🏆 Horse \(winner + 1) wins! 🏆")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.yellow)
                        .shadow(color: .black, radius: 5, x: 0, y: 2)
                        .transition(.opacity)
                        .padding(.top, 20)
                }
                
                // Start Button
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
    
    // Rest of the code remains the same
    func startRace() {
        isRacing = true
        winner = nil
        raceFinished = false
        positions = Array(repeating: 0, count: 8)
        
        playSound(sound: "race-start", type: "mp3")
        
        let finishLine: CGFloat = trackWidth - 40
        var raceDurations: [Double] = (0..<8).map { _ in Double.random(in: 2...5) }
        
        for index in positions.indices {
            withAnimation(Animation.linear(duration: raceDurations[index])) {
                positions[index] = finishLine
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + raceDurations.min()!) {
            if let winningIndex = raceDurations.firstIndex(of: raceDurations.min()!) {
                winner = winningIndex
                raceFinished = true
                playSound(sound: "race-end", type: "mp3")
            }
        }
        
        let maxDuration = raceDurations.max() ?? 5
        DispatchQueue.main.asyncAfter(deadline: .now() + maxDuration + 2) {
            positions = Array(repeating: 0, count: 8)
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
