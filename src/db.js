import mysql from 'mysql2/promise';
import dotenv from 'dotenv';

dotenv.config();

const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASS || '',
  database: process.env.DB_NAME || 'ecommerce_industrial',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
};

const pool = mysql.createPool(dbConfig);

// Función para verificar la conexión
export async function testConnection() {
  let connection;
  try {
    connection = await pool.getConnection();
    console.log('✅ Conexión a MySQL establecida correctamente');
    await connection.ping();
    console.log('✅ Ping a la base de datos exitoso');
    return true;
  } catch (error) {
    console.error('❌ Error de conexión a MySQL:', error.message);
    return false;
  } finally {
    if (connection) connection.release();
  }
}

export default pool;