//
//  Device.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 27/05/24.
//

import SwiftUI
import WatchKit

struct DeviceScreen {
    static func getScreenSize() -> CGSize {
        return WKInterfaceDevice.current().screenBounds.size
    }
    
    static func getDimension(proportion: CGFloat, forWidth: Bool) -> CGFloat {
        let screenSize = getScreenSize()
        return forWidth ? screenSize.width * proportion : screenSize.height * proportion
    }
}
