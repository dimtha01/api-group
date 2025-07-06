import app from "./app.js";
import { testConnection } from "./db.js";


const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  testConnection()
  console.log(` Servidor corriendo en http://localhost:${PORT} `);
});