import bcrypt from 'bcrypt';
import { redis } from '../config/redis';
import { userSchema } from '../models/userModel';
import jwt from 'jsonwebtoken';
const userRepository = require('../repositories/userRepository');

// const userRepository = redis.fetchRepository(userSchema);

const register = async (username: string, password: string, email: string, role: string, phone: string, company?: string, branch?: string) => {
  const hashedPassword = await bcrypt.hash(password, 10);
  const user = userRepository.createEntity(userSchema);
  user.username = username;
  user.password = hashedPassword;
  user.email = email;
  user.role = role;
  user.phone = phone;
  user.company = company || null;
  user.branch = branch || null;

  await userRepository.save(user);
  return user;
};

const login = async (username: string, password: string) => {
  const user = await userRepository
    .search()
    .where('username')
    .equals(username)
    .return.first();

  if (!user || !(await bcrypt.compare(password, user.password))) {
    throw new Error('Invalid credentials');
  }

  const token = jwt.sign({ id: user.id, role: user.role }, process.env.JWT_SECRET as string, { expiresIn: '1h' });
  return token;
};

export { register, login };