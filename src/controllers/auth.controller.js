import jwt from "jsonwebtoken"
import bcrypt from "bcryptjs"
import  pool  from "../db.js"
import dotenv from "dotenv"
dotenv.config()

const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN || "1d",
  })
}

export const register = async (req, res) => {
  try {
    const { name, email, password, role = "user" } = req.body

    const [exists] = await pool.query("SELECT id FROM users WHERE email = ?", [email])
    if (exists.length > 0) return res.status(400).json({ message: "El usuario ya existe" })

    const hashedPassword = await bcrypt.hash(password, 10)
    const [result] = await pool.query(
      "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)",
      [name, email, hashedPassword, role]
    )

    const token = generateToken(result.insertId)
    res.status(201).json({
      success: true,
      token,
      user: { id: result.insertId, name, email, role },
    })
  } catch (error) {
    console.error("Register error:", error)
    res.status(500).json({ message: "Error del servidor" })
  }
}

export const login = async (req, res) => {
  try {
    const { email, password } = req.body
    const [users] = await pool.query("SELECT * FROM users WHERE email = ? AND deleted_at IS NULL", [email])

    if (users.length === 0) return res.status(401).json({ message: "Email o contraseña inválidos" })

    const user = users[0]
    const match = await bcrypt.compare(password, user.password)
    if (!match) return res.status(401).json({ message: "Email o contraseña inválidos" })

    await pool.query("UPDATE users SET last_login_at = CURRENT_TIMESTAMP WHERE id = ?", [user.id])

    const token = generateToken(user.id)
    res.status(200).json({
      success: true,
      token,
      user: { id: user.id, name: user.name, email: user.email, role: user.role },
    })
  } catch (error) {
    console.error("Login error:", error)
    res.status(500).json({ message: "Error del servidor" })
  }
}

export const getProfile = async (req, res) => {
  try {
    const [users] = await pool.query(
      "SELECT id, name, email, role, created_at, last_login_at FROM users WHERE id = ?",
      [req.user.id]
    )
    if (users.length === 0) return res.status(404).json({ message: "Usuario no encontrado" })
    res.status(200).json({ success: true, user: users[0] })
  } catch (error) {
    console.error("Get profile error:", error)
    res.status(500).json({ message: "Error del servidor" })
  }
}