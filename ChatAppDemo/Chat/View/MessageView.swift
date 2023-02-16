import SwiftUI

struct MessageView : View {
    var currentMessage: MessageModel
    var body: some View {
        HStack(alignment: .bottom, spacing: 15) {
            if !currentMessage.user.isCurrentUser {
                AsyncImage(url: URL(string: currentMessage.user.avatar!)) { image in
                    image.resizable()
                } placeholder: {
                    Color.yellow
                }
                .shadow(radius: 20)
                .cornerRadius(20)
                .frame(width: 40, height: 40, alignment: .center)
                
            } else {
                Spacer()
            }
            ContentMessageView(currentMessage: currentMessage)
        }.padding()
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(currentMessage: MessageModel(content: "Test message", user: UserModel(name: "Vishnu", avatar: "", isCurrentUser: true)))
    }
}
