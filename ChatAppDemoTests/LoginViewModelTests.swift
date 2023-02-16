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
    private var mockRouter = MockRouter()
    let mockUser = UserModel(name: "Vishnu", avatar: "test url", isCurrentUser: true)

    override func setUpWithError() throws {
        self.loginViewModel = LoginViewModel(usecase: mockUseCase, router: mockRouter)
    }
    
    func testLoginButtonTapped_withEmptyName_shouldShowError() async throws {
        await loginViewModel.loginButtonTapped(name: "")
        XCTAssertTrue(loginViewModel.showAlert)
        XCTAssertEqual("Please enter a valid username", loginViewModel.errorMessage)
    }
    
    func testLoginButtonTapped_withValidName_shouldCallLogin() async throws {
        await loginViewModel.loginButtonTapped(name: "Vishnu")
        XCTAssertTrue(mockUseCase.loginCalled)
    }
    
    func testLoginButtonTapped_withValidName_and_error_shouldReturnValidError() async throws {
        mockUseCase.result = .failure(.genricError)
        await loginViewModel.loginButtonTapped(name: "Vishnu")
        XCTAssertEqual(ChannelListUseCaseError.genricError.message, loginViewModel.errorMessage)
    }
    
    func testLoginButtonTapped_withValidName_and_response_shouldReturnValidResult() async throws {
        mockUseCase.result = .success(mockUser)
        await loginViewModel.loginButtonTapped(name: "Vishnu")
        XCTAssertEqual(loginViewModel.user, mockUser)
    }
    
    func testContinueButtonTapped_when_userIsNotLogedin() {
        loginViewModel.user = nil
        loginViewModel.continueButtonTapped()
        XCTAssertTrue(loginViewModel.showAlert)
        XCTAssertEqual("Please login", loginViewModel.errorMessage)
    }
    
    func testContinueButtonTapped_shouldNavigateToMainScreen() {
        loginViewModel.user = mockUser
        loginViewModel.continueButtonTapped()
        XCTAssertTrue(mockRouter.presentMainViewController)
    }
    
    func testFetchUserIfAlreadyLogedIn_shouldLoadUserFromCacheIFAvailable() async {
        mockUseCase.currentUser = mockUser
        await loginViewModel.fetchUserIfAlreadyLogedIn()
        XCTAssertEqual(mockUser, loginViewModel.user)
    }
    
    func testFetchUserIfAlreadyLogedIn_shoulFetchCachedUser() async {
        mockUseCase.currentUser = nil
        mockUseCase.isAutoLogin = true
        mockUseCase.userId = mockUser.name
        
        await loginViewModel.fetchUserIfAlreadyLogedIn()

        XCTAssertTrue(mockUseCase.loginCalled)
    }
}
