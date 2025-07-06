import  pool  from '../db.js'

export const getProducts = async (req, res) => {
    try {
        const [rows] = await pool.query("SELECT * FROM products");
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: "Error al obtener los productos" });
    }
}

export const createProducts = async (req, res) => {
    try {
        const {
            name,
            description,
            category_id,
            price,
            brand,
            stock,
            rating,
            reviews,
            new: isNew,
            best_seller,
            top_rated,
            is_active,
            thumbnail,
            dimensions,
            weight,
            warranty_information,
            shipping_information,
            availability_status,
            return_policy,
            minimum_order_quantity,
            sku,
            technical_sheet_url,
            created_by
        } = req.body;

        const query = `
    INSERT INTO products (
        name, description, category_id, price, brand, stock, rating, reviews,
        new, best_seller, top_rated, is_active, thumbnail, dimensions, weight,
        warranty_information, shipping_information, availability_status,
        return_policy, minimum_order_quantity, sku, technical_sheet_url, created_by
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)

    `;

        const values = [
            name,
            description,
            category_id,
            price,
            brand,
            stock,
            rating,
            reviews,
            isNew,
            best_seller,
            top_rated,
            is_active,
            thumbnail,
            dimensions,
            weight,
            warranty_information,
            shipping_information,
            availability_status,
            return_policy,
            minimum_order_quantity,
            sku,
            technical_sheet_url,
            created_by
        ];

        const [result] = await pool.query(query, values);

        res.status(201).json({
            id: result.insertId,
            message: "Producto creado correctamente"
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Error al crear el producto" });
    }
};

export const putProduct = async (req, res) => {
    try {
        const { id } = req.params;

        const {
            name,
            description,
            category_id,
            price,
            brand,
            stock,
            rating,
            reviews,
            new: isNew,
            best_seller,
            top_rated,
            is_active,
            thumbnail,
            dimensions,
            weight,
            warranty_information,
            shipping_information,
            availability_status,
            return_policy,
            minimum_order_quantity,
            sku,
            technical_sheet_url,
            created_by,
            updated_by
        } = req.body;

        const query = `
            UPDATE products SET
                name = ?,
                description = ?,
                category_id = ?,
                price = ?,
                brand = ?,
                stock = ?,
                rating = ?,
                reviews = ?,
                new = ?,
                best_seller = ?,
                top_rated = ?,
                is_active = ?,
                thumbnail = ?,
                dimensions = ?,
                weight = ?,
                warranty_information = ?,
                shipping_information = ?,
                availability_status = ?,
                return_policy = ?,
                minimum_order_quantity = ?,
                sku = ?,
                technical_sheet_url = ?,
                updated_by = ?
            WHERE id = ?
        `;

        const values = [
            name,
            description,
            category_id,
            price,
            brand,
            stock,
            rating,
            reviews,
            isNew,
            best_seller,
            top_rated,
            is_active,
            thumbnail,
            dimensions,
            weight,
            warranty_information,
            shipping_information,
            availability_status,
            return_policy,
            minimum_order_quantity,
            sku,
            technical_sheet_url,
            updated_by,
            id
        ];

        const [result] = await pool.query(query, values);

        if (result.affectedRows === 0) {
            return res.status(404).json({ error: "Producto no encontrado" });
        }

        res.json({ message: "Producto actualizado correctamente" });

    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Error al actualizar el producto" });
    }
};

export const deleteProduct = async (req, res) => {
    try {
        const { id } = req.params;

        const query = 'DELETE FROM products WHERE id = ?';
        const [result] = await pool.query(query, [id]);

        if (result.affectedRows === 0) {
            return res.status(404).json({ error: "Producto no encontrado" });
        }

        res.json({ message: "Producto eliminado correctamente" });

    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Error al eliminar el producto" });
    }
};