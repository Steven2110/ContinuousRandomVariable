//
//  CRVMainView.swift
//  ContinuousRandomVariable
//
//  Created by Steven Wijaya on 11.05.2023.
//

import SwiftUI
import Charts

struct CRVMainView: View {
    
    @State private var meanStr: String = "2.897"
    private var mean: Double {
        return Double(meanStr)!
    }
    
    @State private var varianceStr: String = "2.072"
    private var variance: Double {
        return Double(varianceStr)!
    }
    
    @State private var sampleSize: String = "100"
    private var n: Int {
        return Int(sampleSize)!
    }
    
    @ObservedObject var vm: DistributionViewModel = DistributionViewModel()
    
    var body: some View {
        HSplitView {
            VStack(alignment: .leading) {
                CRVTextField(text: "Mean", data: $meanStr)
                CRVTextField(text: "Variance", data: $varianceStr)
                CRVTextField(text: "Sample size", data: $sampleSize)
                HStack {
                    Button {
                        vm.set(n: n, mean: mean, variance: variance)
                        vm.start()
                    } label: {
                        Text("Go")
                            .frame(width: 50, height: 20)
                            .padding()
                    }
                    Button {
                        vm.reset()
                    } label: {
                        Text("Reset")
                            .frame(width: 50, height: 20)
                            .padding()
                    }
                }
            }
            .padding()
            .frame(minWidth: 300, maxWidth: 300, maxHeight: .infinity)
            VStack(spacing: 10) {
                Chart(vm.distribution) {
                    BarMark(x: .value("Interval", $0.name), y: .value("Frequency", $0.frequency))
                    LineMark(x: .value("Interval", $0.name), y: .value("Frequency", $0.frequency)).foregroundStyle(.green)
                }
                Text("Mean: \(vm.mean, specifier: "%.3f"), Empiric Mean: \(vm.empiricMean, specifier: "%.3f"), error: \(round(vm.empiricMeanError * 100.0) / 100.0, specifier: "%.2f")%")
                Text("Variance: \(vm.variance, specifier: "%.3f"), Empiric Variance: \(vm.empiricVar, specifier: "%.3f"), error: \(round(vm.empiricVarError * 100.0) / 100.0, specifier: "%.2f")%")
                Text("Chi square: \(round(vm.chiSquare * 100.0) / 100.0, specifier: "%.2f") > 11.07 is \(vm.chiSquareResult)")
            }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CRVMainView()
    }
}

