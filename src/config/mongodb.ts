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
