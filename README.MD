/app-folder-struct
│
├── src/config           # MongoDB configuration files for Redis and environment variables
│   └── redis.ts
│   └── mongodb.ts   
├──  src/models           # Schema definitions for Redis and MongoDb entities
│   └── userModel.ts
│
├──  src/repositories     # Repositories to handle Redis data interactions
│   └── userRepository.ts
│
├──  src/controllers      # Application logic to handle business operations
│   └── userController.ts
│
├──  src/routes           # API route definitions
│   └── userRoutes.ts
│
├──  src/services         # Additional business logic or service layers
│   └── userService.ts
│
├── /server.ts        # Main application entry point (Express setup)
├── /.env             # Store secret codes        
├── /package.json     # Node.js project dependencies and metadata
└── /README.md        # Documentation about the project
