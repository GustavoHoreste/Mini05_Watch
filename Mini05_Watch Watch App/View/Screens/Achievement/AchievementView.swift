//
//  AchievementView.swift
//  Mini05_Watch Watch App
//
//  Created by Samu Lima on 23/05/24.
//

import SwiftUI

struct AchievementView: View {
    let achievementList = ["correu bastante", "ta fortin", "fez varias flexoes", ""]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(achievementList, id: \.self ) { achieve in
                        AchievementIcon(isLocked: false)
                        
                    }
                }
            }
        }
        .navigationTitle("Conquistas")
        
    }
}

#Preview {
    AchievementView()
}
