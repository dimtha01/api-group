import {Router} from "express"
import {
  getUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
} from '../controllers/user.controller.js'
import { protect, admin } from "../middleware/auth.middleware.js"

const router = Router()

router.get("/user",protect, admin, getUsers)
router.get("/user/:id",protect, admin, getUserById)
router.post('/user',protect, admin, createUser)
router.put('/user/:id',protect, admin, updateUser)
router.delete('/user/:id',protect, admin, deleteUser)

export default router

