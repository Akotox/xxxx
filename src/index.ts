// Import the required modules
import express, { Request, Response } from 'express';
import { connectRedis } from './config/redis'; 
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
      await connectRedis(); // Connect to Redis
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
