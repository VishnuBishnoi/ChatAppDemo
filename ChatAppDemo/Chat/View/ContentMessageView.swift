import SwiftUI

struct ContentMessageView: View {
    var currentMessage: MessageModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(currentMessage.user.name ?? "No Name")
                .foregroundColor(.gray)
                .font(.callout)
            
            Text(currentMessage.content)
                .padding(10)
                .foregroundColor(currentMessage.user.isCurrentUser ? Color.white : Color.black)
                .background(currentMessage.user.isCurrentUser ? Color.blue : Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
                .cornerRadius(10)
        }
        .buttonBorderShape(.capsule)
    }
}

struct ContentMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ContentMessageView(currentMessage: MessageModel(content: "Vishnu", user: UserModel(name: "Vishnu", avatar: "", isCurrentUser: true)))
    }
}
