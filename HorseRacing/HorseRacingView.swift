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
    @State private var selectedHorse: Int? = nil
    @State private var showBettingView = false
    @State private var coins = 1000
    @State private var betAmount = 0
    @State private var horseNames = [
        "Thunder Bolt", "Silver Star", "Golden Flash",
        "Night Rider", "Wind Runner", "Storm Chaser",
        "Lightning Strike", "Desert King"
    ]
    
    let trackWidth: CGFloat = UIScreen.main.bounds.width * 1.5
    let horseSpacing: CGFloat = 20
    let horseSize: CGFloat = 60
    
    var body: some View {
        ZStack {
            // Zenginleştirilmiş Arkaplan
            LinearGradient(gradient: Gradient(colors: [
                Color(hex: "87CEEB"),
                Color(hex: "90EE90")
            ]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            
            // Dekoratif Bulutlar
            ForEach(0..<5) { i in
                Image(systemName: "cloud.fill")
                    .foregroundColor(.white.opacity(0.7))
                    .offset(x: CGFloat(i * 100) - 200, y: -200)
            }
            
            VStack(spacing: 20) {
                // Geliştirilmiş Başlık
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
                ScrollView(.horizontal, showsIndicators: false) {
                    ZStack {
                        // Geliştirilmiş Pist Arkaplanı
                        RoundedRectangle(cornerRadius: 15)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(hex: "8B4513").opacity(0.3),
                                    Color(hex: "8B4513").opacity(0.4)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .frame(width: trackWidth, height: 400)
                            .overlay(
                                VStack(spacing: horseSpacing) {
                                    ForEach(0..<9) { _ in
                                        Rectangle()
                                            .fill(Color.white.opacity(0.3))
                                            .frame(height: 1)
                                    }
                                }
                            )
                        
                        // Bitiş Çizgisi
                        HStack(spacing: 5) {
                            ForEach(0..<4) { i in
                                Rectangle()
                                    .fill(i % 2 == 0 ? Color.black : Color.white)
                                    .frame(width: 10, height: 400)
                            }
                        }
                        .offset(x: trackWidth/2 - horseSize - 20)
                        
                        // Atlar ve İsimleri
                        ForEach(0..<8) { index in
                            HStack {
                                Text(horseNames[index])
                                    .font(.system(size: 12, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 5)
                                    .background(Color.black.opacity(0.5))
                                    .cornerRadius(5)
                                
                                Image("a")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: horseSize, height: horseSize)
                                    .rotation3DEffect(.degrees(isRacing ? 10 : 0), axis: (x: 0, y: 1, z: 0))
                                    .shadow(color: .black.opacity(0.3), radius: 3)
                            }
                            .offset(x: positions[index] - trackWidth/2,
                                   y: CGFloat(index * 45) - 156)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Kazanan Göstergesi
                if raceFinished, let winner = winner {
                    VStack {
                        Text("🏆 \(horseNames[winner]) Wins! 🏆")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.yellow)
                        
                        if selectedHorse == winner {
                            Text("You won \(betAmount * 2) coins! 🎉")
                                .font(.title3)
                                .foregroundColor(.green)
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                    .padding(.vertical)
                }
                
                // Kontrol Butonları
                HStack(spacing: 20) {
                    // Bahis Butonu
                    Button(action: { showBettingView = true }) {
                        HStack {
                            Image(systemName: "dollarsign.circle.fill")
                            Text("Place Bet")
                        }
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    }
                    .disabled(isRacing)
                    
                    // Başlat Butonu
                    Button(action: { startRace() }) {
                        HStack {
                            Image(systemName: isRacing ? "flag.fill" : "flag")
                            Text(isRacing ? "Racing..." : "Start Race")
                        }
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isRacing ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    }
                    .disabled(isRacing)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
            
            // Bahis Sheet'i
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
    }
    
    func startRace() {
        guard !isRacing else { return }
        
        isRacing = true
        winner = nil
        raceFinished = false
        positions = Array(repeating: 0, count: 8)
        
        playSound(sound: "race-start", type: "mp3")
        
        let finishLine: CGFloat = trackWidth - horseSize - 40
        
        // Yarış sürelerini 15-20 saniye arasına ayarlıyoruz
        var raceDurations: [Double] = (0..<8).map { _ in Double.random(in: 15...20) }
        
        // Animasyonlar
        for index in positions.indices {
            withAnimation(Animation.linear(duration: raceDurations[index])) {
                positions[index] = finishLine
            }
        }
        
        // Kazananı Belirleme
        DispatchQueue.main.asyncAfter(deadline: .now() + raceDurations.min()!) {
            if let winningIndex = raceDurations.firstIndex(of: raceDurations.min()!) {
                winner = winningIndex
                raceFinished = true
                playSound(sound: "race-end", type: "mp3")
                
                // Bahis Sonuçları
                if let selectedHorse = selectedHorse {
                    if selectedHorse == winningIndex {
                        coins += betAmount * 2
                        playSound(sound: "win", type: "mp3")
                    }
                }
            }
        }
        
        // Yarışı Sıfırlama
        let maxDuration = raceDurations.max() ?? 20
        DispatchQueue.main.asyncAfter(deadline: .now() + maxDuration + 2) {
            withAnimation {
                positions = Array(repeating: 0, count: 8)
                isRacing = false
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

// Bahis Görünümü
struct BettingView: View {
    let horseNames: [String]
    @Binding var selectedHorse: Int?
    @Binding var betAmount: Int
    @Binding var coins: Int
    @Binding var isPresented: Bool
    @State private var tempBetAmount = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select Horse")) {
                    ForEach(horseNames.indices, id: \.self) { index in
                        HStack {
                            Image("a")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            Text(horseNames[index])
                            
                            Spacer()
                            
                            if selectedHorse == index {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedHorse = index
                        }
                    }
                }
                
                Section(header: Text("Bet Amount")) {
                    TextField("Enter amount", text: $tempBetAmount)
                        .keyboardType(.numberPad)
                    
                    Text("Available Coins: \(coins)")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Place Your Bet")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Confirm") {
                    if let amount = Int(tempBetAmount),
                       amount <= coins,
                       selectedHorse != nil {
                        betAmount = amount
                        coins -= amount
                        isPresented = false
                    }
                }
                .disabled(selectedHorse == nil || Int(tempBetAmount) ?? 0 > coins)
            )
        }
    }
}

// Renk Yardımcısı
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct HorseRacingView_Previews: PreviewProvider {
    static var previews: some View {
        HorseRacingView()
    }
}
