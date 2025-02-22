//
//  WinnerView.swift
//  HorseRacing
//
//  Created by Oncu Can on 22.02.2025.
//

import SwiftUI

struct WinnerView: View {
    let horseNames: [String]
    let winner: Int
    let selectedHorse: Int?
    let betAmount: Int
    
    var body: some View {
        VStack {
            Text("🏆 \(horseNames[winner]) Wins! 🏆")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.yellow)
            
            if selectedHorse == winner {
                Text("You won \(betAmount * 2) coins! 🎉")
                    .font(.title3)
                    .foregroundColor(.green)
            }
        }
        .transition(.scale.combined(with: .opacity))
        .padding(.vertical)
    }
}

