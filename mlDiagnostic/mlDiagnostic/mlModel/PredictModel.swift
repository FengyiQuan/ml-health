//
//  PredictModel.swift
//  mlDiagnostic
//
//  Created by fall23 on 11/10/23.
//

import Foundation
import CoreML

class PredictModel{
    let loadedModel = try? TypmModel()
    static let typeDict = [1: "A",2:"B",3:"C"]
    
    func predict(tpp: Double = 0, ecv: Double = 1.0, sa: Double = 1.0, zeta: Double = 2e-3, slope: Double = 5e-4)->([Double],Int,String){
        let (p,a) = simTracing(tpp:tpp,ecv:ecv,sa:sa,zeta: zeta,slope: slope)
        if let inputs = preprocess(pressure: p, compliance: a){
            return predict(inputs:inputs)
        }
        return ([0,0,0,0],-1,"Wrong Res")
    }
    
    
    func predict(inputs: MLMultiArray)->([Double],Int,String){
        if let modle = loadedModel{
            if let out = try? modle.prediction(input_1: inputs){
                let z_11 = out.z_11
                let factors : [Double] = [z_11[0].doubleValue,z_11[1].doubleValue,z_11[2].doubleValue,z_11[3].doubleValue]
                let pred = Int(out.var_488[0].doubleValue)
                if let pred_type = PredictModel.typeDict[pred]{
                    return (factors, pred, pred_type)
                }
            }
        }
        return ([0,0,0,0],-1,"Wrong Res")
    }
    
}
