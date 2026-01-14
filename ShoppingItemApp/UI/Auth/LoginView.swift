//
//  LoginView.swift
//  ShoppingItemApp
//
//  Created by Gemini on 1/13/26.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(AppState.self) private var appState
    @State private var viewModel: LoginViewModel?
    
    var body: some View {
        Group {
            if let viewModel {
                LoginContentView(viewModel: viewModel)
            }
            else {
                ProgressView()
            }
        }
        .task {
            if viewModel == nil {
                viewModel = appState.makeLoginViewModel()
            }
        }
    }
}

struct LoginContentView: View {
    
    fileprivate var viewModel: LoginViewModel
    
    var body: some View {
        
        @Bindable var bindableViewModel = viewModel
        
        VStack {
            Text("Login")
                .font(.largeTitle)
                .padding()
            
            TextField("Username", text: $bindableViewModel.username)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $bindableViewModel.password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                Task {
                    await viewModel.login()
                }
            }) {
                Text("Login")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }
            .padding()
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
