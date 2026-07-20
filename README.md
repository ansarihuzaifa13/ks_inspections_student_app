# Kx Inspections Student App

A Flutter application developed as part of the **Kx Inspections Student Charge Contestation Take-Home Assessment**.

The application enables students to review maintenance information, inspect raised charges, accept or contest charges, and view booking, inspection, inventory, and maintenance task details.

---

## Features

### Maintenance Hub
- View current booking details
- Inventory overview
- Inspection history
- Open maintenance tasks
- Outstanding maintenance charges

### Charge Management
- View detailed charge information
- View evidence photos
- Accept a charge
- Contest a charge with a reason
- Local persistence of charge status

### Contest Charge
- Submit contest reason
- Validation before submission
- Updated status reflected throughout the application

### Local Persistence
Charge acceptance and contest status are stored locally using **SharedPreferences**.

---

## Architecture

The project follows a simplified **Clean Architecture** with feature-based organization.

```
lib/
│
├── app/
│   ├── router.dart
│   ├── app.dart
│   └── theme.dart
│
├── core/
│   └── utils/
│
├── data/
│   └── maintenance_repository.dart
│
├── domain/
│   └── models.dart
│
├── features/
│   ├── maintenance/
│   ├── inspection/
│   ├── charge/
│   └── contest/
│
└── main.dart
```

---

## State Management

The application uses

- flutter_bloc
- BLoC Pattern

State transitions:

```
Loading
      ↓
Loaded
      ↓
Accept Charge
      ↓
Reload Data

OR

Loading
      ↓
Loaded
      ↓
Contest Charge
      ↓
Reload Data
```

---

## Technologies

- Flutter
- Dart
- flutter_bloc
- go_router
- SharedPreferences
- Hive (initialized for future persistence)
- Google Fonts

---

## Mock Data

Application data is loaded from JSON assets located in

```
assets/mock/
```

Files include:

- bookings.json
- charges.json
- inspections.json
- inventory.json
- tasks.json

---

## Running the Project

### Clone Repository

```bash
git clone <repository-url>
```

### Install dependencies

```bash
flutter pub get
```

### Run

```bash
flutter run
```

---

## Testing

Execute

```bash
flutter test
```

---

## Project Decisions

### Why flutter_bloc?

- Predictable state management
- Separation of business logic from UI
- Easy scalability
- Testable architecture

### Why Repository Pattern?

Keeps data access independent from UI and business logic.

### Why Local JSON?

The assessment specified mocked backend data, therefore all data is loaded from local JSON assets.

---

## Assumptions

- Backend APIs are mocked using JSON assets.
- Charge state changes are stored locally.
- Network layer is intentionally omitted.
- Authentication is out of scope.

---

## Future Improvements

Given more time, the following enhancements would be implemented:

- REST API integration
- Offline-first support with Hive
- Unit test coverage expansion
- Widget and integration tests
- Image caching improvements
- Pagination
- Search and filtering
- Better error handling
- Dependency Injection (get_it)
- Repository abstraction with interfaces
- CI/CD pipeline
- Dark mode support
- Localization

---

## Git Commit Strategy

Development was completed incrementally with feature-based commits covering:

- Initial project setup
- Mock data
- Routing and theme
- Maintenance feature
- Charge feature
- Contest feature
- Inspection feature
- Tests
- UI improvements
- Local persistence
- Project configuration

---

## Author

**Huzaifa Ansari**

Flutter Developer

GitHub:
https://github.com/ansarihuzaifa13

---

## Notes for Reviewer

This project was developed as a take-home assessment focusing on:

- Clean architecture
- Readable code
- Maintainability
- Feature isolation
- Scalable state management
- Production-style project structure

Thank you for reviewing my submission.
