npm init -y
npm i -D typescript
npm i -D ts-node
npm i -D nodemon
npm i dotenv express compression redis-om redis jsonwebtoken crypto-js mongoose bcrypt
npm i --save -dev @types/express @types/compression @types/redis @types/mongoose @types/bcrypt @types/jsonwebtoken

echoo '🎉 Packages setup complete!'

touch tsconfig.json
cat <<EOL > tsconfig.json 
{
  "compilerOptions": {
    "target": "es2016",
    "module": "commonjs",
    "rootDir": "./src",
    "outDir": "./dist",
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,  
    "strict": true,
    "skipLibCheck": true
  },
  "include": ["src/**/*", "server.ts"],
  "exclude": ["node_modules", "dist"]
}
EOL

touch nodemon.json

mkdir src
mkdir src/config 
mkdir src/controllers
mkdir src/repositories
mkdir src/models
mkdir src/services
mkdir src/utils

# Create model, repository, controller, and service files
touch src/models/userModel.ts
touch src/repositories/userRepository.ts
touch src/controllers/userController.ts
touch src/services/userService.ts

echo '🎉 Folder structure setup complete!'

touch src/index.ts

cat <<EOL > nodemon.json
{
    "watch": [
        "src"
    ],
    "ext": ".ts,.js",
    "exec": "ts-node ./src/index.ts"
}
EOL
echo '🎉 Nodemon setup complete!';

cat <<EOL > src/index.ts
// Import the required modules
import express, { Request, Response } from 'express';
import { connectRedis } from './config/redis'; // No changes needed if config is in src
import { connectMongoDB } from './config/mongodb'
import dotenv from 'dotenv';

// Load environment variables from .env file
dotenv.config();

// Create an Express application
const app = express();

// Specify the port number for the server
const port: number = Number(process.env.PORT) || 3000;


// Define a route for the root path ('/')
app.get('/', (req: Request, res: Response) => {
    // Send a response to the client
    res.send('Hello, TypeScript + Node.js + Express!');
  });

// Connect to Redis and MongoDB
const startServer = async () => {
  try {
    // await connectRedis(); // Connect to Redis
   // await connectMongoDB(); // Connect to MongoDB

    // Start the server and listen on the specified port
    app.listen(port, () => {
      console.log("❤️‍🔥 SERVER SPINNING ON PORT " + port);
    });
  } catch (error) {
    console.error('😤 ERROR STARTING THE SERVER:', error);
  }
};

// Start the server
startServer();
EOL
echo "🎉 Server setup complete"
touch .env

cat <<EOL > .env
REDIS_CONNECT_URL=
MONGO_CONNECT_URL=
PORT=
JWT_SECRET=
JWT_EXPIRATION_TIME=
JWT_REFRESH_TOKEN_SECRET=
EMAIL_HOST=
EMAIL_USERNAME=
EMAIL_PASSWORD=
EMAIL_FROM=
EOL

echo "🎉 .env setup complete"

touch src/config/redis.ts

cat <<EOL > src/config/redis.ts
import { createClient } from 'redis';

// Create a Redis client
const redis = createClient({
  url: process.env.REDIS_CONNECT_URL // Use the connection URL from the environment variable
});

// Handle connection errors
redis.on('error', (err) => {
  console.error('🚩 Redis Client Error', err);
});

// Connect to Redis
const connectRedis = async (): Promise<void> => {
  try {
    await redis.connect();
    console.log('💽 Redis connected successfully.');
  } catch (error) {
    console.error('🚩 Error connecting to Redis:', error);
    throw error; // Re-throw the error for further handling
  }
};

export { redis, connectRedis };
EOL

echo '🎉 Redis setup complete!'

# Create MongoDB configuration file and install packages
touch src/config/mongodb.ts
npm install mongoose @types/mongoose --save-dev
cat <<EOL > src/config/mongodb.ts
import mongoose from 'mongoose';

const connectMongoDB = async (): Promise<void> => {
  try {
    await mongoose.connect(process.env.MONGO_CONNECT_URL as string);
    console.log('💿 MONGODB SUCCESSFULLY CONNECTED');
  } catch (error) {
    console.error('🚩 MONGODB CONNECTION ERROR:', error);
    // Optionally, you can handle the error further or re-throw it
    throw error;
  }

  // Reconnection logic
  mongoose.connection.on('error', (any: Error) => {
    console.error('MongoDB connection error:', Error);
  });

  mongoose.connection.on('disconnected', () => {
    console.log('🚩 MongoDB disconnected. Attempting to reconnect...');
    reconnect();
  });

  mongoose.connection.on('connected', () => {
    console.log('🥰 MongoDB reconnected successfully.');
  });
};

// Function to handle reconnection attempts
const reconnect = async () => {
  let retries = 5; // Number of reconnection attempts
  while (retries) {
    try {
      await mongoose.connect(process.env.MONGO_CONNECT_URL as string);
      console.log('🥰 MongoDB reconnected successfully.');
      return; // Exit the loop if the connection is successful
    } catch (error) {
      console.error('🚩 MongoDB reconnection error:', error);
      retries -= 1; // Decrease the number of retries
      console.log();
      await new Promise((resolve) => setTimeout(resolve, 5000)); // Wait for 5 seconds before retrying
    }
  }
  console.error('🚩 Could not reconnect to MongoDB. Please check the connection settings.');
};

export { connectMongoDB };
EOL

echo '🎉 Mongodb setup complete!'

touch README.MD

cat <<EOL > README.MD
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
EOL


echo "Project structure created successfully and package installed successfully"