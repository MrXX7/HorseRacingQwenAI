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

    var body: some View {
        VStack(spacing: 20) {
            Text("Horse Racing")
                .font(.largeTitle)
            
            VStack(spacing: 1) {
                TrackView(horsePosition: $positions[0], isRacing: $isRacing)
                TrackView(horsePosition: $positions[1], isRacing: $isRacing)
                TrackView(horsePosition: $positions[2], isRacing: $isRacing)
                TrackView(horsePosition: $positions[3], isRacing: $isRacing)
                TrackView(horsePosition: $positions[4], isRacing: $isRacing)
            }
            .padding(.horizontal)
            
            Button(action: {
                self.startRace()
            }) {
                Text(isRacing ? "Racing..." : "Start Race")
                    .font(.title2)
                    .padding()
                    .background(isRacing ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isRacing)
        }
    }
    
    func startRace() {
        isRacing = true
        for index in positions.indices {
            let randomDuration = Double.random(in: 2...5)
            withAnimation(Animation.linear(duration: randomDuration)) {
                positions[index] = 300
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

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(width: 300, height: 2)
                .foregroundColor(.black)
            
            Text("🏇🏼")
                .position(x: horsePosition, y: -10)
                .padding()
        }
    }
}

struct HorseRacingView_Previews: PreviewProvider {
    static var previews: some View {
        HorseRacingView()
    }
}
