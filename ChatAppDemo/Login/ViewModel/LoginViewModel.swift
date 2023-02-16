//
//  LoginViewModel.swift
//  ChatAppDemo
//
//  Created by Vishnu Dutt on 15/02/23.
//

import Combine
import Foundation
import SwiftUI

protocol LoginUseCaseType {
    var currentUser: UserModel? { get }
    var userId: String? { get  }
    var isAutoLogin: Bool { get  }
    func login(userId: String) async -> Result<UserModel, ChannelListUseCaseError>
}

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var user: UserModel?
    @Published var isDataLoading = false
    
    @Published var showAlert = false
    var errorMessage = "false" {
        didSet {
            showAlert = true
        }
    }
    
    private let usecase: LoginUseCaseType
    private let router: LoginRouterType
    
    init(usecase: LoginUseCaseType = LoginUseCase(), router: LoginRouterType = LoginRouter()) {
        self.usecase = usecase
        self.router = router
    }
    
    func fetchUserIfAlreadyLogedIn() async {
        guard let currentUser = usecase.currentUser else {
            await fetchCachedUser()
            return
        }
        self.user = currentUser
    }
    
    func loginButtonTapped(name: String) async {
        if !name.isEmpty {
            await connectUser(userId: name)
        } else {
            errorMessage = "Please enter a valid username"
        }
    }
    
    func continueButtonTapped() {
        if let user = user {
            router.presentMainViewController(user: user)
        } else {
            errorMessage = "Please login"
        }
    }
    
    private func fetchCachedUser() async {
        if usecase.isAutoLogin, let userName = usecase.userId {
            await connectUser(userId: userName)
        }
    }
    
    private func connectUser(userId: String) async {
        isDataLoading = true
        let result = await usecase.login(userId: userId)
        isDataLoading = false
        switch result {
        case .success(let user):
            self.user = user
        case .failure(let error):
            self.errorMessage = error.message
        }
    }
}
