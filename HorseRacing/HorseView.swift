//
//  HorseView.swift
//  HorseRacing
//
//  Created by Oncu Can on 25.03.2025.
//

import SwiftUI

struct HorseView: View {
    let name: String
    let position: CGFloat
    
    var body: some View {
        VStack {
            Image(systemName: "hare.fill")
            Text(name)
        }
        .offset(x: position)
        .frame(width: 60)     
    }
}
