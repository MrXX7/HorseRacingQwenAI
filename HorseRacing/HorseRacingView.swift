//
//  ContentView.swift
//  HorseRacing
//
//  Created by Oncu Can on 3.02.2025.
//

import SwiftUI
import AVFAudio

struct HorseRacingView: View {
    @State private var scrollTarget: Int = 0
    @State private var positions: [CGFloat] = Array(repeating: 20, count: 8)
    @State private var isRacing = false
    @State private var isPaused = false
    @State private var winner: Int? = nil
    @State private var audioPlayer: AVAudioPlayer?
    @State private var raceFinished = false
    @State private var horseNames = [
        "Thunder Bolt", "Silver Star", "Golden Flash",
        "Night Rider", "Wind Runner", "Storm Chaser",
        "Lightning Strike", "Desert King"
    ]
    @State private var horseSpeeds: [Double] = Array(repeating: 0, count: 8)
    @State private var timer: Timer? = nil
    @State private var finishedHorses: [Int] = []
    @State private var scrollPosition: CGFloat = 0
    @State private var scrollProxy: ScrollViewProxy? = nil
    
    let trackWidth: CGFloat = UIScreen.main.bounds.width * 2 // Track width
    let horseSpacing: CGFloat = 20
    let horseSize: CGFloat = 60
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(gradient: Gradient(colors: [
                Color(hex: "87CEEB"),
                Color(hex: "90EE90")
            ]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            
            // Clouds
            ForEach(0..<5) { i in
                Image(systemName: "cloud.fill")
                    .foregroundColor(.white.opacity(0.7))
                    .offset(x: CGFloat(i * 100) - 200, y: -200)
            }
            
            VStack(spacing: 20) {
                // Title
                HStack {
                    Image(systemName: "flag.fill")
                        .foregroundColor(.yellow)
                    Text("Horse Racing")
                        .font(.custom("AvenirNext-Bold", size: 40))
                        .foregroundColor(.white)
                    Image(systemName: "flag.fill")
                        .foregroundColor(.yellow)
                }
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                
                // Race Track with ScrollView
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        TrackView(positions: $positions,
                                  isRacing: $isRacing,
                                  horseNames: horseNames,
                                  trackWidth: trackWidth,
                                  horseSpacing: horseSpacing,
                                  horseSize: horseSize)
                        .frame(width: trackWidth)
                        .onAppear {
                            self.scrollProxy = proxy
                        }
                    }
                    .padding(.horizontal)
                }
                
                HStack(spacing: 20) {
                    // Start/Continue Race Button
                    Button(action: {
                        if !isRacing {
                            startRace()
                        } else if isPaused {
                            continuRace()
                        }
                    }) {
                        Text(determineStartButtonText())
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                            .background(determineStartButtonColor())
                            .cornerRadius(10)
                    }
                    .disabled(raceFinished)
                    
                    // Pause Button
                    if isRacing && !raceFinished {
                        Button(action: {
                            pauseRace()
                        }) {
                            Text("Pause")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(10)
                        }
                    }
                    
                    // Reset Button
                    if raceFinished {
                        Button(action: {
                            resetRace()
                        }) {
                            Text("Reset")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.vertical)
            }
        }
    }
    
    private func determineStartButtonText() -> String {
        if !isRacing {
            return "Start Race"
        } else if isPaused {
            return "Continue"
        } else {
            return "Racing..."
        }
    }
    
    private func determineStartButtonColor() -> Color {
        if !isRacing {
            return .green
        } else if isPaused {
            return .green
        } else {
            return .gray
        }
    }
    
    func startRace() {
        guard !isRacing else { return }
        
        startRaceSetup()
        
        // Start the race timer
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            updateHorsePositions()
            updateScrollPosition()
        }
    }
    
    func pauseRace() {
        isPaused = true
        timer?.invalidate()
        timer = nil
    }
    
    func continuRace() {
        isPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            updateHorsePositions()
            updateScrollPosition()
        }
    }

    private func startRaceSetup() {
        isRacing = true
        isPaused = false
        winner = nil
        raceFinished = false
        positions = Array(repeating: 20, count: 8)
        horseSpeeds = (0..<8).map { _ in Double.random(in: 0.5...1.2) }
        finishedHorses.removeAll()
        scrollToPosition(0) // Reset scroll position
    }

    private func updateHorsePositions() {
        guard isRacing, !isPaused else { return }
        
        let finishLine = trackWidth - horseSize - 40 // Finish line position accounting for horse size and padding
        
        for index in positions.indices {
            // Skip if horse already crossed the finish line
            guard positions[index] < finishLine else { continue }
            
            // Apply random speed adjustment within balanced range
            let speedAdjustment = Double.random(in: -0.08...0.12)
            horseSpeeds[index] += speedAdjustment
            
            // Clamp speed between reasonable min/max values
            horseSpeeds[index] = horseSpeeds[index].clamped(to: 0.6...1.5)
            
            // Update horse position
            positions[index] += CGFloat(horseSpeeds[index])
            
            // Check for finish line crossing
            if positions[index] >= finishLine {
                positions[index] = finishLine // Snap to exact finish position
                finishRace(winningHorse: index)
            }
        }
    }

    private func updateScrollPosition() {
        // Find the leading horse position that hasn't finished yet
        let unfinishedHorses = positions.enumerated().filter { $0.element < trackWidth - horseSize - 40 }
        guard let maxPosition = unfinishedHorses.max(by: { $0.element < $1.element }) else { return }
        
        // Calculate target scroll position (center the leading horse)
        let targetPosition = maxPosition.element - (screenWidth / 2.5)
        
        // Ensure we don't scroll past the finish line
        let maxScrollPosition = trackWidth - screenWidth
        let clampedPosition = min(targetPosition, maxScrollPosition)
        
        // Only scroll if the target position is ahead of current view
        if clampedPosition > scrollPosition {
            scrollPosition = clampedPosition
            withAnimation(.easeInOut(duration: 0.5)) {
                scrollProxy?.scrollTo(maxPosition.offset, anchor: .leading)
            }
        }
    }

    private func scrollToPosition(_ position: CGFloat) {
        scrollPosition = position
        withAnimation(.easeInOut(duration: 0.5)) {
            scrollProxy?.scrollTo(scrollTarget, anchor: .leading)
        }
    }

    private func finishRace(winningHorse: Int) {
        // Add the winning horse to the finished horses list if not already present
        guard !finishedHorses.contains(winningHorse) else { return }
        finishedHorses.append(winningHorse)
        
        // Check if all horses have finished the race
        if finishedHorses.count == horseNames.count {
            // Stop the timer and update race state
            timer?.invalidate()
            timer = nil
            raceFinished = true
            isRacing = false
            
            // Scroll to the finish line at the end
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                scrollToPosition(trackWidth - screenWidth)
            }
        }
    }

    private func resetRace() {
        withAnimation {
            positions = Array(repeating: 20, count: 8)
            isRacing = false
            isPaused = false
            raceFinished = false
            finishedHorses.removeAll()
            horseSpeeds = Array(repeating: 0, count: 8)
            timer?.invalidate()
            timer = nil
            scrollToPosition(0)
        }
    }
    
    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch {
                print("Failed to play sound")
            }
        }
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

struct HorseRacingView_Previews: PreviewProvider {
    static var previews: some View {
        HorseRacingView()
    }
}
