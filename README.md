# WeatherAPI

A comprehensive iOS application built with Swift that combines real-time weather information with a mini blog application. This app demonstrates modern iOS development practices including async/await, MVVM architecture, and integration with multiple REST APIs.

## Features

### Weather Information
- **Real-time Weather Data**: Fetch current weather information for any city using the OpenWeatherMap API
- **Comprehensive Weather Details**:
  - Current temperature in Celsius
  - "Feels like" temperature
  - Weather description and conditions
  - Humidity percentage
  - Wind speed (m/s)
  - Weather condition icons
- **User-friendly Interface**: Clean, intuitive UI for searching and displaying weather data
- **Error Handling**: Robust error management with user-friendly error messages

### Mini Blog Application
- **Blog Post Management**: Browse, create, update, and delete blog posts
- **JSONPlaceholder Integration**: Uses the free JSONPlaceholder API for blog data
- **Full CRUD Operations**:
  - Fetch all posts or specific posts by ID
  - Create new blog posts
  - Update existing posts (PUT and PATCH methods)
  - Delete posts

### Authentication & User Management
- **DummyJSON Authentication**: Secure login system using DummyJSON API
- **Session Management**: Persistent session storage with access and refresh tokens
- **User Profiles**: Display user information including name, email, and profile image
- **Logout Functionality**: Secure logout and session clearing


## Tech Stack

### Architecture & Patterns
- **MVVM (Model-View-ViewModel)**: Clean separation of concerns
- **Protocol-Oriented Design**: Extensible and testable code
- **Async/Await**: Modern Swift concurrency for network operations

### Networking
- **URLSession**: Native iOS networking framework
- **RESTful APIs**:
  - [OpenWeatherMap API](https://openweathermap.org/api) - Weather data
  - [JSONPlaceholder](https://jsonplaceholder.typicode.com) - Blog posts, comments, and users
  - [DummyJSON](https://dummyjson.com) - Authentication

### Key Technologies
- **Swift 5.9+**
- **UIKit**: Native iOS UI framework
- **Foundation**: Core Swift libraries
- **Codable**: JSON encoding/decoding
### Screenshot capture
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-04-24 at 10 05 10" src="https://github.com/user-attachments/assets/2f9c083d-b2bd-49b1-8e0b-c3a52cca1ecb" />
