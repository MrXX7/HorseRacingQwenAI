//
//  ControlButtonsView.swift
//  HorseRacing
//
//  Created by Oncu Can on 22.02.2025.
//

import SwiftUI

struct ControlButtonsView: View {
    @Binding var isRacing: Bool
    @Binding var showBettingView: Bool
    var startRace: () -> Void
    
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: { showBettingView = true }) {
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                    Text("Place Bet")
                }
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(15)
            }
            .disabled(isRacing)
            
            Button(action: { startRace() }) {
                HStack {
                    Image(systemName: isRacing ? "flag.fill" : "flag")
                    Text(isRacing ? "Racing..." : "Start Race")
                }
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .padding()
                .frame(maxWidth: .infinity)
                .background(isRacing ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
            }
            .disabled(isRacing)
        }
        .padding(.horizontal)
    }
}
