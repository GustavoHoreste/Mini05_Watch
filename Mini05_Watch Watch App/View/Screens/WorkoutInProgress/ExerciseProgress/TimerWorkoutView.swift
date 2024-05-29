//
//  TimerWorkoutView.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 29/05/24.
//

import SwiftUI


struct TimerWorkoutView: View {
    @EnvironmentObject var healthManager: HealthKitManager

    var body: some View {
        TimelineView(MetricsTimelineSchedule(from: healthManager.builder?.startDate ?? Date(), isPaused: healthManager.session?.state == .paused)) { value in
                VStack(alignment: .leading){
                    Text("Cronômetro")
                        .font(.callout)
                    
                    ElapsedTimeView(elapsedTime: healthManager.remainingTime(at: value.date), showSubseconds: false)
                        .font(.system(size: 30))
                    
                    HStack{
                        Text("Tempo de avaliação")
                            .font(.system(size: 10))
                       
                        ElapsedTimeView(elapsedTime: healthManager.builder?.elapsedTime(at: value.date) ?? 0, showSubseconds: value.cadence == .live)

                    }.frame(width: 180, height: 30)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 2)
                    }
                }
        }
    }
}
