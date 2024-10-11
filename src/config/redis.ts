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
