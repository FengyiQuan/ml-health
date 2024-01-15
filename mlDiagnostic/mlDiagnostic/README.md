# mlDiagnostic by ML HealthCare

mlDiagnostic is an innovative iOS application developed by ML HealthCare, designed to harness the power of machine learning in healthcare diagnostics. Utilizing Bluetooth connectivity, the app interacts with a typenometer to gather data from the human ear, analyze it, and provide insightful health diagnostics.

## Getting Started

Follow these instructions to get a copy of mlDiagnostic running on your local machine for development and testing purposes.

### Prerequisites

- Xcode (latest version recommended)
- Swift Package Manager (for dependency management)
- An iOS device or simulator capable of running the app
- Bluetooth-enabled typenometer for data gathering

### Installing and Running

1. Clone the repository
2. Open the project in Xcode.
3. Resolve any dependency issues using Swift Package Manager.
4. Before running the app, turn on the tympanometer simulation device. The power outlet is located in the middle of the device's longer side. Press Button 1 to reset it, and ensure that Light 1 is on or blinking.
5. Build and run the app on your chosen iOS device (Note that ios simulator will not work, since it does not support bluetooth or camera).A real device is required for full functionalities. 

## Features

- **Bluetooth Connectivity**: Seamlessly connects with a typenometer to gather ear health data.
- **Machine Learning Integration**: Employs a machine learning model to analyze data and provide diagnostics.
- **Data Persist Storage**: Utilizes Fluent as an ORM framework and SQLite for efficient and reliable local data storage, ensuring secure and swift data management within the app.
- **Remote Processing**: Sends data to a Python Flask backend server hosted on AWS ECR for analysis. Backend Server: https://github.com/FengyiQuan/mhealth-tymp-classifier-server
- **Local Processing**: Classifies data on-device when an internet connection is unavailable.
- **Customize Profile Image**: Integrated Camera and Photo Library support for user to add profile image

## Built With

- [SwiftUI](https://developer.apple.com/xcode/swiftui/) - For building the user interface.
- [Fluent](https://docs.vapor.codes/fluent/overview/) - ORM framework used for dealing with database operations.
- [Amazon ECR](https://aws.amazon.com/ecr/) - Docker container registry for hosting the backend server.

## Contributing
- **ML HealthCare Team**
- **Professor Richard Telford**
- **Professor Mark L. Palmeri**


## Known Issues and Troubleshooting

### Warnings from NIOCore Package

Currently, there are two known warnings related to `NIOCore` which may appear during development:

- **Hang Risk Warnings**: Occurs in `MultiThreadedEventLoopGroup.swift` within the NIOCore package. This is identified by Xcode as a potential hang risk due to thread priority inversion. The specific warning is:

  > Thread running at User-interactive quality-of-service class waiting on a lower QoS thread running at Default quality-of-service class.

#### Investigation and Workarounds
- These warnings are a result of the underlying implementation in the NIOCore package and do not directly impact the functionality of mlDiagnostic.
- After consulting Professor Richard Telford, it has been decided to leave these warnings unaddressed for now, as they do not hinder the application's performance or user experience.
