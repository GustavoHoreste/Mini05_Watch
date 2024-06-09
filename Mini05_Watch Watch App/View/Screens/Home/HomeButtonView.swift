//
//  HomeView.swift
//  Mini05 Watch App
//
//  Created by Gustavo Horestee Santos Barros on 20/05/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) var context
    @EnvironmentObject private var exerciseViewModel: ExerciseProgressViewModel
    @EnvironmentObject private var healthManager: HealthKitManager
    
    private let buttons: [HomeButtonData] = [
        HomeButtonData(name: "Iniciar", destination: AnyView(SelectEvaluationView()), description: "Iniciar uma nova \navaliação", id: 0),
        HomeButtonData(name: "Avaliações", destination: AnyView(GraphChooseView()), description: "Visualizar avaliações\n passadas", id: 1),
        HomeButtonData(name: "Calibragem", destination: AnyView(CalibrationView()), description: "", id: 2)
    ]
    
    @AppStorage("saveData") var savedData = false
    
    var body: some View {
        NavigationStack{
                ScrollView(.horizontal, showsIndicators: false){
                    LazyHStack{
                        ForEach(buttons, id: \.name) { button in
                            VStack{
                                if button.id == 0 {
                                    Text("Ascender")
                                        .myCustonFont(fontName: .sairaMedium, size: 20, valueScaleFactor: 12)
                                        .foregroundStyle(Color("myOrange"))
                                        .padding(.top, -9)
                                        .padding(.trailing, 87)
                                        .padding(.bottom, -15)
                                        .scrollTransition(axis: .horizontal) { content, phase in
                                            content
                                                .opacity(phase.isIdentity ? 1 : 0.2)
                                        }
                                    Text(button.description)
                                        .myCustonFont(fontName: .sairaRegular, size: 14, valueScaleFactor: 0)
                                        .multilineTextAlignment(.leading)
                                        .padding(.trailing, 60)
                                        .padding(.bottom, -5)
                                        .scrollTransition(axis: .horizontal) { content, phase in
                                            content
                                                .opacity(phase.isIdentity ? 1 : 0.2)
                                        }
                                } else if button.id == 1 {
                                    Text(button.description)
                                        .myCustonFont(fontName: .sairaRegular, size: 14, valueScaleFactor: 0)
                                        .multilineTextAlignment(.trailing)
                                        .scrollTransition(axis: .horizontal) { content, phase in
                                            content
                                                .opacity(phase.isIdentity ? 1 : 0.2)
                                        }

                                }
                                HStack{
                                    HomeButton(name: button.name, destination: button.destination)
                                        .scrollTransition(axis: .horizontal) { content, phase in
                                            content
                                                .scaleEffect(x: phase.isIdentity ? 1 : 0.4,
                                                             y: phase.isIdentity ? 1 : 0.4)
                                                .offset(x: phase.isIdentity ? 1 : 2,
                                                        y: phase.isIdentity ? 1 : 30)
                                                .opacity(phase.isIdentity ? 1 : 0.2)
                                            
                                        }
                                        .padding()
                                        .padding(.leading, (button.id != 0) ? 1 : -1)
                                        .padding(.trailing, (button.id == 0) ? 1 : 20)
                                }
                            }
                        }
                        
                    }
                }
        }
        .background(.bg)
        .navigationBarBackButtonHidden()
            .onAppear {
                healthManager.resetWorkoutData()
                exerciseViewModel.reseatAll()
            }
    }
}


#Preview {
    HomeView()
        .environmentObject(ExerciseProgressViewModel())
        .environmentObject(HealthKitManager())
}

struct HomeButtonData: Identifiable {
    let name: String
    let destination: AnyView
    let description: String
    let id: Int
}
