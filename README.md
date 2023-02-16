# ChatAppDemo

<img width="958" alt="Screenshot 2023-02-16 at 2 09 07 PM" src="https://user-images.githubusercontent.com/13540303/219312398-f2a838ac-3869-4f85-8604-16293f0c25bb.png">


Functional Requirements:-

1. Build a group chatting app using Sendbird chat SDK.
2. Create authentication and userID creation screen
3. Once authenticated show the channel/group list screen 
    3.1 It should show all the public channels 
    3.2 Options to create a new channel. 
    3.4 option to leave a channel 
    3.5 Add pull to refresh channel list screen
4. On selection on a channel show chat screen,
    4.1 Add the current user to the selected channel. 
    4.2 Show messages from all the participants along with profile photos and time. 
    4.3 Different UI for the current user and other users. 
    4.4 UI to type a message and send it.

Non Functional Requirements

1. Use SwiftUI, Combine, Structured concurrency, and MVVM.
2. Abstract out Sendbird SDK so that we can move to in-house or any other third-party SDK without any changes required in our View and ViewModel.
3. Write clean reusable testable code.
