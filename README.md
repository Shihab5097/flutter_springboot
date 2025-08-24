Flutter + Spring Boot — University Management System

Full-stack UMS with a Flutter frontend and Spring Boot (MySQL) backend.

Quick links: Frontend
 · Backend

Tech stack: Flutter (Dart), Spring Boot, Spring Data JPA, Maven, MySQL

Features: Student/Course/Department/Semester, course assignment (students many-to-one, teacher one-to-one), attendance with %, result processing (CT, Lab, Attendance mark, Final, Total)

Run (Frontend): cd frontend(flutter) ? flutter pub get ? flutter run (set API base URL in app config)

Run (Backend): cd backend(spring boot) ? set DB in src/main/resources/application.properties ? mvn spring-boot:run (API at http://localhost:8080
)
