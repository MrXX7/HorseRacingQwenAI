//
//  BettingView.swift
//  HorseRacing
//
//  Created by Oncu Can on 22.02.2025.
//

import SwiftUI

struct BettingView: View {
    let horseNames: [String]
    @Binding var selectedHorse: Int?
    @Binding var betAmount: Int
    @Binding var coins: Int
    @Binding var isPresented: Bool
    @State private var tempBetAmount = ""
    
    var body: some View {
        NavigationView {
            Form {
                horseSelectionSection
                betAmountSection
            }
            .navigationTitle("Place Your Bet")
            .navigationBarItems(
                leading: cancelButton,
                trailing: confirmButton
            )
        }
    }
    
    private var horseSelectionSection: some View {
        Section(header: Text("Select Horse")) {
            ForEach(horseNames.indices, id: \.self) { index in
                HStack {
                    Image("a")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    
                    Text(horseNames[index])
                    
                    Spacer()
                    
                    if selectedHorse == index {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedHorse = index
                }
            }
        }
    }
    
    private var betAmountSection: some View {
        Section(header: Text("Bet Amount")) {
            TextField("Enter amount", text: $tempBetAmount)
                .keyboardType(.numberPad)
            
            Text("Available Coins: \(coins)")
                .foregroundColor(.secondary)
        }
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            isPresented = false
        }
    }
    
    private var confirmButton: some View {
        Button("Confirm") {
            if let amount = Int(tempBetAmount),
               amount <= coins,
               selectedHorse != nil {
                betAmount = amount
                coins -= amount
                isPresented = false
            }
        }
        .disabled(selectedHorse == nil || Int(tempBetAmount) ?? 0 > coins)
    }
}
