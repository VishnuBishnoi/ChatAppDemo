//
//  ChatUseCase.swift
//  ChatAppDemo
//
//  Created by Vishnu Dutt on 16/02/23.
//

import Foundation
import SendbirdChatSDK
import Combine

enum ChannelListUseCaseError: Error {
    case genricError
    case error(String)

    var message: String {
        switch self {
        case .genricError:
            return "Something went wrong"
        case .error(let string):
            return string
        }
    }
}

protocol ChatUseCaseType {
    func loadInitialMessagesfor(channelModel: ChannelListModel, userID: String) -> AnyPublisher<[MessageModel], ChannelListUseCaseError>
    func enterChannel(_ channelModel: ChannelListModel) -> Future<Void, ChannelListUseCaseError>
    func sendMessage(message: String, channelModel: ChannelListModel) -> AnyPublisher<UserMessage, ChannelListUseCaseError>
}

final class ChatUseCase: NSObject, ChatUseCaseType {
    private let channelUsecase: OpenChannelListUseCaseType
    
    private enum Constant {
        static let previousResultSize: Int = 20
        static let nextResultSize: Int = 20
    }
    
    private var channels: [OpenChannel] {
        channelUsecase.channels
    }
    
    init(channelUsecase: OpenChannelListUseCaseType) {
        self.channelUsecase = channelUsecase
        super.init()
        addEventObserver()
    }
    
    deinit {
        removeEventObserver()
    }
    
    func addEventObserver() {
        SendbirdChat.addChannelDelegate(self, identifier: description)
    }
    
    func removeEventObserver() {
        SendbirdChat.removeChannelDelegate(forIdentifier: description)
    }
    
    func loadInitialMessagesfor(channelModel: ChannelListModel, userID: String) -> AnyPublisher<[MessageModel], ChannelListUseCaseError> {
        return Future<[MessageModel], ChannelListUseCaseError> { promise in
            let params = self.createMessageListParams()
            let channel = self.channels.first(where: {$0.id == channelModel.id })!
            channel.getMessagesByTimestamp(.max, params: params) { messages, error in
                if let error = error {
                    promise(.failure(.error(error.localizedDescription)))
                    return
                }
                
                guard let messages = messages else { return }
                let messageModels = messages.map { baseMessage in
                    return MessageModel(content: baseMessage.message, user: UserModel(name: baseMessage.sender?.userId, avatar: baseMessage.sender?.originalProfileURL, isCurrentUser: baseMessage.sender?.userId == userID))
                }
                promise(.success(messageModels))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func sendMessage(message: String, channelModel: ChannelListModel) -> AnyPublisher<UserMessage, ChannelListUseCaseError> {
        return Future { promise in
            let channel = self.channels
                .first(where: {$0.id == channelModel.id })!
            
            _ = OpenChannelUserMessageUseCase(channel: channel)
                .sendMessage(message) { result in
                    switch result {
                    case .success(let message):
                        promise(.success(message))
                    case .failure(let error):
                        promise(.failure(.error(error.localizedDescription)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func enterChannel(_ channelModel: ChannelListModel) -> Future<Void, ChannelListUseCaseError> {
        return Future { promise in
            self.enterChannel(channelModel) { result in
                promise(result)
            }
        }
    }
}

extension ChatUseCase {
    private func createMessageListParams() -> MessageListParams {
        let params = MessageListParams()
        params.isInclusive = true
        params.previousResultSize = Constant.previousResultSize
        params.nextResultSize = Constant.nextResultSize
        params.includeParentMessageInfo = true
        params.replyType = .all
        params.includeThreadInfo = true
        params.includeMetaArray = true
        return params
    }
    
    private func enterChannel(_ channelModel: ChannelListModel, completion: @escaping (Result<Void, ChannelListUseCaseError>) -> Void) {
        let channel = channels.first(where: {$0.id == channelModel.id })!
        channel.enter { error in
            if let error = error {
                completion(.failure(.error(error.localizedDescription)))
            } else {
                completion(.success(()))
            }
        }
    }
}

extension ChatUseCase: BaseChannelDelegate {
    func channel(_ channel: SendbirdChatSDK.BaseChannel, didReceive message: SendbirdChatSDK.BaseMessage) {
        print("-----------------------------------------------------")
        print(message)
    }
}
