import  pool  from "../db.js"
import bcrypt from "bcryptjs"

export const getUsers = async (req, res) => {
  try {
    const [users] = await pool.query("SELECT id, name, email, role, created_at, last_login_at FROM users WHERE deleted_at IS NULL")
    res.status(200).json({ success: true, count: users.length, users })
  } catch (error) {
    console.error("Get users error:", error)
    res.status(500).json({ message: "Error del servidor" })
  }
}

export const getUserById = async (req, res) => {
  try {
    const [users] = await pool.query("SELECT id, name, email, role, created_at FROM users WHERE id = ? AND deleted_at IS NULL", [req.params.id])
    if (users.length === 0) return res.status(404).json({ message: "Usuario no encontrado" })
    res.status(200).json({ success: true, user: users[0] })
  } catch (error) {
    console.error("Get user by ID error:", error)
    res.status(500).json({ message: "Error del servidor" })
  }
}

export const createUser = async (req, res) => {
  try {
    const { name, email, password, role = "user" } = req.body
    if (!name || !email || !password) return res.status(400).json({ message: "Datos incompletos" })

    const [exists] = await pool.query("SELECT id FROM users WHERE email = ?", [email])
    if (exists.length > 0) return res.status(400).json({ message: "Usuario ya existe" })

    const hashedPassword = await bcrypt.hash(password, 10)
    const [result] = await pool.query("INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)", [name, email, hashedPassword, role])
    const [created] = await pool.query("SELECT id, name, email, role, created_at FROM users WHERE id = ?", [result.insertId])
    res.status(201).json({ success: true, user: created[0] })
  } catch (error) {
    console.error("Create user error:", error)
    res.status(500).json({ message: "Error del servidor" })
  }
}

export const updateUser = async (req, res) => {
  try {
    const { name, email, password, role } = req.body
    const [users] = await pool.query("SELECT * FROM users WHERE id = ? AND deleted_at IS NULL", [req.params.id])
    if (users.length === 0) return res.status(404).json({ message: "Usuario no encontrado" })

    const user = users[0]
    let hashedPassword = user.password
    if (password) hashedPassword = await bcrypt.hash(password, 10)

    await pool.query(
      `UPDATE users SET name = ?, email = ?, password = ?, role = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?`,
      [name || user.name, email || user.email, hashedPassword, role || user.role, req.params.id]
    )

    const [updated] = await pool.query("SELECT id, name, email, role FROM users WHERE id = ?", [req.params.id])
    res.status(200).json({ success: true, user: updated[0] })
  } catch (error) {
    console.error("Update user error:", error)
    res.status(500).json({ message: "Error del servidor" })
  }
}

export const deleteUser = async (req, res) => {
  try {
    const [users] = await pool.query("SELECT id FROM users WHERE id = ? AND deleted_at IS NULL", [req.params.id])
    if (users.length === 0) return res.status(404).json({ message: "Usuario no encontrado" })
    await pool.query("UPDATE users SET deleted_at = CURRENT_TIMESTAMP WHERE id = ?", [req.params.id])
    res.status(200).json({ success: true, message: "Usuario eliminado" })
  } catch (error) {
    console.error("Delete user error:", error)
    res.status(500).json({ message: "Error del servidor" })
  }
}
