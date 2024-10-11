import { Request, Response } from 'express';
import { register, login } from '../services/userService';

const registerUser = async (req: Request, res: Response) => {
  try {
    const { username, password, email, role, phone, company, branch } = req.body;
    const user = await register(username, password, email, role, phone, company, branch);
    res.status(201).json(user);
  } catch (error ) {
    res.status(500).json({ error: error.message as string });
  }
};

const loginUser = async (req: Request, res: Response) => {
  try {
    const token = await login(req.body.username, req.body.password);
    res.json({ token });
  } catch (error) {
    res.status(401).json({ error: error.message });
  }
};

export { registerUser, loginUser };