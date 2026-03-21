# 🚀 TaskFlow Pro – Full-Stack Task Management System

A complete **Task Management System** built as part of a software engineering assessment.
This project demonstrates both:

✔ **Track A: Full-Stack Web Application **
✔ **Track B: Mobile Application **

Both applications share a **secure Node.js + TypeScript backend API** with JWT authentication and full CRUD functionality.

---


## 🧠 Project Overview

TaskFlow Pro allows users to:

* Register & login securely
* Manage personal tasks
* Perform full CRUD operations
* Filter, search, and paginate tasks
* Access the system via **Web and Mobile platforms**

---

## 🏗️ Monorepo Structure

```
taskflow-pro/
│
├── backend/           # Node.js + TypeScript API
├── web/               # Next.js frontend (Track A)
├── mobile/            # Flutter app (Track B)
│
├── docs/              # Architecture / API docs (optional)
└── README.md
```

---

# ⚙️ Tech Stack

## 🔹 Backend

* Node.js + TypeScript
* Express.js / Next API Routes
* Prisma ORM
* SQLite / PostgreSQL
* JWT Authentication (Access + Refresh Tokens)
* bcrypt (password hashing)

---

## 🔹 Web (Track A)

* Next.js (App Router)
* React 19
* TypeScript
* Tailwind CSS
* Axios
* Sonner (toasts)

---

## 🔹 Mobile (Track B)

* Flutter
* Provider (State Management)
* Go Router (Navigation)
* flutter_secure_storage
* HTTP package

---

# 🔐 Authentication System

* JWT-based authentication
* Access Token (short-lived)
* Refresh Token (long-lived)
* Token rotation for security
* Protected routes for tasks

---

# 📡 API Endpoints

## Auth

* POST `/auth/register`
* POST `/auth/login`
* POST `/auth/refresh`
* POST `/auth/logout`

## Tasks

* GET `/tasks` (pagination + filter + search)
* POST `/tasks`
* GET `/tasks/:id`
* PATCH `/tasks/:id`
* DELETE `/tasks/:id`
* POST `/tasks/:id/toggle`

---

# 🧩 Features

## ✅ Core Features

* User Authentication (JWT)
* Task CRUD Operations
* Task Filtering & Search
* Pagination Support
* Secure API

---

## 🌐 Web Features

* Responsive UI (mobile + desktop)
* Toast notifications
* Real-time UI updates

---

## 📱 Mobile Features

* Clean UI with animations
* Light/Dark mode
* Pull-to-refresh
* Secure token storage

---

# 🛠️ Local Setup

## 1️⃣ Clone Repository

```bash
git clone https://github.com/pandashreyan/Asses-emt.git
cd taskflow-pro
```

---

## 2️⃣ Backend Setup

```bash
cd backend
npm install
```

Create `.env`:

```
DATABASE_URL=
JWT_SECRET=
JWT_REFRESH_SECRET=
```

Run:

```bash
npx prisma generate
npx prisma migrate dev
npm run dev
```

---

## 3️⃣ Web Setup (Next.js)

```bash
cd web
npm install
npm run dev
```

---

## 4️⃣ Mobile Setup (Flutter)

```bash
cd mobile
flutter pub get
flutter run
```

---

# 📦 Build Mobile APK

```bash
flutter build apk --release
```

Output:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

# 🧱 Database Schema

## User

* id
* email
* password
* createdAt

## Task

* id
* title
* description
* status
* priority
* dueDate
* userId

## RefreshToken

* id
* token
* userId
* expiresAt

---

# 🚀 Deployment

## Backend

* Render / Railway

## Web

* Vercel

## Mobile

* APK via Google Drive / Firebase

---

# 🧪 Test Credentials

```
Email: test@gmail.com
Password: 123456
```

---

# 📸 Screenshots

*(Add screenshots here for both Web & Mobile)*

---

# 👨‍💻 Author

**Shreyan Panda**

* GitHub: https://github.com/pandashreyan

---

# 📌 Submission Notes

This project fulfills:

✔ Backend API Requirements (Node.js + TypeScript + ORM)
✔ Track A (Web – Next.js)
✔ Track B (Mobile – Flutter)

---

# ❤️ Final Note

This project demonstrates:

* Full-stack development
* Mobile app development
* Secure authentication systems
* Clean architecture & scalability

---

⭐ If you like this project, consider giving it a star!
