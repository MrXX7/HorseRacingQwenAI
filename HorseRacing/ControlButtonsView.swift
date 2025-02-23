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
            CustomButton(
                action: { showBettingView = true },
                label: {
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                        Text("Place Bet")
                    }
                },
                backgroundColor: .green,
                isDisabled: isRacing
            )
            
            CustomButton(
                action: { startRace() },
                label: {
                    HStack {
                        Image(systemName: isRacing ? "flag.fill" : "flag")
                        Text(isRacing ? "Racing..." : "Start Race")
                    }
                },
                backgroundColor: isRacing ? .gray : .blue,
                isDisabled: isRacing
            )
        }
        .padding(.horizontal)
    }
}

struct CustomButton<Label: View>: View {
    var action: () -> Void
    var label: () -> Label
    var backgroundColor: Color
    var isDisabled: Bool
    
    var body: some View {
        Button(action: action) {
            label()
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(15)
        }
        .disabled(isDisabled)
    }
}
