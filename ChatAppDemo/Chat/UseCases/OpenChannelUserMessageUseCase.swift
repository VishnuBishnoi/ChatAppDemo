import Foundation
import SendbirdChatSDK

class OpenChannelUserMessageUseCase {
    
    let channel: OpenChannel
    
    init(channel: OpenChannel) {
        self.channel = channel
    }
    
    func sendMessage(_ message: String, completion: @escaping (Result<UserMessage, SBError>) -> Void) -> UserMessage? {
        return channel.sendUserMessage(message) { message, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let message = message else { return }
            
            completion(.success(message))
        }
    }
    
    func resendMessage(_ message: UserMessage, completion: @escaping (Result<BaseMessage, SBError>) -> Void) {
        channel.resendUserMessage(message) { message, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let message = message else { return }
            
            completion(.success(message))
        }
    }
    
    func updateMessage(_ message: UserMessage, to newMessage: String, completion: @escaping (Result<UserMessage, SBError>) -> Void) {
        let params = UserMessageUpdateParams(message: newMessage)

        channel.updateUserMessage(messageId: message.messageId, params: params) { message, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let message = message else { return }
            
            completion(.success(message))
        }
    }
    
    func deleteMessage(_ message: BaseMessage, completion: @escaping (Result<Void, SBError>) -> Void) {
        channel.deleteMessage(message) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }
    }
}
