import { Router } from 'express'
import { getProducts, createProducts, putProduct,deleteProduct } from "../controllers/products.controller.js";

const router = Router()

router.get('/products', getProducts)
router.post('/products', createProducts)
router.put('/products/:id', putProduct)
router.delete('/products/:id', deleteProduct)


export default router