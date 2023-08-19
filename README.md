# Advertisement Website Backend (Ruby on Rails)

Welcome to the backend repository for our Advertisement Website. Built using Ruby on Rails, this platform offers the capability to create user accounts, manage advertisements, and chat in real-time.

## Features

1. **User Authentication**:
   - Register an account.
   - Add an optional profile picture during registration, leveraging Active Storage and S3 amazon bucket.
   
2. **Advertisements**:
   - Users can create their own advertisements.
   - Browse available advertisements by:
     - Location
     - Category

3. **Real-time 1:1 Chat**:
   - Leveraging Action Cable and Redis, the platform supports real-time one-on-one chatting between users.

## Technical Stack

- **Framework**: Ruby on Rails
- **Database**: PostgreSQL
- **File Storage**: Active Storage (for profile pictures and other attachments)
- **Real-time Communication**: Action Cable and Redis

## Setup & Installation

### Prerequisites

Ensure you have the following installed:

- Ruby
- PostgreSQL
- Redis

### Steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/IrynaBk/advertisement-site-api.git

