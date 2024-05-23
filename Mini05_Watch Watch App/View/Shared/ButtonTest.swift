//
//  ButtonTest.swift
//  Mini05 Watch App
//
//  Created by Gustavo Horestee Santos Barros on 20/05/24.
//

import SwiftUI

struct ButtonTest: View {
    var body: some View {
        Button{
            let _ = print("Ola mundo")
        }label: {
            Text("Meu nome")
        }
    }
}

#Preview {
    ButtonTest()
}

