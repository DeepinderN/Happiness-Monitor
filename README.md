# Happiness Monitoring System

An integrated iOS + Django system to monitor and log daily happiness levels based on user activities. This project combines a modern SwiftUI frontend with a scalable Django REST backend, all deployable via Docker Compose.

## Features

### iOS App (SwiftUI)

* Submit happiness scores for daily activities
* Smooth UI with slider-based input and animation
* Periodic prompt system (simulated push notifications)
* Live refresh of recent surveys
* Custom UI: smiley background, styled buttons, rounded cards

### Django Backend (Dockerized)

* RESTful API with Django REST Framework
* PostgreSQL database integration
* Lightweight models and serializers for survey data
* Supports: submit survey, fetch recent surveys, subscription status

## Tech Stack

| Layer     | Technology                        |
| --------- | --------------------------------- |
| Frontend  | SwiftUI (iOS 17.2 Simulator)      |
| Backend   | Django 4.x, Django REST Framework |
| Database  | PostgreSQL                        |
| Container | Docker, Docker Compose            |

## Architecture

```
User (iOS) ⇄ APIManager.swift ⇄ Django REST API ⇄ PostgreSQL DB
```

* `SurveyView.swift`: Input form to take survey
* `HomeView.swift`: View for survey history and subscription toggle
* `SurveyStore.swift`: ViewModel with API hooks
* `APIManager.swift`: Network abstraction
* `Dockerfile`, `docker-compose.yml`: Backend container setup

## Setup Instructions

### 1. Backend (Django + PostgreSQL)

```bash
docker compose up --build
docker compose run web python happiness/manage.py migrate
```

### 2. iOS App

1. Open `HappinessMonitor.xcodeproj` in Xcode
2. Select "iPhone 15 Pro – iOS 17.2"
3. Run the app

> All features work out of the box: submit survey, receive prompts, view survey list.

## UI Highlights

* **Survey Prompt Alert** every 20 seconds (simulated timer)
* **Real-time dashboard** of recent activities
* **Validation & feedback** on every survey submission
* **Consistent styling** with custom font, spacing, and visuals

## Contributing

Pull requests are welcome! For major updates, please open an issue to discuss the changes first.

## License

This project is open source and available under the MIT License.

## Author

Created by [DeepinderN](https://github.com/DeepinderN)
