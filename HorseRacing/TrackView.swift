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
    
    // MARK: - Constants
    private let laneHeight: CGFloat = 45
    private let lanes: Int = 8
    private let startLineOffset: CGFloat = 50
    private let finishLineOffset: CGFloat = 60
    private let checkeredSquareSize: CGFloat = 10
    private let horseNameFontSize: CGFloat = 12
    private let crowdSpacing: CGFloat = 5
    private let crowdSize: CGFloat = 15
    
    // MARK: - Computed Properties
    private var finishLinePosition: CGFloat {
        trackWidth / 2 - horseSize - 20
    }
    
    private var totalTrackHeight: CGFloat {
        laneHeight * CGFloat(lanes)
    }
    
    private var trackGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "03872a").opacity(0.5),
                Color(hex: "03872a").opacity(0.3)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                trackBackground
                finishLine
                horses
            }
            .frame(width: trackWidth, height: totalTrackHeight)
            .animation(.spring(response: 0.6, dampingFraction: 0.7), value: isRacing)
        }
    }
    
    // MARK: - Track Background
    private var trackBackground: some View {
        ZStack {
            // Base track with gradient
            RoundedRectangle(cornerRadius: 15)
                .fill(trackGradient)
            
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
    
    // MARK: - Track Components
    private var lanesBackground: some View {
        VStack(spacing: 0) {
            ForEach(0..<lanes, id: \.self) { index in
                Rectangle()
                    .fill(index % 2 == 0 ?
                          Color(hex: "03872a").opacity(0.4) :
                          Color(hex: "03872a").opacity(0.3))
                    .frame(height: laneHeight)
            }
        }
    }
    
    private var laneDividers: some View {
        VStack(spacing: laneHeight - 1) {
            ForEach(0..<lanes, id: \.self) { _ in
                Divider()
                    .background(Color.white.opacity(0.4))
                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
            }
        }
    }
    
    private var startLine: some View {
        Rectangle()
            .fill(Color.white.opacity(0.6))
            .frame(width: 5, height: totalTrackHeight)
            .offset(x: -trackWidth/2 + startLineOffset)
            .overlay(
                Text("START")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .rotationEffect(.degrees(90))
                    .offset(y: -totalTrackHeight/2 - 15)
            )
    }
    
    private var finishLineCheckeredPattern: some View {
        let rows = Int(totalTrackHeight / checkeredSquareSize)
        let columns = 4
        
        return VStack(spacing: 0) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<columns, id: \.self) { column in
                        Rectangle()
                            .fill(isSquareBlack(row: row, column: column) ? .black : .white)
                            .frame(width: checkeredSquareSize, height: checkeredSquareSize)
                    }
                }
            }
        }
        .frame(
            width: CGFloat(columns) * checkeredSquareSize,
            height: CGFloat(rows) * checkeredSquareSize
        )
        .offset(x: trackWidth / 2 - finishLineOffset)
        .overlay(
            Text("FINISH")
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .rotationEffect(.degrees(90))
                .offset(x: checkeredSquareSize * 2, y: -totalTrackHeight/2 - 15)
        )
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
                .overlay(
                    Text("\(i * 20)%")
                        .font(.system(size: 8, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                        .offset(y: totalTrackHeight/2 + 10)
                )
        }
    }
    
    private var crowdSilhouettes: some View {
        Group {
            crowdRow(offsetY: -totalTrackHeight/2 - 10, isTop: true)
            crowdRow(offsetY: totalTrackHeight/2 + 10, isTop: false)
        }
    }
    
    private func crowdRow(offsetY: CGFloat, isTop: Bool) -> some View {
        HStack(spacing: crowdSpacing) {
            ForEach(0..<Int(trackWidth/20), id: \.self) { index in
                Group {
                    if index % 5 == 0 {
                        // Occasionally add a jumping figure
                        jumpingFigure(isTop: isTop)
                    } else {
                        // Regular crowd figure
                        Circle()
                            .fill(Color.black.opacity(0.2))
                            .frame(width: crowdSize, height: crowdSize * 0.7)
                            .offset(y: isTop ? -3 : 3)
                    }
                }
                .animation(
                    isRacing ?
                        Animation.easeInOut(duration: 0.5)
                            .repeatForever()
                            .delay(Double(index) * 0.05) :
                        .default,
                    value: isRacing
                )
            }
        }
        .frame(width: trackWidth)
        .offset(y: offsetY)
    }
    
    private func jumpingFigure(isTop: Bool) -> some View {
        VStack(spacing: 0) {
            Circle()
                .fill(Color.black.opacity(0.3))
                .frame(width: crowdSize, height: crowdSize)
            
            Rectangle()
                .fill(Color.black.opacity(0.3))
                .frame(width: crowdSize/3, height: crowdSize)
        }
        .frame(height: crowdSize * 2)
        .scaleEffect(isRacing ? 1.2 : 1.0)
        .offset(y: isRacing ? (isTop ? -5 : 5) : 0)
    }
    
    // MARK: - Finish Line
    private var finishLine: some View {
        HStack(spacing: 0) {
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
        ForEach(0..<min(positions.count, lanes), id: \.self) { index in
            horseView(index: index)
                .transition(.scale.combined(with: .opacity))
                .id("horse-\(index)")
        }
    }
    
    private func horseView(index: Int) -> some View {
        ZStack {
            horseImage(index: index)
            horseName(index: index)
            laneNumber(index: index)
        }
        .offset(
            x: positions[index] - trackWidth / 2,
            y: CGFloat(index) * laneHeight - (totalTrackHeight / 2) + (laneHeight / 2)
        )
    }
    
    // MARK: - Horse Components
    private func horseImage(index: Int) -> some View {
        Image("a") // İstendiği gibi "a" görüntüsü korundu
            .resizable()
            .scaledToFit()
            .frame(width: horseSize, height: horseSize)
            .shadow(color: .black.opacity(0.3), radius: 3)
            .rotationEffect(isRacing ? .degrees(sin(Double(positions[index]) / 30) * 5) : .zero)
            .offset(y: isRacing ? sin(Double(positions[index]) / 15) * 3 : 0)
    }
    
    private func horseName(index: Int) -> some View {
        Text(horseNames[index])
            .font(.system(size: horseNameFontSize, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.black.opacity(0.6))
                    .shadow(color: .black.opacity(0.2), radius: 1)
            )
            .offset(y: -horseSize/2 - 10)
    }
    
    private func laneNumber(index: Int) -> some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 16, height: 16)
                .shadow(color: .black.opacity(0.3), radius: 1)
            
            Text("\(index + 1)")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.black)
        }
        .offset(x: -horseSize/2 - 10, y: -5)
    }
}

// MARK: - Preview Provider
struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView(
            positions: .constant([50, 100, 150, 200, 250, 300, 350, 400]),
            isRacing: .constant(true),
            horseNames: ["Swift", "Shadow", "Thunder", "Lightning", "Storm", "Blaze", "Arrow", "Rocket"],
            trackWidth: 700,
            horseSpacing: 10,
            horseSize: 40
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color.gray.opacity(0.2))
    }
}


