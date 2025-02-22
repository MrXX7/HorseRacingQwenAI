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
    
    // Finish line position (calculated based on track width)
    var finishLinePosition: CGFloat {
        return trackWidth / 2 - horseSize - 20
    }
    
    var body: some View {
        ZStack {
            // Track Background
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
            
            // Finish Line
            HStack(spacing: 5) {
                ForEach(0..<4) { i in
                    Rectangle()
                        .fill(i % 2 == 0 ? Color.black : Color.white)
                        .frame(width: 10, height: 400)
                }
            }
            .offset(x: finishLinePosition) // Align finish line correctly
            
            // Horses
            ForEach(0..<8, id: \.self) { index in
                ZStack {
                    // Horse Image
                    Image("a") // Replace "a" with your horse image asset
                        .resizable()
                        .scaledToFit()
                        .frame(width: horseSize, height: horseSize)
                        .rotation3DEffect(.degrees(isRacing ? 10 : 0), axis: (x: 0, y: 1, z: 0))
                        .shadow(color: .black.opacity(0.3), radius: 3)
                    
                    // Horse Name
                    Text(horseNames[index])
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 5)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(5)
                        .offset(y: -35) // Position name above the horse
                }
                .offset(x: positions[index] - trackWidth / 2, // Adjust horse position
                        y: CGFloat(index * 45) - 156) // Vertical spacing between horses
                .id("horse\(index)") // Unique ID for ScrollView tracking
            }
        }
    }
}
