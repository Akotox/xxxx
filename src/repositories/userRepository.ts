import { Repository } from 'redis-om'
import userSchema from '../models/userModel'
import {redis} from '../config/redis';

const userRepository = new Repository(userSchema, redis)

export default userRepository;