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
            
            // Racetrack (black line)
            Rectangle()
                .frame(width: 300, height: 4)
                .foregroundColor(.black)
                .shadow(color: .gray, radius: 2, x: 0, y: 2)
                .offset(y: 15) // Center the track vertically
            
            // Horse icon
            Text(horseIcon)
                .font(.system(size: 30))
                .position(x: horsePosition, y: 15)
                .padding()
                .foregroundColor(horseColor)
                .shadow(color: .black, radius: 2, x: 0, y: 2)
                .scaleEffect(x: -1, y: 1) // Yatay eksende ters çevir (sağa bakmasını sağla)
        }
        .frame(width: 340, height: 60)
    }
}
    
