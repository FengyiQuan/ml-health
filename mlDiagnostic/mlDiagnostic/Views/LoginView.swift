//
//  LoginView.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 11/1/23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var dbModel: AppModel
    @EnvironmentObject var modelData: ModelData
    @State private var username = ""
    // used for new user
    @State private var gender = "Male"
    @State private var age = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State var showError = false
    @State var errorMessage = "oops, something went wrong"
    
    var body: some View {
        if modelData.loggedIn {
            TabsView()
//            if new user, register
        } else if modelData.shownNewUserInfoView {
            askInfoView
//            else login
        } else {
            loginView
        }
    }
    
    private var askInfoView: some View {
        Form {
            Section(header: Text("User Information")) {
                Picker("Gender", selection: $gender) {
                    Text("Male").tag("Male")
                    Text("Female").tag("Female")
                    Text("Other").tag("Other")
                }
                   
                TextField("Age", text: $age)
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
            }
               
            Button(action: {

                let participant = Participant(username: username, fName: firstName, lName: lastName)
                let res = dbModel.participantDao.create(entity: participant)
                if res {
                    modelData.login(username: username)
                } else {
                }
                   
            }) {
                Text("Submit")
            }
        }
        .navigationBarTitle("User Info Form")
    }
    
    private var loginView: some View {
        VStack {
            Text("AI Tymponometer")
                .foregroundColor(.cyan)
                .font(.headline)
                .padding()
            HStack {
                VStack {
                    Image(systemName: "ear")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(x: -1, y: 1)
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Text("Left")
                        .textCase(.uppercase)
                        .foregroundStyle(.blue)
                }
                
                VStack {
                    Image(systemName: "ear")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    
                    Text("Right")
                        .textCase(.uppercase)
                        .foregroundStyle(.blue)
                }
            }
            .frame(width: 150, height: 300)
            
            Form {
                Section {
                    Text("Participant Username")
                        .foregroundColor(.cyan)
                        .font(.headline)
                        .padding()
                    TextField("Username", text: $username)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding()
                }
            }.frame(height: 200)
            
            StyledButton(title: "Continue", action: continueHandler)
        }
    }
    
    private func continueHandler() {
        modelData.login(username: username)
    }
}
//
//#Preview {
//    LoginView()
//}
