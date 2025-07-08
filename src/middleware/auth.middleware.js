import jwt from "jsonwebtoken"
import  pool  from "../db.js"
import dotenv from "dotenv"
dotenv.config()

export const protect = async (req, res, next) => {
  const authHeader = req.headers.authorization
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ message: "No autorizado" })
  }

  try {
    const token = authHeader.split(" ")[1]
    const decoded = jwt.verify(token, process.env.JWT_SECRET)
    const [users] = await pool.query("SELECT id, name, email, role FROM users WHERE id = ? AND deleted_at IS NULL", [decoded.id])

    if (users.length === 0) return res.status(401).json({ message: "Usuario no válido" })

    req.user = users[0]
    next()
  } catch (error) {
    console.error("Protect middleware error:", error)
    res.status(401).json({ message: "Token inválido" })
  }
}

export const admin = (req, res, next) => {
  if (req.user && req.user.role === "admin") {
    next()
  } else {
    res.status(403).json({ message: "Acceso denegado. Se requiere rol admin." })
  }
}
