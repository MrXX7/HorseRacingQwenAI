//
//  TrackView.swift
//  HorseRacing
//
//  Created by Oncu Can on 5.02.2025.
//

import SwiftUI

struct TrackView: View {
    @Binding var horsePosition: CGFloat
    @Binding var isRacing: Bool
    var horseColor: Color
    var horseIcon: String

    var body: some View {
        ZStack(alignment: .leading) {
            // Yarış pisti
            Rectangle()
                .frame(width: 300, height: 4)
                .foregroundColor(.black)
                .shadow(color: .gray, radius: 2, x: 0, y: 2)
            
            // At ikonu
            Text(horseIcon)
                .font(.system(size: 30))
                .position(x: horsePosition, y: 15)
                .padding()
                .foregroundColor(horseColor)
                .shadow(color: .black, radius: 2, x: 0, y: 2)
        }
    }
}
