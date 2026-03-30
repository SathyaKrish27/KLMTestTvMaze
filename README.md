# iOS Interview Project Documentation

## Project Overview
This iOS interview project is designed to demonstrate proficiency in developing a comprehensive iOS application. The app integrates with the TVmaze API to provide an interactive platform for users to search for and discover television shows and their details.

## Architecture
The project adheres to a Model-View-ViewModel (MVVM) architecture, which separates concerns and enhances testability and maintainability. Components include:
- **Model**: Represents the data structure and business logic. Responsible for network calls to the TVmaze API.
- **View**: The user interface that displays data from the ViewModel and receives user interaction.
- **ViewModel**: Acts as a bridge between the Model and View, fetching data from the Model and formatting it for display in the View.

## Setup Instructions
1. **Clone the repository**:
   ```bash
   git clone https://github.com/SathyaKrish27/KLMTestTvMaze.git
   cd KLMTestTvMaze
   ```
2. **Open the project in Xcode**:
   - Double-click on the `KLMTestTvMaze.xcodeproj` file to open it in Xcode.
3. **Install dependencies**:
   - If using CocoaPods, navigate to the project directory and run:
   ```bash
   pod install
   ```
4. **Run the app**:
   - Select the desired simulator or device and click on the run button.

## Testing
Testing can be conducted using Xcode's built-in testing framework. To run the tests:
1. Open the Test navigator in Xcode.
2. Select the test cases you want to run.
3. Click the "Run" button at the bottom left of the navigator.

## Technical Stack
- **Language**: Swift
- **Framework**: UIKit for UI components
- **Networking**: URLSession for API calls
- **Dependency Management**: CocoaPods
- **Testing**: XCTest

## Interview Challenge Goals
- Demonstrate proficiency in iOS development principles and practices.
- Build a responsive and intuitive user interface.
- Manage asynchronous data with URLSession.
- Implement clean architecture using MVVM design pattern.
- Ensure code quality through testing and adherence to best practices.