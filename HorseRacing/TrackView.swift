////
////  TrackView.swift
////  HorseRacing
////
////  Created by Oncu Can on 5.02.2025.
////
//
//import SwiftUI
//
//struct TrackView: View {
//    @Binding var horsePosition: CGFloat
//    @Binding var isRacing: Bool
//    var horseColor: Color
//    var horseIcon: String
//    
//    @State private var isGalloping = false
//    @State private var dustOffset: CGFloat = 0
//    
//    var body: some View {
//        ZStack(alignment: .leading) {
//            GrassBackground()
//            RaceTrack()
//            HorseWithEffects()
//        }
//        .frame(width: 340, height: 80)
//        .onAppear {
//            withAnimation(Animation.easeInOut(duration: 0.6).repeatForever()) {
//                isGalloping = true
//            }
//        }
//    }
//    
//    private func GrassBackground() -> some View {
//        ZStack {
//            Rectangle()
//                .fill(
//                    LinearGradient(
//                        gradient: Gradient(colors: [
//                            Color.green.opacity(0.7),
//                            Color.green.opacity(0.9)
//                        ]),
//                        startPoint: .top,
//                        endPoint: .bottom
//                    )
//                )
//            
//            ForEach(0..<20) { i in
//                Rectangle()
//                    .fill(Color.green.opacity(0.3))
//                    .frame(width: 2, height: 15)
//                    .rotationEffect(.degrees(Double.random(in: -20...20)))
//                    .offset(x: CGFloat.random(in: -170...170),
//                            y: CGFloat.random(in: -30...30))
//            }
//        }
//        .frame(width: 340, height: 80)
//        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
//    }
//    
//    private func RaceTrack() -> some View {
//        ZStack {
//            Rectangle()
//                .fill(
//                    LinearGradient(
//                        gradient: Gradient(colors: [
//                            Color.brown.opacity(0.6),
//                            Color.brown.opacity(0.8)
//                        ]),
//                        startPoint: .top,
//                        endPoint: .bottom
//                    )
//                )
//                .frame(width: 300, height: 20)
//                .offset(y: 15)
//            
//            HStack(spacing: 20) {
//                ForEach(0..<15) { _ in
//                    Rectangle()
//                        .fill(Color.white.opacity(0.4))
//                        .frame(width: 3, height: 6)
//                }
//            }
//            .offset(y: 15)
//        }
//    }
//    
//    private func HorseWithEffects() -> some View {
//        ZStack {
//            if isRacing {
//                ForEach(0..<5) { i in
//                    Circle()
//                        .fill(Color.gray.opacity(0.3))
//                        .frame(width: 10, height: 10)
//                        .offset(x: horsePosition + CGFloat(i * 5), // Dust effect direction fixed
//                                y: 25 + CGFloat(i * 2))
//                        .animation(Animation.easeOut(duration: 0.5).repeatForever(), value: dustOffset)
//                }
//            }
//            
//            // Fixed the direction of the horse movement
//            Text(horseIcon)
//                .font(.system(size: 35))
//                .offset(x: horsePosition, y: 15)
//                .foregroundColor(horseColor)
//                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
//                .scaleEffect(x: 1, y: isGalloping ? 1.1 : 0.9) // Removed scaleEffect(x: -1) to prevent flipping
//                .animation(Animation.easeInOut(duration: 0.3).repeatForever(), value: isGalloping)
//        }
//    }
//}
//    
