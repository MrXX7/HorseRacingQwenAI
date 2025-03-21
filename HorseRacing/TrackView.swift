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
    private var finishLinePosition: CGFloat {
        return trackWidth / 2 - horseSize - 20
    }
    
    var body: some View {
        ZStack {
            trackBackground
            finishLine
            horses
        }
    }
    
    // MARK: - Track Background
    private var trackBackground: some View {
        ZStack {
            // Base track with gradient
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "8B4513").opacity(0.5),
                        Color(hex: "8B4513").opacity(0.3)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .frame(width: trackWidth, height: 400)
            
            // Track lanes with alternating colors
            VStack(spacing: 0) {
                ForEach(0..<8, id: \.self) { index in
                    Rectangle()
                        .fill(index % 2 == 0 ?
                              Color(hex: "8B4513").opacity(0.4) :
                              Color(hex: "8B4513").opacity(0.3))
                        .frame(height: 45)
                }
            }
            .frame(width: trackWidth)
            
            // Lane dividers
            VStack(spacing: horseSpacing + 25) {
                ForEach(0..<9, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.white.opacity(0.4))
                        .frame(height: 2)
                        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                }
            }
            
            // Start line
            Rectangle()
                .fill(Color.white.opacity(0.6))
                .frame(width: 5, height: 400)
                .offset(x: -trackWidth/2 + 50)
            
            // Finish line - checkered pattern
            HStack(spacing: 0) {
                ForEach(0..<8, id: \.self) { row in
                    VStack(spacing: 0) {
                        ForEach(0..<16, id: \.self) { col in
                            Rectangle()
                                .fill((row + col) % 2 == 0 ? Color.black : Color.white)
                                .frame(width: 10, height: 10)
                        }
                    }
                }
            }
            .frame(width: 80, height: 400)
            .offset(x: trackWidth/2 - 60)
            
            // Distance markers
            ForEach(1..<5) { i in
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 2, height: 400)
                    .offset(x: -trackWidth/2 + (trackWidth * CGFloat(i) / 5))
            }
            
            // Crowd silhouettes at the top and bottom
            HStack(spacing: 5) {
                ForEach(0..<Int(trackWidth/20), id: \.self) { _ in
                    Circle()
                        .fill(Color.black.opacity(0.2))
                        .frame(width: 15, height: 10)
                        .offset(y: -3)
                }
            }
            .frame(width: trackWidth)
            .offset(y: -195)
            
            HStack(spacing: 5) {
                ForEach(0..<Int(trackWidth/20), id: \.self) { _ in
                    Circle()
                        .fill(Color.black.opacity(0.2))
                        .frame(width: 15, height: 10)
                        .offset(y: 3)
                }
            }
            .frame(width: trackWidth)
            .offset(y: 195)
        }
    }
    
    // MARK: - Finish Line
    private var finishLine: some View {
        HStack(spacing: 5) {
            ForEach(0..<4, id: \.self) { index in
                Rectangle()
                    .fill(index % 2 == 0 ? Color.black : Color.white)
                    .frame(width: 10, height: 400)
            }
        }
        .offset(x: finishLinePosition) // Align finish line correctly
    }
    
    // MARK: - Horses
    private var horses: some View {
        ForEach(0..<8, id: \.self) { index in
            ZStack {
                horseImage(index: index)
                horseName(index: index)
            }
            .offset(x: positions[index] - trackWidth / 2, // Adjust horse position
                    y: CGFloat(index * 45) - 156) // Vertical spacing between horses
            .id("horse\(index)") // Unique ID for ScrollView tracking
        }
    }
    
    // MARK: - Horse Image
    private func horseImage(index: Int) -> some View {
        Image("a") // Replace "a" with your horse image asset
            .resizable()
            .scaledToFit()
            .frame(width: horseSize, height: horseSize)
            .rotation3DEffect(.degrees(isRacing ? 10 : 0), axis: (x: 0, y: 1, z: 0))
            .shadow(color: .black.opacity(0.3), radius: 3)
    }
    
    // MARK: - Horse Name
    private func horseName(index: Int) -> some View {
        Text(horseNames[index])
            .font(.system(size: 12, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, 5)
            .background(Color.black.opacity(0.5))
            .cornerRadius(5)
            .offset(y: -35) // Position name above the horse
    }
}


