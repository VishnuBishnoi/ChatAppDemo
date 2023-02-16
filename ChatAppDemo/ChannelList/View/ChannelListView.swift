//
//  ChannelListView.swift
//  ChatAppDemo
//
//  Created by Vishnu Dutt on 14/02/23.
//

import SwiftUI
import Combine

struct ChannelListView: View {
    @StateObject var viewModel: ChannelListViewModel
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack() {
                    AsyncImage(url: URL(string: viewModel.user.avatar!)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.yellow
                    }
                    .frame(width: 40, height: 40, alignment: .center)
                    .shadow(radius: 20)
                    .cornerRadius(20)
                    .padding()
                    Text(viewModel.user.name ?? "No Name")
                        .foregroundColor(Color.black)
                        .cornerRadius(10)
                }
                
                List(viewModel.channels, id: \.id) { channel in
                    NavigationLink {
                        ChatView(useCase: ChatUseCase(channelUsecase: viewModel.useCase), channelModel: channel, userModel: viewModel.user)
                    } label: {
                        ChannelListRowView(channel: channel)
                            .swipeActions(allowsFullSwipe: false) {
                                Button {
                                    viewModel.exit(channel: channel)
                                } label: {
                                    Text("Leave")
                                }
                                .tint(.red)
                            }
                    }
                }
                .navigationTitle("Channels")
                .refreshable {
                    viewModel.pullToRefresh()
                }
            }
        }
    }
}

struct ChannelListView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelListView(viewModel: ChannelListViewModel(user: UserModel()))
    }
}


struct ChannelListRowView: View {
    var channel: ChannelListModel
    
    var body: some View {
        HStack {
            Text(channel.name)
        }
    }
}

struct ChannelListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelListRowView(channel: ChannelListModel(id: "UUID()", name: "test"))
    }
}


