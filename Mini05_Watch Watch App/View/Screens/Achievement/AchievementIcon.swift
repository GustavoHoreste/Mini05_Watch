//
//  AchievementIcon.swift
//  Mini05_Watch Watch App
//
//  Created by Samu Lima on 23/05/24.
//

import SwiftUI

struct AchievementIcon: View {
    var isLocked = true
    
    var body: some View {
        ZStack {
            Circle()
                .padding()
            
            Image(systemName: "trophy.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.gray)
                .padding(35)
            
            if isLocked {
                Image(systemName: "lock.fill")
                    .resizable()
                    .frame(width: 30, height: 40)
                    .foregroundStyle(.black)
                    .padding()
            }
        }
    }
}

#Preview {
    AchievementIcon()
}
