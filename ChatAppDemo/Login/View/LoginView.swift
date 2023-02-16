//
//  LoginView.swift
//  ChatAppDemo
//
//  Created by Vishnu Dutt on 15/02/23.
//

import SwiftUI

struct LoginView: View {
    @State var name: String = ""
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        LoadingView(isShowing: $viewModel.isDataLoading) {
            VStack() {
                Spacer()
                if let useName = viewModel.user?.name {
                    Text( "You are logged in as: \(String(describing: useName)), Press continue or enter another username to login with a different user")
                        .padding()
                } else {
                    Text( "You are not loggedin, Please enter username and login")
                        .padding()
                }
                Spacer()
                TextField("Name",
                          text: $name ,
                          prompt: Text("User name").foregroundColor(.blue)
                )
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue, lineWidth: 2)
                }
                .padding(.horizontal)
                
                Button {
                    Task {
                        await viewModel.loginButtonTapped(name: name)
                    }
                } label: {
                    Text("Login")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .cornerRadius(20)
                .padding()
                
                Button {
                    viewModel.continueButtonTapped()
                } label: {
                    Text("Continue")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .cornerRadius(20)
                .padding()
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("Got it!")))
            }
            
        }.onAppear {
            Task {
                await viewModel.fetchUserIfAlreadyLogedIn()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
