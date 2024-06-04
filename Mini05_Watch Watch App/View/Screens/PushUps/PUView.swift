//
//  PUView.swift
//  Mini05 Watch App
//
//  Created by Felipe Porto on 21/05/24.
//

import SwiftUI

struct PUView: View {
    @StateObject var viewModel: PUViewModel
    
    var body: some View {
        Text("\(viewModel.model.pushUps.rounded(.down).formatted())")
        
        .onAppear {
            viewModel.startRegister()
        }
    }
    
}



#Preview {
    let viewModel = PUViewModel()
    return PUView(viewModel: viewModel)
}
