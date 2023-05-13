//
//  DistributionViewModel.swift
//  ContinuousRandomVariable
//
//  Created by Steven Wijaya on 13.05.2023.
//

import Foundation

final class DistributionViewModel: ObservableObject {
    private (set) var n: Int = 0
    private (set) var mean: Double = 0.0
    private (set) var variance: Double = 0.0
    
    @Published var distribution: [Interval] = [Interval]()
    
    @Published var empiricMean: Double = 0.0
    @Published var empiricMeanError: Double = 0.0
    @Published var empiricVar: Double = 0.0
    @Published var empiricVarError: Double = 0.0
    
    @Published var chiSquare: Double = 0.0
    var chiSquareResult: String {
        chiSquare > 11.07 ? "True" : "False"
    }
    
    func reset() {
        n = 0
        mean = 0.0
        variance = 0.0
        distribution = [Interval]()
        empiricMean = 0.0
        empiricMeanError = 0.0
        empiricVar = 0.0
        empiricVarError = 0.0
        chiSquare = 0.0
    }
    
    func set(n: Int, mean: Double, variance: Double) {
        self.n = n
        self.mean = mean
        self.variance = variance
    }
    
    private func sumBaseGenerator() -> Double {
        var sum = 0.0
        for _ in 1...12 {
            sum += Double.random(in: 0.0...1.0)
        }
        
        return sum - 6
    }
    
    private func nrv() -> Double {
        mean + sqrt(variance) * sumBaseGenerator()
    }
    
    private func generateSample(_ n: Int, mean: Double, variance: Double) -> [Double] {
        var sample: [Double] = [Double]()
        
        for _ in 0..<n {
            sample.append(nrv())
        }
        
        return sample
    }
    
    private func specialMethod() -> Int {
        // Sturges method
        Int(round(log2(Double(n)))) + 1
    }
    
    func start() {
        let sample: [Double] = generateSample(n, mean: mean, variance: variance)
        print(sample)
        
        let min: Double = sample.min()!
        let max: Double = sample.max()!
        print("Min: \(min), Max: \(max)")
        let range: Double = max - min
        
        let k: Int = specialMethod()
        
        let intervalMin: Double = min < 0.0 ? floor(min) : ceil(min) // -5.3 ceil = -5.0 floor = -6.0
        let intervalMax: Double = ceil(max)
        print("Interval Min: \(intervalMin), Max: \(intervalMax)")
        let intervalRange: Double = range / Double(k)
        
        var currentIntervalMin: Double = intervalMin
        var currentIntervalMax: Double = intervalMin + intervalRange
        
        for i in 1...k {
            var interval: Interval = Interval(min: currentIntervalMin, max: currentIntervalMax)
            
            let sampleInInterval: [Double] = sample.filter { sample in
                sample > currentIntervalMin && sample <= currentIntervalMax
            }
            print("\(i)-th interval \(sampleInInterval)")
            interval.countSample = sampleInInterval.count
            interval.calcualateFrequency(n: n)
            
            distribution.append(interval)
            
            currentIntervalMin += intervalRange
            currentIntervalMax += intervalRange
        }
        
        calculateEmpiricMeanNError()
        calculateEmpiricVarianceNError()
        chiSquareTest()
    }
    
    private func calculateEmpiricMeanNError() {
        for (i, interval) in distribution.enumerated() {
            empiricMean += Double(i + 1) * interval.frequency
        }
        
        empiricMeanError = abs(empiricMean - mean) / abs(mean)
        
        print("Empiric mean: \(empiricMean)")
        print("Empiric mean error: \(empiricMeanError)")
    }
    
    private func calculateEmpiricVarianceNError() {
        for (i, interval) in distribution.enumerated() {
            empiricVar += Double(i + 1) * Double(i + 1) * interval.frequency
        }
        empiricVar -= empiricMean * empiricMean
        
        empiricVarError = Double(abs(empiricVar - variance)) / Double(abs(variance))
        
        print("Empiric variance: \(empiricVar)")
        print("Empiric variance error: \(empiricVarError)")
    }
    
    private func chiSquareTest() {
        // Pearson's chi-square test
        // for n -> inf
        // chiSquare = SUM(xi^2/mi) - n
        // where mi = expected value (see formula for `denominator`)
        for interval in distribution {
            let pith: Double = (interval.max - interval.min) * interval.frequency
            let denominator: Double = Double(n) * pith
            
            let numerator: Double = Double(interval.countSample * interval.countSample)
            
            if denominator != 0 {
                chiSquare += numerator / denominator
            }
        }
        chiSquare -= Double(n)
        
        print("Chi Square: \(chiSquare)")
        
        // If chi square is negative then we will recalculate chi square using normal chi square formula
        // SUM((xi - mi)^2 / mi)
        // where mi = expected value (see formula for `denominator`)
        if chiSquare < 0.0 {
            chiSquare = 0.0
            for interval in distribution {
                let pith: Double = (interval.max - interval.min) * interval.frequency
                let denominator: Double = Double(n) * pith
                
                let numerator: Double = (Double(interval.countSample) - denominator) * (Double(interval.countSample) - denominator)
                
                if denominator != 0 {
                    chiSquare += numerator / denominator
                    print("Chi Square curr: \(chiSquare)")
                }
            }
            
            print("Chi Square: \(chiSquare)")
        }
    }
}
