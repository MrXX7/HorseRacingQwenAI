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
    
    // Computed properties for better performance and readability
    private var finishLinePosition: CGFloat {
        trackWidth / 2 - horseSize - 20
    }
    
    private var laneHeight: CGFloat {
        45
    }
    
    private var totalTrackHeight: CGFloat {
        laneHeight * 8
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                trackBackground
                finishLine
                horses
            }
            .frame(width: trackWidth, height: totalTrackHeight)
        }
    }
    
    // MARK: - Track Background
    private var trackBackground: some View {
        ZStack {
            // Base track with gradient
            RoundedRectangle(cornerRadius: 15)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "03872a").opacity(0.5),
                            Color(hex: "03872a").opacity(0.3)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            // Track lanes with alternating colors
            lanesBackground
            
            // Lane dividers
            laneDividers
            
            // Start line
            startLine
            
            // Finish line - checkered pattern
            finishLineCheckeredPattern
            
            // Distance markers
            distanceMarkers
            
            // Crowd silhouettes
            crowdSilhouettes
        }
    }
    
    // Extracted track background components for better readability
    private var lanesBackground: some View {
        VStack(spacing: 0) {
            ForEach(0..<8, id: \.self) { index in
                Rectangle()
                    .fill(index % 2 == 0 ?
                          Color(hex: "03872a").opacity(0.4) :
                          Color(hex: "03872a").opacity(0.3))
                    .frame(height: laneHeight)
            }
        }
    }
    
    private var laneDividers: some View {
        VStack(spacing: laneHeight) {
            ForEach(0..<8, id: \.self) { _ in
                Divider()
                    .background(Color.white.opacity(0.4))
                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
            }
        }
    }
    
    private var startLine: some View {
        let startLineWidth: CGFloat = 5
        let startLineOffset: CGFloat = 50
        
        return Rectangle()
            .fill(Color.white.opacity(0.6))
            .frame(width: startLineWidth, height: totalTrackHeight)
            .offset(x: -trackWidth/2 + startLineOffset)
    }
    
    private var finishLineCheckeredPattern: some View {
        let squareSize: CGFloat = 10
        let rows = 8
        let columns = 16
        
        return HStack(spacing: 0) {
            ForEach(0..<rows, id: \.self) { row in
                VStack(spacing: 0) {
                    ForEach(0..<columns, id: \.self) { column in
                        Rectangle()
                            .fill(isSquareBlack(row: row, column: column) ? .black : .white)
                            .frame(width: squareSize, height: squareSize)
                    }
                }
            }
        }
        .frame(
            width: CGFloat(rows) * squareSize,
            height: CGFloat(columns) * squareSize
        )
        .offset(x: trackWidth / 2 - 60)
    }

    private func isSquareBlack(row: Int, column: Int) -> Bool {
        return (row + column) % 2 == 0
    }
    
    private var distanceMarkers: some View {
        ForEach(1..<5) { i in
            Rectangle()
                .fill(Color.white.opacity(0.3))
                .frame(width: 2, height: totalTrackHeight)
                .offset(x: -trackWidth/2 + (trackWidth * CGFloat(i) / 5))
        }
    }
    
    private var crowdSilhouettes: some View {
        Group {
            crowdRow(offsetY: -195)
            crowdRow(offsetY: 195)
        }
    }
    
    private func crowdRow(offsetY: CGFloat) -> some View {
        HStack(spacing: 5) {
            ForEach(0..<Int(trackWidth/20), id: \.self) { _ in
                Circle()
                    .fill(Color.black.opacity(0.2))
                    .frame(width: 15, height: 10)
                    .offset(y: offsetY > 0 ? 3 : -3)
            }
        }
        .frame(width: trackWidth)
        .offset(y: offsetY)
    }
    
    // MARK: - Finish Line
    private var finishLine: some View {
        HStack(spacing: 5) {
            ForEach(0..<4, id: \.self) { index in
                Rectangle()
                    .fill(index % 2 == 0 ? Color.black : Color.white)
                    .frame(width: 10, height: totalTrackHeight)
            }
        }
        .offset(x: finishLinePosition)
    }
    
    // MARK: - Horses
    private var horses: some View {
        ForEach(0..<8, id: \.self) { index in
            horseView(index: index)
        }
    }
    
    private func horseView(index: Int) -> some View {
        ZStack {
            horseImage(index: index)
            horseName(index: index)
        }
        .offset(
            x: positions[index] - trackWidth / 2,
            y: CGFloat(index) * laneHeight - 156
        )
    }
    
    // MARK: - Horse Image
    private func horseImage(index: Int) -> some View {
        Image("a") // Replace "a" with your horse image asset
            .resizable()
            .scaledToFit()
            .frame(width: horseSize, height: horseSize)
            .rotation3DEffect(
                .degrees(isRacing ? 10 : 0),
                axis: (x: 0, y: 1, z: 0)
            )
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
            .offset(y: -35)
    }
}



