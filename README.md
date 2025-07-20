# A MOBILE-BASED ELECTION PLATFORM FOR PHILIPPINES ASSOCIATION OF PRACTITIONERS OF STUDENT AFFAIRS AND SERVICES, INC.
<div align="center">

A secure, modern voting platform for the Philippine Association of Practitioners of Student Affairs and Services (PAPSAS), Inc.

</div>

## 📋 About

The **PAPSAS Voting Mobile Application** is a Flutter-based mobile solution designed specifically for the Philippine Association of Practitioners of Student Affairs and Services (PAPSAS), Inc. This nonprofit organization is dedicated to advancing excellence in student affairs and services throughout the Philippines.

### 🎯 Purpose

This application modernizes PAPSAS's election process by replacing traditional Google Forms with a secure, centralized, and user-friendly voting platform for both regional and national elections.

**Key Objectives:**
- Ensure secure member authentication and election integrity
- Prevent multiple voting through robust role-based access control
- Provide real-time vote tracking and comprehensive election results
- Enhance accessibility for all PAPSAS members, including those in remote regions

## ✨ Features

### 🔐 Security & Authentication
- **Secure Login System**: Firebase Authentication ensures only verified members can access the platform
- **Role-Based Access Control**: Prevents duplicate voting and unauthorized access
- **Data Protection**: Cloud Firestore provides secure, scalable data storage

### 🗳️ Voting Experience
- **Intuitive Interface**: Clean, branded design optimized for users of all technical levels
- **Real-Time Results**: Live election tracking with instant result updates
- **Historical Data**: Access to previous election results and voting patterns
- **Offline Capability**: Vote even with limited connectivity (syncs when connection is restored)

### 📱 Cross-Platform Support
- **iOS Compatibility**: Supports iOS 12 and above
- **Android Support**: Compatible with Android 12 and higher
- **Responsive Design**: Optimized for various screen sizes and orientations

## 🛠️ Technology Stack

| Component | Technology |
|-----------|------------|
| **Framework** | Flutter SDK 3.x |
| **Language** | Dart |
| **Authentication** | Firebase Authentication |
| **Database** | Cloud Firestore |
| **State Management** | Provider Package |
| **Connectivity** | Connectivity Plus |
| **Testing** | Manual UAT + Unit Tests |

## 🚀 Installation

### Prerequisites
- Flutter SDK 3.x or higher
- Android Studio / VS Code
- iOS Simulator (for iOS testing) or Android Emulator
- Firebase account and project setup

### Setup Steps

1. **Navigate to Project Directory and Initialize Git**
   ```bash
   cd "C:\Users\HP\dev\FINAL PROJECT\flutter_application_1"
    git init
    git add .
    git commit -m "Initial commit - Flutter app"
    git branch -M main
    git remote add origin https://github.com/JohnPaulCalusor/PAPSAS.git
    git push -u origin main

2. **Install Dependencies**
   ```bash
   flutter pub get

3. **Firebase Configuration**
    Add your google-services.json (Android) and GoogleService-Info.plist (iOS)
    Configure Firebase Authentication and Firestore rules

4. **Run the Application**
   ```bash
   flutter run

### System Requirements
- **iOS**: Version 12.0 or higher
- **Android**: API level 32 (Android 12) or higher
- **RAM**: Minimum 2GB recommended
- **Storage**: 100MB free space

### 🔄 Development Methodology
This project follows **Agile development principles**:

- **Sprint-Based Development**: Features delivered in 2-week iterations
- **Continuous Integration**: Regular testing and integration cycles
- **Stakeholder Collaboration**: Weekly reviews with PAPSAS representatives
- **Iterative Improvement**: User feedback incorporated in each sprint

### 📱 Preview

| Screen | Description |
|--------|-------------|
| **Home** | Main navigation and dashboard |
| **Members** | PAPSAS membership directory |
| **Voting** | Secure voting interface |
| **Results** | Real-time and historical election data |
| **Profile** | User account management |

### 🧪 Testing
**User Acceptance Testing (UAT)**
- **Environment**: iOS and Android devices
- **Minimum OS**: Android 12+, iOS 12+
- **Version Tested**: 1.0.0+1
- **Testing Method**: Manual user testing with real PAPSAS members
- **Test Coverage**: Authentication, voting flow, result viewing, and profile management

### 🤝 Development Team
| Name | SR Code | Role |
|------|------------|--------|
| Calusor,John Paul D. | 22-08449 | Assistant Developer |
| Pasia, John Cedric M. | 22-08064 | Documentation Head |
| Zoleta, Stephen M. | 22-04181 | Lead Developer |

**Academic Supervision**
- **Mr. Jhon Glenn L. Manalo** - Project Instructor
- **Mr. Edbert Ocampo** - Project Instructor
