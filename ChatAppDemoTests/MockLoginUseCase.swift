//
//  MockLoginUseCase.swift
//  ChatAppDemoTests
//
//  Created by Vishnu Dutt on 16/02/23.
//

import XCTest
import Combine
@testable import ChatAppDemo

class MockLoginUseCase: LoginUseCaseType {
    var currentUser: ChatAppDemo.UserModel?
    var userId: String? = nil
    var isAutoLogin: Bool = false
    
    var result: Result<UserModel, ChannelListUseCaseError>!
    func login(userId: String) async -> Result<UserModel, ChannelListUseCaseError> {
        return result
    }
}

