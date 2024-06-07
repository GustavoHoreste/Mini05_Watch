//
//  TimerAnimation.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 06/06/24.
//

import SwiftUI
import UIKit

struct TimerAnimation<T: View>: View {
    @State var progress: Double = 0.0
    @State var duration: TimeInterval = 4
    @State var timer: Timer?
    @State private var values: [String] = ["3", "2", "1", "GO!"]
    @State private var currentIndex = 0
    @State private var nextView: Bool = false
    var destination: T
    
    var body: some View {
        NavigationStack{
//            VStack {
                ZStack {
                    Color("bg") // Cor de fundo
                         .ignoresSafeArea()
                    
                    Circle()
                        .trim(from: 0.0, to: progress)
                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.degrees(270.0))
                        .foregroundStyle(Color("myOrange"))
                        .frame(width: DeviceScreen.getDimension(proportion: 0.9, forWidth: true),
                               height: DeviceScreen.getDimension(proportion: 0.9, forWidth: true))
                        .animation(.easeInOut(duration: 1.0), value: progress)
                    
                    Text(values[currentIndex])
                        .myCustonFont(fontName: .sairaRegular, size: 48, valueScaleFactor: 0.9)
                        .foregroundStyle(Color("myWhite"))
                        .transition(.opacity)
                }
                .onAppear {
                    startTimer()
                }
                .sensoryFeedback(currentIndex == values.count - 1 ? .success : .impact(flexibility: .rigid, intensity: 1), trigger: currentIndex)
                .navigationDestination(isPresented: $nextView) {
                    withAnimation(.easeIn) {
                        self.destination
                    }
                }
                .navigationBarBackButtonHidden()
//            }
        }.background(.bg)
    }
}

extension TimerAnimation {
    private func startTimer() {
        let interval = duration / Double(values.count)
        progress = 0.0
        currentIndex = 0
        duration = 4
        nextView = false
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            if currentIndex < values.count - 1 {
                print(currentIndex)
                currentIndex += 1
                progress += 1.0 / Double(values.count - 1)
            } else {
                timer.invalidate()
                self.timer = nil
                print("next")
                self.nextView = true
            }
        }
    }
}

#Preview {
    TimerAnimation(progress: 3, duration: 5, destination: HomeView())
}
