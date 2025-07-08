import express from "express"
import { login, register, getProfile } from "../controllers/auth.controller.js"
import { protect } from "../middleware/auth.middleware.js"

const router = express.Router()

router.post("/login", login)
router.post("/register", register)
router.get("/profile", protect, getProfile)

export default router
