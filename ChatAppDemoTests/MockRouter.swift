//
//  MockRouter.swift
//  ChatAppDemoTests
//
//  Created by Vishnu Dutt on 16/02/23.
//

import Foundation
@testable import ChatAppDemo

class MockRouter: LoginRouterType {
    var presentMainViewController = false
    
    func presentMainViewController(user: ChatAppDemo.UserModel) {
        presentMainViewController = true
    }
}
