//
//  ContentView.swift
//  HorseRacing
//
//  Created by Oncu Can on 3.02.2025.
//

import SwiftUI

struct HorseRacingView: View {
    @State private var positions: [CGFloat] = [0, 0, 0, 0, 0]
    @State private var isRacing = false
    @State private var winner: Int? = nil

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.green.opacity(0.2)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Horse Racing")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 2)
                
                VStack(spacing: 10) {
                    ForEach(0..<5) { index in
                        TrackView(horsePosition: $positions[index], isRacing: $isRacing, horseColor: colors[index])
                    }
                }
                .padding(.horizontal)
                
                if let winner = winner {
                    Text("🏆 Horse \(winner + 1) wins!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                        .shadow(color: .black, radius: 2, x: 0, y: 2)
                        .transition(.opacity)
                }
                
                Button(action: {
                    self.startRace()
                }) {
                    Text(isRacing ? "Racing..." : "Start Race")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isRacing ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: .black, radius: 2, x: 0, y: 2)
                }
                .disabled(isRacing)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
    
    let colors: [Color] = [.red, .green, .blue, .orange, .purple]
    
    func startRace() {
        isRacing = true
        winner = nil
        
        // Reset positions to start line
        positions = [0, 0, 0, 0, 0]
        
        // Determine the winner based on who reaches the finish line first
        let finishLine: CGFloat = 300
        var winnerIndex: Int? = nil
        
        for index in positions.indices {
            let randomDuration = Double.random(in: 2...5)
            withAnimation(Animation.linear(duration: randomDuration)) {
                positions[index] = finishLine
            }
            
            // Track which horse finishes first
            DispatchQueue.main.asyncAfter(deadline: .now() + randomDuration) {
                if winnerIndex == nil { // Only set the winner if no one has won yet
                    winnerIndex = index
                    winner = winnerIndex
                }
            }
        }
        
        // Reset after race ends
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            positions = [0, 0, 0, 0, 0]
            isRacing = false
        }
    }
}

struct TrackView: View {
    @Binding var horsePosition: CGFloat
    @Binding var isRacing: Bool
    var horseColor: Color

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(width: 300, height: 4)
                .foregroundColor(.black)
                .shadow(color: .gray, radius: 2, x: 0, y: 2)
            
            Text("🏇🏼")
                .font(.system(size: 30))
                .position(x: horsePosition, y: 15)
                .padding()
                .foregroundColor(horseColor)
        }
    }
}

struct HorseRacingView_Previews: PreviewProvider {
    static var previews: some View {
        HorseRacingView()
    }
}
