//
//  ElapsedTimeFormatter.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 27/05/24.
//

import SwiftUI
import WatchKit

class ElapsedTimeFormatter: Formatter {
    let componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    var showSubseconds = true

    override func string(for value: Any?) -> String? {
        guard let time = value as? TimeInterval else {
            return nil
        }

        if time < 0 {
            return "00:00"
        }

        let absTime = abs(time)

        guard let formattedString = componentsFormatter.string(from: absTime) else {
            return nil
        }

        if showSubseconds {
            return String(format: "%@", formattedString)
        }

        return formattedString
    }
}
