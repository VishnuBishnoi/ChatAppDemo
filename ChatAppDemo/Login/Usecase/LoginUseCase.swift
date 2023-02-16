import Foundation
import SendbirdChatSDK
import UIKit

fileprivate enum ApplicationId {
    case sample
    case custom(String)
    
    var rawValue: String {
        switch self {
        case .sample:
            return "A17ACB9B-9D48-4EB0-909B-74EFE1DA9048"
        case .custom(let value):
            return value
        }
    }
}

final class LoginUseCase: LoginUseCaseType {
    @UserDefault(key: "sendbird_auto_login", defaultValue: false)
    private(set) var isAutoLogin: Bool
    
    @UserDefault(key: "sendbird_user_id", defaultValue: nil)
    private(set) var userId: String?
    
    var currentUser: UserModel? {
        guard let currentUser = SendbirdChat.getCurrentUser() else {
            return nil
        }
        return UserModel(name: currentUser.userId, avatar: currentUser.profileURL, isCurrentUser: true)
    }
    
    init() {
        initEnvironment()
    }
    
    func login(userId: String) async -> Result<UserModel, ChannelListUseCaseError> {
        return await withCheckedContinuation { continuation in
            SendbirdChat.connect(userId: userId) { [weak self] user, error in
                if let error = error {
                    continuation.resume(returning: .failure(.error(error.localizedDescription)))
                    return
                }
                guard let user = user else { return }
                let userModel = UserModel(name: user.userId, avatar: user.profileURL, isCurrentUser: true)
                self?.storeUserInfo(user)
                continuation.resume(returning: .success(userModel))
            }
        }
    }
    
    func initEnvironment() {
        let initParams = InitParams(
            applicationId: ApplicationId.sample.rawValue,
            isLocalCachingEnabled: false,
            logLevel: .error,
            appVersion: "1.0.0"
        )
        SendbirdChat.initialize(params: initParams)
    }
    
    private func storeUserInfo(_ user: User) {
        userId = user.userId
        isAutoLogin = true
    }
}
