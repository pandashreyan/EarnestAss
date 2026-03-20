# TaskFlow Pro

A modern task management application built with **Next.js**, **React**, **TypeScript**, **Prisma**, and **Tailwind CSS**. TaskFlow Pro provides a seamless experience for managing tasks with authentication, real-time updates, and an intuitive UI.

## 🚀 Features

- **User Authentication**: Secure registration and login with JWT-based token management
- **Task Management**: Create, read, update, delete, and toggle task status
- **Task Prioritization**: Organize tasks by priority (low, medium, high) and status (pending, in-progress, completed)
- **Due Dates**: Set and track task deadlines
- **Responsive Design**: Mobile-friendly UI built with Tailwind CSS
- **Real-time Updates**: Instant task state synchronization
- **Secure API**: Protected endpoints with JWT refresh tokens
- **Google Generative AI Integration**: Enhanced task management with AI capabilities

## 📋 Tech Stack

### Frontend
- **Next.js 16** - React framework with app router
- **React 19** - UI library
- **TypeScript** - Type-safe development
- **Tailwind CSS** - Utility-first CSS framework
- **Lucide React** - Icon library
- **Motion** - Animation library
- **Sonner** - Toast notifications

### Backend
- **Next.js API Routes** - Serverless backend
- **Prisma** - ORM for database operations
- **SQLite** - Lightweight database
- **JWT** - JSON Web Tokens for authentication
- **bcryptjs** - Password hashing
- **Express** - Middleware support

### Tools & Libraries
- **Axios** - HTTP client
- **Zod** - Schema validation
- **dotenv** - Environment variable management

## 🛠️ Installation

### Prerequisites
- Node.js 18+ 
- npm or yarn

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/pandashreyan/Asses-emt.git
   cd taskflow-pro
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Setup environment variables**
   
   Create a `.env.local` file in the root directory:
   ```
   DATABASE_URL="file:./dev.db"
   JWT_SECRET="your-secret-key-here"
   JWT_REFRESH_SECRET="your-refresh-secret-here"
   JWT_EXPIRY="24h"
   JWT_REFRESH_EXPIRY="7d"
   GOOGLE_API_KEY="your-google-api-key-here"
   ```

4. **Initialize the database**
   ```bash
   npx prisma generate
   npx prisma migrate dev --name init
   ```

5. **Run the development server**
   ```bash
   npm run dev
   ```

   Open [http://localhost:3000](http://localhost:3000) in your browser.

## 📁 Project Structure

```
.
├── app/                    # Next.js app directory
│   ├── api/               # API routes
│   │   ├── auth/         # Authentication endpoints (login, register, refresh, me)
│   │   ├── health/       # Health check endpoint
│   │   └── tasks/        # Task CRUD endpoints
│   ├── login/            # Login page
│   ├── register/         # Registration page
│   ├── layout.tsx        # Root layout
│   ├── page.tsx          # Home page
│   └── globals.css       # Global styles
├── components/           # React components
│   ├── AuthContext.tsx   # Authentication context
│   └── UI.tsx           # UI components
├── lib/                 # Utility functions
│   ├── api.ts          # API client
│   ├── api-auth.ts     # Authentication API
│   ├── auth.ts         # Auth utilities
│   ├── jwt.ts          # JWT helpers
│   └── prisma.ts       # Prisma client
├── prisma/
│   └── schema.prisma   # Database schema
├── package.json        # Dependencies and scripts
├── tsconfig.json       # TypeScript config
├── next.config.ts      # Next.js config
└── server.ts           # Custom server setup
```

## 🔑 API Endpoints

### Authentication
- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login user
- `POST /api/auth/logout` - Logout user
- `GET /api/auth/me` - Get current user info
- `POST /api/auth/refresh` - Refresh JWT token

### Tasks
- `GET /api/tasks` - Get all tasks for the user
- `POST /api/tasks` - Create a new task
- `GET /api/tasks/[id]` - Get a specific task
- `PUT /api/tasks/[id]` - Update a task
- `DELETE /api/tasks/[id]` - Delete a task
- `POST /api/tasks/[id]/toggle` - Toggle task completion status

### Health
- `GET /api/health` - Health check

## 🏗️ Database Schema

### User
- `id` (UUID) - Primary key
- `email` (String, unique) - User email
- `password` (String) - Hashed password
- `createdAt` (DateTime) - Account creation date
- `updatedAt` (DateTime) - Last update date

### Task
- `id` (UUID) - Primary key
- `title` (String) - Task title
- `description` (String, optional) - Task description
- `status` (String) - pending, in-progress, or completed
- `priority` (String) - low, medium, or high
- `dueDate` (DateTime, optional) - Task deadline
- `userId` (String) - Foreign key to User
- `createdAt` (DateTime) - Task creation date
- `updatedAt` (DateTime) - Last update date

### RefreshToken
- `id` (UUID) - Primary key
- `token` (String, unique) - JWT refresh token
- `userId` (String) - Foreign key to User
- `expiresAt` (DateTime) - Token expiration date
- `createdAt` (DateTime) - Token creation date

## 📝 Scripts

```bash
# Start development server
npm run dev

# Build for production
npm run build

# Start production server
npm start

# Run linting
npm run lint
```

## 🔐 Authentication Flow

1. User registers with email and password
2. Password is hashed using bcryptjs
3. JWT access token is generated (24h expiry)
4. Refresh token is created and stored in database (7d expiry)
5. Refresh tokens are rotated on each refresh
6. Protected routes validate JWT in Authorization header

## 🎨 UI Components

The application uses custom UI components for:
- Form inputs
- Buttons
- Task cards
- Navigation
- Modals
- Toast notifications (via Sonner)
- Loading states
- Error handling

## 🚀 Deployment

### Prerequisites for deployment
- Node.js 18+ runtime environment
- SQLite database support (or switch to PostgreSQL in `schema.prisma`)
- Environment variables configured on your platform

### Vercel (Recommended)
```bash
npm install -g vercel
vercel
```

### Other Platforms
- Change database to PostgreSQL in `schema.prisma`
- Set environment variables on your platform
- Run `npm run build && npm start`

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is open source and available under the MIT License.

## 👤 Author

**Shreyan Panda**
- GitHub: [@pandashreyan](https://github.com/pandashreyan)
- Repository: [Asses-emt](https://github.com/pandashreyan/Asses-emt)

## 📧 Support

For issues, questions, or suggestions, please open an issue on the GitHub repository.

---

**Made with ❤️ by TaskFlow Pro Team**
