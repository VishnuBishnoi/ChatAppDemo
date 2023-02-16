//
//  LoginViewModel.swift
//  ChatAppDemo
//
//  Created by Vishnu Dutt on 15/02/23.
//

import Combine
import Foundation

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
    var errorMessage = "false"
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
    
    private func fetchCachedUser() async {
        if usecase.isAutoLogin, let userName = usecase.userId {
            await connectUser(userId: userName)
        }
    }
    
    func connectUser(userId: String) async {
        isDataLoading = true
        let result = await usecase.login(userId: userId)
        isDataLoading = false
        switch result {
        case .success(let user):
            self.user = user
        case .failure(let error):
            self.errorMessage = error.localizedDescription
            self.showAlert = true
        }
    }
}
