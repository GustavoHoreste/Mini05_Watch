//
//  PUViewModel.swift
//  Mini05 Watch App
//
//  Created by Felipe Porto on 21/05/24.
//

import Foundation
import Combine
import HealthKit

class PUViewModel: ObservableObject {
    @Published var pushUps: Int
    @Published var caloriesBurned: Double = 0.0
    @Published var heartRate: Double = 0.0
    @Published var elapsedTime: TimeInterval = 0
    
    @Published var initialDate: Date? = nil
    @Published var finalDate: Date? = nil
    
    private var model: PUModel
    private let healthStore = HKHealthStore()
    private var heartRateQuery: HKAnchoredObjectQuery?
    private var heartRateAnchor: HKQueryAnchor?
    private var timer: Timer?
    private var caloriesTimer: Timer?
    
    init(model: PUModel) {
        self.model = model
        self.pushUps = model.pushUps
    }
    

    
    func startActivity() {
        if initialDate == nil {
            initialDate = Date()
        } else {
            initialDate = Date(timeIntervalSinceNow: -elapsedTime)
        }
        
        finalDate = nil
        print("Iniciando atividade")
        
        startFetchingCaloriesBurned()
        startHeartRateQuery()
        startTimer()
    }
    
    func endActivity() {
        finalDate = Date()
        print("Terminando atividade")
        
        stopHeartRateQuery()
        stopTimer()
        stopFetchingCaloriesBurned()
    }
    
    private func startFetchingCaloriesBurned() {
        caloriesTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            self?.fetchCaloriesBurned()
        }
    }
    
    private func stopFetchingCaloriesBurned() {
        caloriesTimer?.invalidate()
        caloriesTimer = nil
    }
    
    private func fetchCaloriesBurned() {
        guard let startDate = initialDate else {
            print("Datas inválidas")
            return
        }
        
        let energyBurnedType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: energyBurnedType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] query, statistics, error in
            guard let self = self, let statistics = statistics, let sum = statistics.sumQuantity() else {
                if let error = error {
                    print("Erro ao buscar dados de calorias: \(error.localizedDescription)")
                } else {
                    print("Nenhum dado de calorias disponível para o período especificado.")
                }
                return
            }
            
            let calories = sum.doubleValue(for: HKUnit.kilocalorie())
            DispatchQueue.main.async {
                self.caloriesBurned = calories
            }
        }
        
        healthStore.execute(query)
    }
    
    private func startHeartRateQuery() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: initialDate, end: nil, options: .strictStartDate)
        
        heartRateQuery = HKAnchoredObjectQuery(type: heartRateType, predicate: predicate, anchor: heartRateAnchor, limit: HKObjectQueryNoLimit) { [weak self] (query, samples, deletedObjects, newAnchor, error) in
            self?.updateHeartRate(samples: samples)
            self?.heartRateAnchor = newAnchor
        }
        
        heartRateQuery?.updateHandler = { [weak self] (query, samples, deletedObjects, newAnchor, error) in
            self?.updateHeartRate(samples: samples)
            self?.heartRateAnchor = newAnchor
        }
        
        if let query = heartRateQuery {
            healthStore.execute(query)
        }
    }
    
    private func stopHeartRateQuery() {
        if let query = heartRateQuery {
            healthStore.stop(query)
        }
        heartRateQuery = nil
    }
    
    private func updateHeartRate(samples: [HKSample]?) {
        guard let samples = samples as? [HKQuantitySample] else {
            return
        }
        
        let heartRates = samples.map { $0.quantity.doubleValue(for: HKUnit(from: "count/min")) }
        guard !heartRates.isEmpty else {
            return
        }
        
        let averageHeartRate = heartRates.reduce(0, +) / Double(heartRates.count)
        
        DispatchQueue.main.async {
            self.heartRate = averageHeartRate
        }
    }
    
    private func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { [weak self] _ in
                self?.elapsedTime += 0.001
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func elapsedTimeString(from timeInterval: TimeInterval) -> String {
        let milliseconds = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 1000)
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds)
    }
}
