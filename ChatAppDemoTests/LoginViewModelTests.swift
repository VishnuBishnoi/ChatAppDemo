//
//  LoginViewModelTests.swift
//  ChatAppDemoTests
//
//  Created by Vishnu Dutt on 16/02/23.
//

import XCTest
@testable import ChatAppDemo

@MainActor
final class LoginViewModelTests: XCTestCase {
    private var loginViewModel: LoginViewModel!
    private var mockUseCase = MockLoginUseCase()

    override func setUpWithError() throws {
        self.loginViewModel = LoginViewModel(usecase: mockUseCase)
    }

    func testExample() throws {
     
    }

}
