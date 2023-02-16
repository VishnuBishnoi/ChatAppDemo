//
//  ChatViewViewModel.swift
//  ChatAppDemo
//
//  Created by Vishnu Dutt on 15/02/23.
//
import Combine

class ChatViewViewModel: ObservableObject {
    private let useCase: ChatUseCaseType
    private var cancellables = Set<AnyCancellable>()
    let channelModel: ChannelListModel
    var user: UserModel
    @Published var messages = [MessageModel]()
    
    init(useCase: ChatUseCaseType, channelModel: ChannelListModel, userModel: UserModel) {
        self.useCase = useCase
        self.channelModel = channelModel
        self.user = userModel
        useCase
            .loadInitialMessagesfor(channelModel: channelModel, userID: userModel.name!)
            .mapError({ error in
                // TODO Handle error
                return error
            })
            .replaceError(with: [])
            .assign(to: &$messages)
    }
    
    func sendMessage(_ chatMessage: MessageModel) {
        useCase
            .sendMessage(message: chatMessage.content, channelModel: channelModel)
            .sink(receiveCompletion: {_ in }) { _ in
                self.messages.append(chatMessage)
            }
            .store(in: &cancellables)
    }
    
    func enterChannel() {
        useCase
            .enterChannel(channelModel)
            .sink(receiveCompletion: {_ in }) { _ in
                // Handle error here
            }
            .store(in: &cancellables)
    }
}
