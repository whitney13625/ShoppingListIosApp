//
//  LoginView.swift
//  ShoppingItemApp
//
//  Created by Gemini on 1/13/26.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(AppState.self) private var appState
    @State var viewModel: LoginViewModel
    
    init(appState: AppState) {
        _viewModel = State(initialValue: appState.makeLoginViewModel())
    }
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .padding()
            
            TextField("Username", text: $viewModel.username)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: Bindable(viewModel).password)
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
        .onAppear() {
            viewModel = appState.makeLoginViewModel()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(appState: .stub)
    }
}
