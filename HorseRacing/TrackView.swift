////
////  TrackView.swift
////  HorseRacing
////
////  Created by Oncu Can on 5.02.2025.
////
//

import SwiftUI

struct TrackView: View {
    @Binding var positions: [CGFloat]
    @Binding var isRacing: Bool
    let horseNames: [String]
    let trackWidth: CGFloat
    let horseSpacing: CGFloat
    let horseSize: CGFloat
    
    var body: some View {
        ZStack {
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
            
            HStack(spacing: 5) {
                ForEach(0..<4) { i in
                    Rectangle()
                        .fill(i % 2 == 0 ? Color.black : Color.white)
                        .frame(width: 10, height: 400)
                }
            }
            .offset(x: trackWidth/2 - horseSize - 20)
            
            ForEach(0..<8) { index in
                ZStack {
                    Image("a")
                        .resizable()
                        .scaledToFit()
                        .frame(width: horseSize, height: horseSize)
                        .rotation3DEffect(.degrees(isRacing ? 10 : 0), axis: (x: 0, y: 1, z: 0))
                        .shadow(color: .black.opacity(0.3), radius: 3)
                    
                    Text(horseNames[index])
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 5)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(5)
                        .offset(y: -35)
                }
                .offset(x: positions[index] - trackWidth/2,
                       y: CGFloat(index * 45) - 156)
                .id("horse\(index)")
            }
        }
    }
}
