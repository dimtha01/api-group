-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS ecommerce_industrial
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- Usar la base de datos
USE ecommerce_industrial;

-- Eliminar restricciones y tablas existentes (para evitar duplicados)
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS hero_banners;
DROP TABLE IF EXISTS favorites;
DROP TABLE IF EXISTS deals;
DROP TABLE IF EXISTS product_best_seller_categories;
DROP TABLE IF EXISTS best_seller_categories;
DROP TABLE IF EXISTS product_tags;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS product_specifications;
DROP TABLE IF EXISTS product_images;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;

SET FOREIGN_KEY_CHECKS = 1;

-- Tabla para categorías principales
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    icon VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    created_by INT NULL,
    updated_by INT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla principal para usuarios
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('user', 'admin') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla principal para productos
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category_id INT,
    price DECIMAL(10, 2),
    brand VARCHAR(255),
    stock INT,
    rating DECIMAL(3, 2),
    reviews INT,
    new BOOLEAN,
    best_seller BOOLEAN,
    top_rated BOOLEAN,
    is_active BOOLEAN DEFAULT TRUE,
    thumbnail VARCHAR(255),
    dimensions VARCHAR(255),
    weight VARCHAR(100),
    warranty_information TEXT,
    shipping_information TEXT,
    availability_status VARCHAR(100),
    return_policy TEXT,
    minimum_order_quantity INT,
    sku VARCHAR(100) UNIQUE,
    technical_sheet_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    created_by INT NULL,
    updated_by INT NULL,
    CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES categories(id),
    CONSTRAINT fk_products_created_by FOREIGN KEY (created_by) REFERENCES users(id),
    CONSTRAINT fk_products_updated_by FOREIGN KEY (updated_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla para especificaciones de productos
CREATE TABLE IF NOT EXISTS product_specifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    spec_key VARCHAR(255) NOT NULL,
    spec_value VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_spec_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -- Tabla para imágenes de productos
CREATE TABLE IF NOT EXISTS product_images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    image_url VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NULL,
    CONSTRAINT fk_product_images_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT fk_product_images_created_by FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla para etiquetas
CREATE TABLE IF NOT EXISTS tags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tag_name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NULL,
    CONSTRAINT fk_tags_created_by FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla intermedia para relacionar productos con etiquetas
CREATE TABLE IF NOT EXISTS product_tags (
    product_id INT NOT NULL,
    tag_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NULL,
    PRIMARY KEY (product_id, tag_id),
    CONSTRAINT fk_product_tags_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT fk_product_tags_tag FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE,
    CONSTRAINT fk_product_tags_created_by FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla para categorías destacadas
CREATE TABLE IF NOT EXISTS best_seller_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NULL,
    CONSTRAINT fk_bsc_created_by FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla intermedia para relacionar productos con categorías destacadas
CREATE TABLE IF NOT EXISTS product_best_seller_categories (
    product_id INT NOT NULL,
    best_seller_category_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NULL,
    PRIMARY KEY (product_id, best_seller_category_id),
    CONSTRAINT fk_product_bsc_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT fk_product_bsc_category FOREIGN KEY (best_seller_category_id) REFERENCES best_seller_categories(id) ON DELETE CASCADE,
    CONSTRAINT fk_pbsc_created_by FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla para ofertas
CREATE TABLE IF NOT EXISTS deals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    original_price DECIMAL(10, 2),
    discounted_price DECIMAL(10, 2),
    discount_percentage DECIMAL(5, 2),
    installment BOOLEAN,
    sold INT,
    total_stock INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    start_date TIMESTAMP NULL,
    end_date TIMESTAMP NULL,
    created_by INT NULL,
    CONSTRAINT fk_deals_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT fk_deals_created_by FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla para usuarios favoritos
CREATE TABLE IF NOT EXISTS favorites (
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, product_id),
    CONSTRAINT fk_favorites_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_favorites_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla para banners destacados
CREATE TABLE IF NOT EXISTS hero_banners (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    offer_message TEXT,
    bg_color VARCHAR(50),
    text_color VARCHAR(50),
    button_color VARCHAR(100),
    product_id INT,
    position INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    start_date TIMESTAMP NULL,
    end_date TIMESTAMP NULL,
    created_by INT NULL,
    CONSTRAINT fk_hero_banners_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT fk_hero_banners_created_by FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertar usuarios
INSERT INTO users (name, email, password, role, created_at, updated_at) VALUES
('Admin Principal', 'admin@example.com', SHA2('123456', 256), 'admin', NOW(), NOW()),
('Juan Pérez', 'juan@example.com', SHA2('123456', 256), 'user', NOW(), NOW()),
('María López', 'maria@example.com', SHA2('123456', 256), 'user', NOW(), NOW());

-- Insertar categorías (asumiendo que el admin con id=1 las crea)
INSERT INTO categories (name, icon, created_at, updated_at, created_by) VALUES
('Maquinaria Industrial', 'maq-icon.png', NOW(), NOW(), 1),
('Herramientas Eléctricas', 'tool-icon.png', NOW(), NOW(), 1),
('Equipos de Seguridad', 'safety-icon.png', NOW(), NOW(), 1);

-- Insertar productos (creados por el admin)
INSERT INTO products (
    name, description, category_id, price, brand, stock, rating, reviews, 
    new, best_seller, top_rated, thumbnail, dimensions, weight, 
    warranty_information, shipping_information, availability_status, 
    return_policy, minimum_order_quantity, sku, technical_sheet_url,
    created_at, updated_at, created_by
) VALUES
(
    'Taladro Industrial', 'Taladro de alta potencia para uso industrial.', 2, 299.99, 'Makita', 50, 4.7, 120, 
    FALSE, TRUE, TRUE, 'taladro.jpg', '30x10x5 cm', '2 kg', 
    '2 años', 'Envío gratis a todo el país', 'En stock', 
    '30 días desde compra', 1, 'SKU-TAL-001', 'https://ejemplo.com/ficha-taladro.pdf',
    NOW(), NOW(), 1
),
(
    'Casco de Seguridad', 'Casco resistente a impactos y cómodo para largas jornadas.', 3, 49.99, '3M', 200, 4.8, 80, 
    TRUE, FALSE, TRUE, 'casco.jpg', '35x25x15 cm', '0.5 kg', 
    '1 año', 'Envío gratis en compras mayores a $100', 'En stock', 
    '30 días desde compra', 2, 'SKU-CAS-001', 'https://ejemplo.com/ficha-casco.pdf',
    NOW(), NOW(), 1
),
(
    'Soldadora Inverter', 'Soldadora compacta y eficiente para metalurgia.', 1, 699.99, 'Lincoln Electric', 30, 4.6, 95, 
    FALSE, TRUE, FALSE, 'soldadora.jpg', '40x20x15 cm', '5 kg', 
    '3 años', 'Envío pagado por cliente', 'Disponible bajo pedido', 
    '30 días desde compra', 1, 'SKU-SOL-001', 'https://ejemplo.com/ficha-soldadora.pdf',
    NOW(), NOW(), 1
);

-- Insertar imágenes de productos
INSERT INTO product_images (product_id, image_url, created_at, created_by) VALUES
(1, 'https://ejemplo.com/imagenes/taladro1.jpg', NOW(), 1),
(1, 'https://ejemplo.com/imagenes/taladro2.jpg', NOW(), 1),
(2, 'https://ejemplo.com/imagenes/casco1.jpg', NOW(), 1),
(3, 'https://ejemplo.com/imagenes/soldadora1.jpg', NOW(), 1);

-- Insertar etiquetas
INSERT INTO tags (tag_name, created_at, created_by) VALUES
('destacado', NOW(), 1),
('nuevo', NOW(), 1),
('más vendido', NOW(), 1),
('en oferta', NOW(), 1);

-- Relacionar productos con etiquetas
INSERT INTO product_tags (product_id, tag_id, created_at, created_by) VALUES
(1, 1, NOW(), 1), (1, 3, NOW(), 1),
(2, 2, NOW(), 1), (2, 4, NOW(), 1),
(3, 1, NOW(), 1), (3, 3, NOW(), 1);

-- Insertar categorías destacadas
INSERT INTO best_seller_categories (category_name, created_at, created_by) VALUES
('Top Ventas', NOW(), 1),
('Lo Más Nuevo', NOW(), 1);

-- Relacionar productos con categorías destacadas
INSERT INTO product_best_seller_categories (product_id, best_seller_category_id, created_at, created_by) VALUES
(1, 1, NOW(), 1),
(2, 2, NOW(), 1),
(3, 1, NOW(), 1);

-- Insertar ofertas
INSERT INTO deals (
    product_id, original_price, discounted_price, discount_percentage, 
    installment, sold, total_stock, created_at, start_date, end_date, created_by
) VALUES
(1, 299.99, 259.99, 13.33, TRUE, 100, 150, NOW(), NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), 1),
(2, 49.99, 39.99, 20.00, FALSE, 50, 200, NOW(), NOW(), DATE_ADD(NOW(), INTERVAL 5 DAY), 1);

-- Insertar productos favoritos (usuario-producto)
INSERT INTO favorites (user_id, product_id, created_at) VALUES
(1, 1, NOW()),
(2, 1, NOW()),
(2, 2, NOW());

-- Insertar banners destacados
INSERT INTO hero_banners (
    title, offer_message, bg_color, text_color, button_color, 
    product_id, position, created_at, start_date, end_date, created_by
) VALUES
(
    'Oferta del Día', '¡Solo por hoy! 20% de descuento', '#FFD700', '#000000', '#FF4500', 
    1, 1, NOW(), NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY), 1
),
(
    'Nuevo Lanzamiento', 'Llegó lo último en seguridad laboral', '#00BFFF', '#FFFFFF', '#000080', 
    2, 2, NOW(), NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 1
);