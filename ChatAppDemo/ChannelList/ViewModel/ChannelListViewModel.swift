//
//  ChannelListViewModel.swift
//  ChatAppDemo
//
//  Created by Vishnu Dutt on 14/02/23.
//
import Combine
import Foundation

class ChannelListViewModel: ObservableObject {
    @Published var channels: [ChannelListModel]
    var user: UserModel
    lazy var useCase: OpenChannelListUseCaseType = ChannelListUseCase()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(user: UserModel) {
        self.user = user
        self.channels = [ChannelListModel]()
        refreshList()
    }
    
    func pullToRefresh() {
        refreshList()
    }
    
    func exit(channel: ChannelListModel) {
        useCase.exitChannel(channel)
            .sink { _ in } receiveValue: { result in
                //TODO handle result
            }
            .store(in: &cancellables)
    }
    
    private func refreshList() {
        useCase
            .reloadChannels()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .mapError { error in
                //TODO handle error
                return error
            }
            .replaceError(with: [ChannelListModel]())
            .assign(to: &$channels)
    }
}
