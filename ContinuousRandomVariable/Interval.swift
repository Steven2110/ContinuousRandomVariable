//
//  Interval.swift
//  ContinuousRandomVariable
//
//  Created by Steven Wijaya on 12.05.2023.
//

import Foundation

struct Interval: Identifiable {
    let id: UUID = UUID()
    var name: String {
        let minInterval: Double = round(min * 100.0) / 100.0
        let maxInterval: Double = round(max * 100.0) / 100.0
        return "(\(minInterval); \(maxInterval)]"
    }
    let min: Double
    let max: Double
    var countSample: Int = 0
    var frequency: Double = 0.0
    
    mutating func calcualateFrequency(n: Int) {
        frequency = Double(countSample) / Double(n)
    }
}
