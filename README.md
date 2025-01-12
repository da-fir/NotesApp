# NotesApp

TaskManagement App
Setup Instructions
This project uses Swift Package Manager (SPM) for dependency management, specifically for Realm. Follow these steps to get started:

Clone the Repository:

git clone https://github.com/da-fir/NotesApp.git
cd NotesApp
Open the Project in Xcode:
Open the .xcodeproj file in Xcode.

Make sure all dependencies are installed and build the project to ensure everything is set up correctly.
Run the App and Tests:

Use the Xcode simulator or a real device to run the app.
To run unit tests, use Cmd + U or navigate to the test section in the Xcode UI.

Architecture Overview
This app follows the MVVM (Model-View-ViewModel) architecture. The main components are:

Model: Represents the data and business logic. In this case, it includes the TaskObject and the Realm database managed through TaskManager.

View: The SwiftUI views that present the user interface. They subscribe to changes in the ViewModel using Combine and update the UI accordingly.

ViewModel: Manages the application's state and business logic using @Published properties. It provides an interface for the views to interact with data and is responsible for the central logic including async operations with async/await and Combine publishers for observing the tasks.

The app leverages async/await for asynchronous network calls and data fetching, ensuring a clean and modern structured approach. Combine is used for handling reactive programming, particularly in responding to state changes in the ViewModel.

Explanation of Key Design Decisions
Centralized Logic in ViewModel: The logic is centralized in the TaskListViewModel, where all data manipulation and state management are handled. This keeps the views slim and focused solely on UI-related code.

ViewModel Depends on TaskManager and AuthenticationService: The ViewModel has dependencies on TaskManager for task operations (like loading, adding, and deleting tasks) and AuthenticationService for managing authentication state. This separation ensures that each component has a single responsibility, facilitating easier testing and maintenance.

Known Limitations and Future Improvements
Managing Realm Objects: Care must be taken to manage Realm objects correctly, as improper handling can lead to issues with memory and data integrity. Potential improvements could involve more robust error handling and caching strategies.

UI Tests with Mock: UI tests should be able to utilize mocks to prevent reliance on actual network calls and database operations during testing, ensuring tests run quickly and consistently.

More Detailed Unit Tests: While the current unit tests cover basic functionality, there is room for improvement. More comprehensive tests could be added, including edge cases and error handling scenarios, to ensure robustness.

Asynchronous Testing: Future tests could benefit from better asynchronous testing strategies using XCTest expectations to cover scenarios that involve network delays or heavy computations.

This README serves as an overview of the project, guiding developers and testers through setup, architectural design, and areas for improvement.