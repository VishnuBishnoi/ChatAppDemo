//
//  LoginRouter.swift
//  ChatAppDemo
//
//  Created by Vishnu Dutt on 16/02/23.
//

import Foundation
import SwiftUI

protocol LoginRouterType {
    func presentMainViewController(user: UserModel)
}

class LoginRouter: LoginRouterType {
    func presentMainViewController(user: UserModel) {
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
