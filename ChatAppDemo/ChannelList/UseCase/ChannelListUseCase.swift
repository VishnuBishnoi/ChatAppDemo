//
//  ChannelListUseCase.swift
//  ChatAppDemo
//
//  Created by Vishnu Dutt on 16/02/23.
//

import Foundation
import SendbirdChatSDK
import Combine

protocol OpenChannelListUseCaseType {
    var channels: [OpenChannel] { get }
    func reloadChannels() -> AnyPublisher<[ChannelListModel] , ChannelListUseCaseError>
    func exitChannel(_ channel: ChannelListModel) -> Future<Void, ChannelListUseCaseError>
}

class ChannelListUseCase: NSObject, OpenChannelListUseCaseType {
    private lazy var channelListQuery: OpenChannelListQuery = createOpenChannelListQuery()
    var channels: [OpenChannel] = []

    func reloadChannels() -> AnyPublisher<[ChannelListModel], ChannelListUseCaseError> {
        return Future { promise in
            guard self.channelListQuery.isLoading == false else {
                promise(.failure(ChannelListUseCaseError.genricError))
                return
            }
            self.channelListQuery = self.createOpenChannelListQuery()
            self.channelListQuery.loadNextPage { channels, error in
                if let error = error {
                    promise(.failure(ChannelListUseCaseError.error(error.localizedDescription)))
                }
                
                guard let channels = channels else {
                    promise(.failure(ChannelListUseCaseError.genricError))
                    return
                }
                self.channels = channels
                promise(.success(channels))
            }
        }
        .map(convertToChannelListModel)
        .eraseToAnyPublisher()
    }
    
    func exitChannel(_ channel: ChannelListModel) -> Future<Void, ChannelListUseCaseError> {
        return Future { promise in
            self.exitChannel(channel) { result in
                promise(result)
            }
        }
    }
}

extension ChannelListUseCase {
    private func convertToChannelListModel(list: [OpenChannel]) -> [ChannelListModel] {
        return list.map { ChannelListModel(id: $0.id, name: $0.name) }
    }
    
    private func exitChannel(_ channelModel: ChannelListModel, completion: @escaping (Result<Void, ChannelListUseCaseError>) -> Void) {
        let channel = channels.first(where: {$0.id == channelModel.id })!
        channel.exit { error in
            if let error = error {
                completion(.failure(.error(error.localizedDescription)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    private func createOpenChannelListQuery() -> OpenChannelListQuery {
        let channelListQuery = OpenChannel.createOpenChannelListQuery {
            $0.limit = 20
        }
        return channelListQuery
    }
}
