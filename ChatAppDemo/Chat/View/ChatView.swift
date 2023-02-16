import Combine
import SwiftUI

struct ChatView: View {
    @State private var typingMessage: String = ""
    @ObservedObject private var viewModel: ChatViewViewModel
    @ObservedObject private var keyboard = KeyboardResponder()
    
    init(useCase: ChatUseCase, channelModel: ChannelListModel, userModel: UserModel) {
        self.viewModel = ChatViewViewModel(useCase: useCase, channelModel: channelModel, userModel: userModel)
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.messages, id: \.self) { msg in
                    MessageView(currentMessage: msg)
                }
            }
            HStack {
                TextField("Message...", text: $typingMessage)
                    .textFieldStyle(.roundedBorder)
                    .frame(minHeight: CGFloat(30))
                Button(action: {
                    viewModel.sendMessage(MessageModel(content: typingMessage, user: viewModel.user))
                    typingMessage = ""
                }) {
                    Text("Send")
                }
            }.frame(minHeight: CGFloat(50)).padding()
                .navigationBarTitle(Text(viewModel.channelModel.name), displayMode: .inline)
                .padding(.bottom, keyboard.currentHeight)
                .edgesIgnoringSafeArea(keyboard.currentHeight == 0.0 ? .leading: .bottom)
        }.onTapGesture {
            self.endEditing(true)
        }.onAppear {
            viewModel.enterChannel()
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        let usecase = ChatUseCase(channelUsecase: ChannelListUseCase())
        ChatView(useCase: usecase, channelModel: ChannelListModel(id: "ada", name: "asa"), userModel: UserModel(name: "Vishnu", avatar: "sdf", isCurrentUser: true))
    }
}
