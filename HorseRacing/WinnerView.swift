//
//  WinnerView.swift
//  HorseRacing
//
//  Created by Oncu Can on 22.02.2025.
//

import SwiftUI

struct WinnerView: View {
    let horseNames: [String]
    let finishedHorses: [Int] // Bitiren atların sırası
    
    var body: some View {
        VStack(spacing: 10) {
            Text("🏆 Race Finished! 🏆")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(Color.green)
                .cornerRadius(10)
            
            ForEach(Array(finishedHorses.enumerated()), id: \.element) { index, horse in
                Text("\(index + 1). \(horseNames[horse])")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(index == 0 ? Color.blue : Color.gray) // Kazananı vurgula
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

