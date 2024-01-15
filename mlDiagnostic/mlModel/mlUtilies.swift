//
//  mlUtilies.swift
//  mlDiagnostic
//
//  Created by fall23 on 11/10/23.
//

/*
 Citation
 Translated to Swift from Python Source : github.com/fqjin/mhealth-tymp-classifier/blob/main/utils.py
*/

import Foundation
import CoreML


func simTracing(tpp: Double = 0, ecv: Double = 1.0, sa: Double = 1.0, zeta: Double = 2e-3, slope: Double = 5e-4) -> ([Double], [Double]) {
    let p = stride(from: -399.0, to: 201.0, by: 1.0).map { Double($0) }
    let atm = 1e5 / 10  // 1 atm in decaPascals
    var a = [Double](repeating: 0, count: p.count)

    for i in 0..<p.count {
        let denominator = (2 * atm + tpp + p[i]) * (2 * atm + tpp + p[i])
        a[i] = 1 / (1 + (tpp - p[i]) * (tpp - p[i]) / (zeta * zeta * denominator))
    }
    let a200 = a[599]
    let amax = sa / (1 - a200)
    for i in 0..<600 {
        let pi = p[i]
        a[i] *= amax
        a[i] += ecv - amax*a200
        a[i] += slope*(pi-tpp)*(pi < tpp ? 1 : 0)
    }

    return (p, a)
}

func preprocess(pressure: [Double], compliance: [Double]) -> MLMultiArray? {
    // Check if pressure is not monotonic
    for i in 1..<pressure.count {
        if pressure[i] <= pressure[i - 1] {
            return nil
        }
    }

    // Default pressure array from -399 to 200
    let default_p = Array(stride(from: -399.0, through: 200.0, by: 1.0))

    // Design a low-pass filter (fixed)
    let lpf = designLowPassFilter(order: 4, cutoffFrequency: 0.04)

    // Interpolate trace
    var trace = [Double](repeating: 0.0, count: default_p.count)
    for i in 0..<trace.count {
        trace[i] = interpolateValue(x: default_p[i], xArray: pressure, yArray: compliance)
    }
    
    // Apply the low-pass filter to trace
    let filteredTrace = sosfiltfilt(sos: lpf, signal: trace)
    
    //Turn into MLMultiArray for machine learning model input
    if let outputs = try? MLMultiArray(shape: [1,2,600], dataType: .float32){
        for i in 0..<trace.count{
            outputs[i]=NSNumber(value: trace[i])
            outputs[600+i]=NSNumber(value: filteredTrace[i])
        }
        return outputs
    }
    return nil
}



//Always the same according to the python version
func designLowPassFilter(order: Int, cutoffFrequency: Double) -> [[Double]] {
    

    return [[ 1.32937289e-05,  2.65874578e-05,  1.32937289e-05,  1.00000000e+00,
              -1.77831349e+00,  7.92447472e-01],
             [ 1.00000000e+00,  2.00000000e+00,  1.00000000e+00,  1.00000000e+00,
              -1.89341560e+00,  9.08464413e-01]]
}

func binomialCoefficient(n: Int, k: Int) -> Int {
    if k < 0 || k > n {
        return 0
    }
    
    var result = 1
    for i in 0..<min(k, n - k) {
        result *= (n - i)
        result /= (i + 1)
    }
    return result
}


func interpolateValue(x: Double, xArray: [Double], yArray: [Double]) -> Double {
    let n = xArray.count
    let i = xArray.firstIndex(where: { $0 >= x }) ?? (n - 1)

    if i == 0 {
        return yArray[0]
    } else if i == (n - 1) {
        return yArray[n - 1]
    }

    let x0 = xArray[i - 1]
    let x1 = xArray[i]
    let y0 = yArray[i - 1]
    let y1 = yArray[i]

    return y0 + (x - x0) * (y1 - y0) / (x1 - x0)
}


func sosfiltfilt(sos: [[Double]], signal: [Double]) -> [Double] {
    let numSections = sos.count
    let numSignals = signal.count

    // Initialize the filtered signal with the input signal
    var filteredSignal = signal
    var zi = [Double](repeating: 0.0, count: 2)
    // Forward filter
    for section in 0..<numSections {
        let b = sos[section][0..<3]
        let a = Array(sos[section][3..<6])

        zi = [Double](repeating: 0.0, count: 2)

        for i in 0..<numSignals {
            let x = signal[i]
            filteredSignal[i] = b[0] * x + zi[0]

            for j in 0..<2 {
                zi[j] = b[j] * x - a[j] * filteredSignal[i] + zi[j]
            }
        }
        
        zi = [Double](repeating: 0.0, count: 2)

        for i in (0..<numSignals).reversed() {
            let x = filteredSignal[i]
            filteredSignal[i] = b[0] * x + zi[0]

            for j in 0..<2 {
                zi[j] = b[j] * x - a[j] * filteredSignal[i] + zi[j]
            }
        }
        
    }
    return filteredSignal
}
