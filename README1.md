# Media Compressor Web Application

A full-stack web application for compressing and converting media files including images, videos, and audio. Built with Node.js, Express, and modern web technologies.

## 📋 Table of Contents
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Running the Application](#running-the-application)
- [Usage Guide](#usage-guide)
- [API Endpoints](#api-endpoints)
- [Authentication](#authentication)
- [User Roles](#user-roles)
- [Troubleshooting](#troubleshooting)

---

## ✨ Features

### Core Features
- 🖼️ **Image Compression** - Optimize PNG, JPEG, WebP with quality control
- 🎬 **Video Conversion** - Convert between MP4, AVI, MOV formats
- 🎵 **Audio Processing** - Compress MP3, WAV, AAC files
- 📄 **PDF Operations** - Create, merge, and compress PDFs
- 📊 **Batch Processing** - Handle multiple files simultaneously

### User Features
- 👤 **User Authentication** - Secure signup/login with JWT
- 🔐 **Google OAuth** - Sign in with Google account
- 📈 **Usage Dashboard** - Track compression history and statistics
- 💾 **File History** - View and download past conversions
- ⚙️ **User Settings** - Manage profile and preferences

### Admin Features
- 🔧 **Admin Panel** - User management dashboard
- 📊 **System Metrics** - Monitor application performance
- 👥 **User Management** - View, edit, and manage users
- 🚦 **Access Control** - Role-based permissions

### Pricing Tiers
- **Free**: 10 conversions/month, 100MB storage
- **Pro**: 100 conversions/month, 1GB storage
- **Enterprise**: Unlimited conversions, 10GB storage

---

## 🛠️ Technology Stack

### Backend
- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB (via Mongoose)
- **Authentication**: Passport.js (Local + Google OAuth)
- **File Upload**: Multer
- **Image Processing**: Sharp
- **PDF Processing**: pdf-lib
- **Security**: bcryptjs, jsonwebtoken
- **Real-time**: Socket.io
- **Monitoring**: prom-client (Prometheus metrics)

### Frontend
- **UI Framework**: Vanilla JavaScript
- **Styling**: CSS3
- **HTTP Client**: Fetch API
- **Real-time**: Socket.io Client

### Development
- **Process Manager**: nodemon
- **Logging**: morgan
- **CORS**: cors middleware

---

## 📁 Project Structure

```
Compressorr/
├── backend/
│   ├── src/
│   │   ├── server.js              # Main application entry point
│   │   ├── metrics.js             # Prometheus metrics configuration
│   │   ├── config/
│   │   │   └── passport.js        # Passport authentication config
│   │   ├── controllers/
│   │   │   └── fileController.js  # File processing logic
│   │   ├── middleware/
│   │   │   └── auth.js            # Authentication middleware
│   │   ├── models/
│   │   │   └── User.js            # User model schema
│   │   ├── routes/
│   │   │   ├── api.js             # API routes
│   │   │   ├── auth.js            # Authentication routes
│   │   │   └── admin.js           # Admin routes
│   │   └── services/
│   │       └── conversionService.js # File conversion service
│   ├── scripts/
│   │   └── create-admin.js        # Script to create admin user
│   ├── package.json               # Backend dependencies
│   └── Dockerfile                 # Backend container image
│
├── frontend/
│   ├── index.html                 # Landing page
│   ├── login.html                 # Login page
│   ├── signup.html                # Registration page
│   ├── dashboard.html             # User dashboard
│   ├── converter.html             # File converter interface
│   ├── history.html               # Conversion history
│   ├── profile.html               # User profile
│   ├── settings.html              # User settings
│   ├── admin.html                 # Admin panel
│   ├── pricing.html               # Pricing page
│   ├── styles.css                 # Global styles
│   ├── app.js                     # Main application logic
│   ├── auth.js                    # Authentication logic
│   ├── common.js                  # Shared utilities
│   ├── dashboard.js               # Dashboard logic
│   ├── converter.js               # Converter logic
│   ├── history.js                 # History page logic
│   ├── profile.js                 # Profile page logic
│   ├── settings.js                # Settings page logic
│   ├── admin.js                   # Admin panel logic
│   ├── pricing.js                 # Pricing page logic
│   ├── nginx.conf                 # Nginx configuration
│   └── Dockerfile                 # Frontend container image
│
├── uploads/                       # File upload directory
└── README.md                      # This file
```

---

## ✅ Prerequisites

Before running the application, ensure you have:

- **Node.js** (v14 or higher) - [Download](https://nodejs.org/)
- **MongoDB** (v4 or higher) - [Download](https://www.mongodb.com/try/download/community)
- **npm** or **yarn** - Package manager (comes with Node.js)
- **Git** - [Download](https://git-scm.com/)

---

## 📦 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/SaikiranAsamwar/Media-Compressor-Devops.git
cd Media-Compressor-Devops
```

### 2. Install Backend Dependencies

```bash
cd backend
npm install
```

### 3. Frontend Setup

The frontend uses vanilla JavaScript and doesn't require a build step. Files can be served directly or via a static file server.

---

## ⚙️ Configuration

### Environment Variables

Create a `.env` file in the `backend` directory with the following variables:

```env
# Server Configuration
PORT=3000
NODE_ENV=development

# MongoDB Configuration
MONGODB_URI=mongodb://localhost:27017/media-compressor

# Session Secret
SESSION_SECRET=your-session-secret-key-here

# JWT Configuration
JWT_SECRET=your-jwt-secret-key-here
JWT_EXPIRE=7d

# Google OAuth (Optional)
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
GOOGLE_CALLBACK_URL=http://localhost:3000/auth/google/callback

# File Upload Configuration
MAX_FILE_SIZE=52428800  # 50MB in bytes
UPLOAD_DIR=../uploads

# CORS Configuration
CORS_ORIGIN=http://localhost:3000,http://127.0.0.1:3000
```

### MongoDB Setup

#### Option 1: Local MongoDB

Start your local MongoDB service:

```bash
# Windows
net start MongoDB

# macOS/Linux
sudo systemctl start mongod
```

#### Option 2: MongoDB Atlas (Cloud)

1. Create an account at [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Create a cluster
3. Get your connection string
4. Update `MONGODB_URI` in `.env` file

---

## 🚀 Running the Application

### Development Mode (with auto-reload)

```bash
cd backend
npm run dev
```

### Production Mode

```bash
cd backend
npm start
```

### Access the Application

- **Backend API**: `http://localhost:3000`
- **Frontend**: Serve the `frontend` folder with a static file server

#### Serving Frontend with http-server

```bash
# Install http-server globally (one-time)
npm install -g http-server

# Navigate to frontend directory
cd frontend

# Start the server
http-server -p 8080

# Access at: http://localhost:8080
```

#### Serving Frontend with Python

```bash
# Navigate to frontend directory
cd frontend

# Python 3
python -m http.server 8080

# Access at: http://localhost:8080
```

---

## 📖 Usage Guide

### For Regular Users

1. **Sign Up**: Navigate to `/signup.html` and create an account
2. **Login**: Sign in at `/login.html` with your credentials
3. **Dashboard**: View your usage statistics and recent conversions
4. **Compress Files**: Go to `/converter.html` to upload and compress media files
5. **View History**: Check your conversion history at `/history.html`
6. **Manage Profile**: Update your information at `/profile.html`
7. **Settings**: Configure preferences at `/settings.html`

### For Administrators

1. **Create Admin User**:
   ```bash
   cd backend
   npm run create-admin
   # Follow the prompts to set admin credentials
   ```

2. **Access Admin Panel**: Navigate to `/admin.html`

3. **Admin Capabilities**:
   - View all registered users
   - Edit user details and roles
   - Change user subscription tiers
   - Monitor system metrics
   - View conversion statistics

---

## 🔌 API Endpoints

### Authentication Routes

```
POST   /auth/register              # Register new user
POST   /auth/login                 # Login user
GET    /auth/logout                # Logout user
GET    /auth/me                    # Get current user info
POST   /auth/refresh               # Refresh JWT token
GET    /auth/google                # Google OAuth login
GET    /auth/google/callback       # Google OAuth callback
```

### File Operations

```
POST   /api/convert/image          # Convert/compress image
POST   /api/convert/video          # Convert video
POST   /api/convert/audio          # Convert audio
POST   /api/convert/pdf            # Create/compress PDF
GET    /api/files                  # Get user's files
GET    /api/files/:id              # Get specific file
DELETE /api/files/:id              # Delete file
GET    /api/download/:id           # Download converted file
```

### User Routes

```
GET    /api/user/profile           # Get user profile
PUT    /api/user/profile           # Update profile
GET    /api/user/stats             # Get usage statistics
GET    /api/user/history           # Get conversion history
PUT    /api/user/settings          # Update settings
```

### Admin Routes (Protected)

```
GET    /api/admin/users            # List all users
GET    /api/admin/users/:id        # Get user details
PUT    /api/admin/users/:id        # Update user
DELETE /api/admin/users/:id        # Delete user
GET    /api/admin/stats            # System statistics
GET    /api/admin/metrics          # Prometheus metrics
```

---

## 🔐 Authentication

### Local Authentication

- Uses Passport Local Strategy
- Passwords are hashed with bcryptjs
- JWT tokens for session management
- Token expiry: 7 days (configurable)

### Google OAuth Setup

1. **Create Google OAuth Credentials**:
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project
   - Enable Google+ API
   - Create OAuth 2.0 credentials
   - Add authorized redirect URI: `http://localhost:3000/auth/google/callback`

2. **Update Environment Variables**:
   ```env
   GOOGLE_CLIENT_ID=your-client-id-here
   GOOGLE_CLIENT_SECRET=your-client-secret-here
   ```

3. **Test OAuth Flow**:
   - Navigate to login page
   - Click "Sign in with Google"
   - Authorize the application

---

## 👥 User Roles

### Regular User (Default)
- Upload and convert files
- View personal conversion history
- Limited monthly conversions and storage
- Access to pricing/upgrade options

### Admin
- All regular user permissions
- Access to admin panel
- Manage all users (view, edit, delete)
- View system-wide metrics
- No conversion or storage limits

---

## 🐛 Troubleshooting

### MongoDB Connection Issues

**Problem**: `MongoNetworkError: connect ECONNREFUSED`

**Solutions**:
```bash
# Check if MongoDB is running
# Windows
sc query MongoDB

# macOS/Linux
sudo systemctl status mongod

# Start MongoDB if not running
# Windows
net start MongoDB

# macOS/Linux
sudo systemctl start mongod
```

### Port Already in Use

**Problem**: `Error: listen EADDRINUSE: address already in use :::3000`

**Solutions**:
```powershell
# Windows PowerShell - Find process using port 3000
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Or change PORT in .env file
PORT=3001
```

### File Upload Failures

**Problem**: Files not uploading or processing

**Solutions**:
1. Verify `uploads/` directory exists with write permissions
2. Check `MAX_FILE_SIZE` configuration in `.env`
3. Ensure file type is supported
4. Review backend logs for specific error messages

### Google OAuth Not Working

**Problem**: OAuth redirect fails or shows errors

**Solutions**:
1. Verify `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` in `.env`
2. Check authorized redirect URIs in Google Console
3. Ensure cookies are enabled in browser
4. Verify CORS settings in backend

### Session Expires Too Quickly

**Problem**: Users getting logged out frequently

**Solution**: Adjust session configuration in `backend/src/server.js`:
```javascript
app.use(session({
  secret: process.env.SESSION_SECRET || 'session-secret-key',
  resave: false,
  saveUninitialized: true,
  cookie: { 
    maxAge: 30 * 24 * 60 * 60 * 1000, // 30 days instead of 7
    httpOnly: true,
    sameSite: 'lax'
  }
}));
```

---

## 🐳 Docker Deployment (Optional)

### Build Docker Images

```bash
# Build backend image
cd backend
docker build -t media-compressor-backend .

# Build frontend image
cd ../frontend
docker build -t media-compressor-frontend .
```

### Run with Docker Compose

Create a `docker-compose.yml` in the project root:

```yaml
version: '3.8'

services:
  mongodb:
    image: mongo:4
    ports:
      - "27017:27017"
    volumes:
      - mongo-data:/data/db

  backend:
    build: ./backend
    ports:
      - "3000:3000"
    environment:
      - MONGODB_URI=mongodb://mongodb:27017/media-compressor
      - PORT=3000
    depends_on:
      - mongodb
    volumes:
      - ./uploads:/app/uploads

  frontend:
    build: ./frontend
    ports:
      - "8080:80"
    depends_on:
      - backend

volumes:
  mongo-data:
```

Run with:
```bash
docker-compose up
```

---

## 📝 Development Tips

### Creating an Admin User

```bash
cd backend
npm run create-admin

# Follow the prompts:
# Email: admin@example.com
# Password: YourSecurePassword
# Name: Admin User
```

### Testing the API

```bash
# Test health endpoint
curl http://localhost:3000/health

# Test login
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123"}'
```

### Monitoring Logs

```bash
# Backend logs (development mode)
cd backend
npm run dev

# View application logs
tail -f backend/logs/app.log  # if logging to file
```

---

## 📄 License

This project is licensed under the MIT License.

---

## 👤 Author

**Saikiran Asamwar**
- GitHub: [@SaikiranAsamwar](https://github.com/SaikiranAsamwar)
- Repository: [Media-Compressor-Devops](https://github.com/SaikiranAsamwar/Media-Compressor-Devops)

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## ⭐ Support

Give a ⭐️ if this project helped you!

---

**Last Updated**: December 5, 2025  
**Version**: 2.0.0
