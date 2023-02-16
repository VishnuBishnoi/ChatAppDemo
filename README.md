# ChatAppDemo

<img width="898" alt="Screenshot 2023-02-16 at 1 47 26 PM" src="https://user-images.githubusercontent.com/13540303/219307053-1b6d106a-0482-4d5c-9a00-ba6082a1f7f2.png">

Functional Requirements:-
1. Build a group chatting app using Sendbird chat SDK.
2. Create authentication and userID creation screen. 
3. Once authenticated show channel/group list screen
  3.1  It should show all the public channels 
  3.2 Option to create a new channel.
  3.2 option to leave a channel
  3.4 Add pull to refresh to refresh channel list screen
4. On selection on a channel show chat screen
  4.1 Add current user to selected channel.
  4.1 Show messages from all the participants along with profile photo and time.
  4.2 Different UI for current user and other users.
  4.3 UI to type a message and send.

Non Functional Requirements
1. Use SwiftUI, Combine, ViewModel.
2. Abstract out  Sendbird SDK so that we can move to in-house or any other third party sdk without any changes required in our View and viewModels.
3. Write clean reusable testable code.


