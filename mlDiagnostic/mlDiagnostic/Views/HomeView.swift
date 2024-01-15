//
//  HomeView.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 11/1/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var sessionManager: SessionManager
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    @State private var myError:MyError?
    
    //    var person: Participant
    var person: Participant {
        modelData.currentUser!
    }
    @Binding var image: UIImage?
    var imageSaved = true
    
    var body: some View {
        
        VStack {
            Text("Profile").padding().font(.headline)
            ZStack(alignment: .bottomTrailing) {
                Button(action: {
                }, label: {
                    Image(uiImage:image!).resizable()
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(.white, lineWidth: 4)
                        }
                        .shadow(radius: 7)
                        .frame(width: 200, height: 200)
                        .onTapGesture { self.shouldPresentActionScheet = true }
//                    image picker for profile image update
                        .sheet(isPresented: $shouldPresentImagePicker) {
                            ImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$image, isPresented: self.$shouldPresentImagePicker)
                        }.actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
                            ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                                self.shouldPresentImagePicker = true
                                self.shouldPresentCamera = true
                            }), ActionSheet.Button.default(Text("Photo Library"), action: {
                                self.shouldPresentImagePicker = true
                                self.shouldPresentCamera = false
                            }), ActionSheet.Button.cancel()])
//                            update image in database when image changed
                        }.onChange(of: image) { newImage in
                            person.setUIImageStr(uiImage: newImage!)
                            modelData.updatePerson(person:person){ result in
                                switch result {
                                case .success():
                                    print("Report successfully deleted")
                                case .failure(let error):
                                    print("Error deleting report: \(error)")
                                    myError = .updateError
                                }
                            }
                            
                            print("image saved")
                        }
                })
                
                Image(systemName: "plus")
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                
            }
            
            listView
        }.alert(item: $myError) { error in
            Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")){
                sessionManager.selection = 0
            })
        }
        
    }
    
    var listView: some View {
        Form {
            Section(header: Text("Personal Information")) {
                HStack {
                    Text("Id:")
                        .font(.system(size: 13))
                    Spacer()
                    Text(person.id!.uuidString)
                        .font(.system(size: 13))
                }
                
                HStack {
                    Text("First name:")
                    Spacer()
                    Text(person.fName)
                }
                HStack {
                    Text("Last name:")
                    Spacer()
                    Text(person.lName)
                }
                
            }
        }
    }
}
//
//#Preview {
//    let modelData: ModelData = ModelData()
//    HomeView().environmentObject(modelData)
//}
