//
//  mlTestView.swift
//  mlDiagnostic
//
//  Created by fall23 on 11/10/23.
//

import SwiftUI

struct mlTestView: View {
    let model = PredictModel()
    @State private var z:[Double] = [0,0,0,0]
    @State private var i = 0
    @State private var a = "No Predict"
    @State private var in1 : String = ""
    @State private var in2 : String = ""
    @State private var in3 : String = ""
    @State private var in4 : String = ""
    @State private var in5 : String = ""
    var body: some View {
        VStack{
            HStack{
                Text("tpp: ")
                TextField("0", text: $in1)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .offset(y:-5)
            }
            .padding()
            HStack{
                Text("ecv: ")
                TextField("1.0", text: $in2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .offset(y:-5)
            }
            .padding()
            HStack{
                Text("sa: ")
                TextField("1.0", text: $in3)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .offset(y:-5)
            }
            .padding()
            HStack{
                Text("zeta: ")
                TextField("2e-3", text: $in4)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .offset(y:-5)
            }
            .padding()
            HStack{
                Text("slope: ")
                TextField("5e-4", text: $in5)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .offset(y:-5)
            }
            .padding()
            Button {
                if let tpp = Double(in1), let ecv = Double(in2),let sa = Double(in3), let zeta = Double(in4), let slope = Double(in5){
                    (z,i,a) = model.predict(tpp:tpp,ecv:ecv,sa:sa,zeta:zeta,slope:slope)
                }
                
            } label: {
                Text("Predict")
                    
            }
            .foregroundColor(.white)
            .padding(.horizontal,20)
            .padding(.vertical,5)
            .background(.blue)
//            (z,i,a) = model.predict()
            HStack{
                Text("RES:")
                    .padding()
                Text("\(i)")
                Text(a)
                Spacer()
            }
            .padding()
            
            HStack(alignment: .top){
                VStack{
                    Text("ECV")
                    Divider()
                    Text("\(z[0])")
                }
                Divider()
                VStack{
                    Text("TPP")
                    Divider()
                    Text("\(z[1])")
                }
                Divider()
                VStack{
                    Text("ECV_std")
                    Divider()
                    Text("\(z[2])")
                }
                Divider()
                VStack{
                    Text("TPP_std")
                    Divider()
                    Text("\(z[3])")
                }
                

            }
                            
            Spacer()
        }
    }
}

#Preview {
    mlTestView()
}
