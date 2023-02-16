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
    
    private let usecase: LoginUseCaseType = LoginUseCase()
    
    init()  {
        loadCachedUser()
    }
    
    private func loadCachedUser() {
        guard let currentUser = usecase.currentUser else {
            Task {
                await fetchCachedUser()
            }
            return
        }
        self.user = currentUser
    }
    
    func loginButtonTapped(name: String) {
        if !name.isEmpty {
            Task {
                await connectUser(userId: name)
            }
        } else {
            errorMessage = "Please enter a valid username"
        }
    }
    
    func continueButtonTapped() {
        if let user = user {
            presentMainViewController(user: user)
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
            self.errorMessage = error.localizedDescription
        }
    }
    
    private func presentMainViewController(user: UserModel) {
        let tabBarController = UITabBarController()
        let channelListView = ChannelListView(viewModel: ChannelListViewModel(user: user))
        tabBarController.setViewControllers([
            UINavigationController(rootViewController: UIHostingController(rootView: channelListView))
        ], animated: false)
        tabBarController.modalPresentationStyle = .fullScreen
    
        let window = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as?UIWindowScene)?.windows ?? [] }
            .first(where: \.isKeyWindow)
        window?.rootViewController?.present(tabBarController, animated: true)
    }
}
