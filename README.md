# Secure Memo API

This is a backend API for a secure memo-taking application, built with Node.js, Express, and MongoDB. It features a robust startup process, JWT-based user authentication, and protected routes for managing user-specific memos.

## 📱 Frontend

This backend API was built to power a corresponding mobile application developed in **Flutter**. The frontend application connects to these endpoints and features a rich, **animated user interface** for a smooth user experience.

## ✨ Features

* **User Authentication:** Secure user registration (`/create`) and login (`/login`).
* **Password Hashing:** All user passwords are securely hashed using `bcrypt`.
* **JWT-Based Auth:** Protected routes use `jsonwebtoken` (JWT) to ensure only authenticated users can access their data.
* **Request Validation:** Uses `joi` to validate incoming request bodies for all major endpoints.
* **Memo Management:**
    * Add new memos (timestamped) to a user's account.
    * Delete specific memos by their index.
    * A secure "signout" feature that clears all user memos after password verification.
* **Environment-Aware:** Includes checks for essential environment variables (like `JWT_PRIVATE_KEY`) to prevent runtime errors.

## 🛠️ Technology Stack

* **Backend:** Node.js, Express.js
* **Database:** MongoDB (using Mongoose)
* **Authentication:** `jsonwebtoken`, `bcrypt`
* **Validation:** `joi`
* **Utilities:** `lodash`, `dotenv`
* **Middleware:** `cors`

## 🚀 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine.

### Prerequisites

You must have [Node.js](https://nodejs.org/) and [MongoDB](https://www.mongodb.com/) installed and running on your system.

### Installation

1.  **Clone the repository:**
    ```sh
    git clone [https://github.com/your-username/your-repo-name.git](https://github.com/your-username/your-repo-name.git)
    cd your-repo-name
    ```

2.  **Install NPM packages:**
    ```sh
    npm install
    ```

3.  **Set up environment variables:**
    Create a `.env` file in the root of your project. The server will not start without the `JWT_PRIVATE_KEY`.

    ```env
    # Your MongoDB connection string
    MONGO_URI=mongodb://localhost:27017/secure-memo-app

    # A strong, secret key for signing JWTs
    JWT_PRIVATE_KEY=your_very_strong_and_secret_key

    # The port your server will run on (optional, defaults to 3000)
    PORT=3000
    ```

4.  **Run the server:**
    ```sh
    npm start
    ```
    Your API will now be running on `http://localhost:3000`.

## 📖 API Endpoints

All user-related endpoints are prefixed with `/api/users`.

### 👤 Authentication

#### `POST /api/users/create`

Registers a new user.

* **Body:**
    ```json
    {
      "firstName": "John",
      "lastName": "Doe",
      "email": "john.doe@example.com",
      "password": "your-strong-password"
    }
    ```
* **Success Response:** Returns a `200 OK` with the `x-auth-token` in the header.

#### `POST /api/users/login`

Logs in an existing user.

* **Body:**
    ```json
    {
      "email": "john.doe@example.com",
      "password": "your-strong-password"
    }
    ```
* **Success Response:** Returns a `200 OK` with the user's details, their memos, and the `token`.
    ```json
    {
      "message": "User logged in successfully",
      "token": "...",
      "email": "john.doe@example.com",
      "memos": []
    }
    ```

---

### 📝 Memo Management

All routes below are **protected** and require a valid `x-auth-token` to be sent in the request header.

#### `POST /api/users/addmemo`

Adds a new memo to the user's account.

* **Header:**
    * `x-auth-token`: `your-jwt-token`
* **Body:**
    ```json
    {
      "content": "This is my first memo."
    }
    ```
* **Success Response:** Returns a `200 OK` with the updated list of memos.

#### `POST /api/users/deletememo`

Deletes a memo from the user's account by its array index.

* **Header:**
    * `x-auth-token`: `your-jwt-token`
* **Body:**
    ```json
    {
      "index": 0
    }
    ```
* **Success Response:** Returns a `200 OK` with the updated list of memos.

#### `POST /api/users/signout`

A secure action that clears all memos from the user's account after re-verifying their password. **This is not a traditional logout.**

* **Header:**
    * `x-auth-token`: `your-jwt-token`
* **Body:**
    ```json
    {
      "password": "your-strong-password"
    }
    ```
* **Success Response:** Returns a `200 OK` with a success message.
    ```json
    {
      "message": "Signed out successfully"
    }
    ```
