//
//  TrackView.swift
//  HorseRacing
//
//  Created by Oncu Can on 5.02.2025.
//

import SwiftUI

struct TrackView: View {
    @Binding var horsePosition: CGFloat // Binding for the horse's position
    @Binding var isRacing: Bool // Binding to check if the race is ongoing
    var horseColor: Color // Color of the horse icon
    var horseIcon: String // Icon representing the horse
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Grass area on both sides of the track
            Rectangle()
                .frame(width: 340, height: 60)
                .foregroundColor(Color.green)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
            
            // Racetrack with texture (dirt-like appearance)
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 300, height: 40)
                .foregroundColor(Color.brown.opacity(0.8))
                .overlay(
                    // Adding texture to the track
                    Rectangle()
                        .fill(
                            AngularGradient(gradient: Gradient(colors: [.brown.opacity(0.9), .brown.opacity(0.7)]),
                                            center: .center)
                        )
                        .blur(radius: 2)
                )
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
            
            // Lane dividers (white dashed lines)
            HStack(spacing: 10) {
                ForEach(0..<10) { _ in
                    Rectangle()
                        .frame(width: 20, height: 2)
                        .foregroundColor(.white)
                        .opacity(0.8)
                }
            }
            .offset(y: -5) // Adjust position to align with the track
            
            // Horse icon
            Text(horseIcon)
                .font(.system(size: 30))
                .position(x: horsePosition, y: 20) // Adjusted position for better alignment
                .padding()
                .foregroundColor(horseColor)
                .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 2)
                .animation(.easeInOut(duration: 0.5), value: horsePosition) // Smooth animation for movement
        }
        .frame(width: 340, height: 60)
    }
}
