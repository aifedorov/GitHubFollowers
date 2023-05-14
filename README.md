**GitHub Followers - Technical Assessment**
Build an iOS application that allows users to search for GitHub users and view their followers. The app should have the following features:

1. User Search
    * Provide a search bar where users can enter a GitHub username.
    * Fetch and display the basic profile information for the searched user, including their avatar, username, and follower count.
2. Followers List
    * Display a list of followers for the searched user.
    * Each follower cell should show their avatar, username, and a button to view their profile details.
3. Profile Details
    * When a user taps on a follower cell, navigate to a screen that displays detailed information about the follower.
    * Display their avatar, username, follower count, following count, and bio.
    * Provide a button to navigate to the follower's GitHub profile in a web view.
4. Pagination
    * Implement pagination to load more followers as the user scrolls through the list.
    * Fetch and display followers in batches of 30.
5. Error Handling
    * Implement appropriate error handling for API failures, network errors, and invalid user searches.
    * Display error messages to the user when necessary.
6. Persistence
    * Implement data persistence to cache the previously fetched follower list and basic profile information.
    * The app should display cached data when offline or during subsequent app launches.
7. UI/UX
    * Create a visually appealing and intuitive user interface.
    * Use appropriate navigation patterns and transitions.
    * Ensure smooth scrolling and responsive layout on different device sizes.

**Technical Requirements:**
* The app should be developed using Swift and minimal target iOS 14.
* Not allowed to use of third-party libraries.
* Implement error handling and provide a good user experience.
* Use Git for version control and commit your work frequently.
* Implement supporting Dark Mode in your Interface.
* Write clean, modular, and well-structured code.
* Provide clear instructions on how to build and run the project.

**Getting Started**
1. Install XCode 14.1.0.
2. Clone this repository.
3. Build and run app.
