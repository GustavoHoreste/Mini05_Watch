//
//  TabViewWorkout.swift
//  Mini05 Watch App
//
//  Created by Gustavo Horestee Santos Barros on 22/05/24.
//

import SwiftUI
import WatchKit

struct TabViewWorkout: View {
    @EnvironmentObject private var exerciseViewModel: ExerciseProgressViewModel
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @State private var selection: Tabs = .exercise

    var body: some View {
        TabView(selection: $selection){
            StatusWorkoutView()
                .tag(Tabs.status)
            
            ExerciseProgressView()
                .tag(Tabs.exercise)
            
            NowPlayingView()
                .tag(Tabs.nowPlaying)
            
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: isLuminanceReduced ? .never : .automatic))
        .tabViewStyle(.page)
        .onChange(of: exerciseViewModel.isBackToView){ oldValue, newValue in
            displayMetricsView()
        }
        .navigationBarBackButtonHidden()
        
    }
    
    private func displayMetricsView() {
        withAnimation {
            selection = .exercise
        }
    }
}

#Preview {
    TabViewWorkout()
        .environmentObject(HealthKitManager())
}

