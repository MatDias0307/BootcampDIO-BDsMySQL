CREATE DATABASE ecommerce;
USE ecommerce;

DROP DATABASE ecommerce;

CREATE TABLE clients(
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    midInitName CHAR(3),
    lastName VARCHAR(50) NOT NULL,
    cpf CHAR(11),
    cnpj CHAR(14),
    email VARCHAR(100) NOT NULL,
    phone CHAR(11) NOT NULL,
    CONSTRAINT cpf_client_unique UNIQUE (cpf),
    CONSTRAINT cnpj_client_unique UNIQUE (cnpj),
    CONSTRAINT client_type_check CHECK (cpf IS NULL OR cnpj IS NULL)
);

CREATE TABLE product(
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    productName VARCHAR(100) NOT NULL,
    classificationKids BOOLEAN,
    category ENUM('Furniture', 'Clothing', 'Toy', 'Food', 'Electronics') NOT NULL,
    rating FLOAT DEFAULT 0,
    size VARCHAR(20),
    description TEXT
);

CREATE TABLE seller(
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    companyName VARCHAR(100) NOT NULL,
    cnpj CHAR(14),
    cpf CHAR(11),
    contactName VARCHAR(50) NOT NULL,
    contactEmail VARCHAR(100) NOT NULL,
    contactPhone CHAR(11) NOT NULL,
    location VARCHAR(200),
    CONSTRAINT cpf_seller_unique UNIQUE (cpf),
    CONSTRAINT cnpj_seller_unique UNIQUE (cnpj),
    CONSTRAINT seller_type_check CHECK (cpf IS NULL OR cnpj IS NULL)
);

CREATE TABLE supplier(
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    companyName VARCHAR(100) NOT NULL,
    cnpj CHAR(14) NOT NULL,
    contactName VARCHAR(50) NOT NULL,
    contactEmail VARCHAR(100) NOT NULL,
    contactPhone CHAR(11) NOT NULL,
    CONSTRAINT supplier_cnpj_unique UNIQUE (cnpj)
);

CREATE TABLE orders(
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    clientId INT,
    orderStatus ENUM('Confirmed', 'Processing', 'Shipped', 'Delivered', 'Cancelled') NOT NULL,
    deliveryAddress VARCHAR(100) NOT NULL,
    totalAmount FLOAT NOT NULL,
    CONSTRAINT fk_order_client FOREIGN KEY (clientId) REFERENCES clients(idClient)
);

CREATE TABLE payment(
    orderId INT,
    clientId INT,
    paymentType ENUM('Cash', 'Card', 'Pix', 'Boleto'),
    paymentAmount FLOAT,
    PRIMARY KEY (orderId, clientId),
    CONSTRAINT fk_payment_order FOREIGN KEY (orderId) REFERENCES orders(idOrder),
    CONSTRAINT fk_payment_client FOREIGN KEY (clientId) REFERENCES clients(idClient)
);

CREATE TABLE productStorage(
    productId INT,
    storageLocation VARCHAR(200),
    quantity INT DEFAULT 0,
    PRIMARY KEY (productId),
    CONSTRAINT fk_productStorage_product FOREIGN KEY (productId) REFERENCES product(idProduct)
);

CREATE TABLE productSeller(
    productId INT,
    sellerId INT,
    quantityProduct INT DEFAULT 1,
    price FLOAT,
    PRIMARY KEY (productId, sellerId),
    CONSTRAINT fk_productSeller_product FOREIGN KEY (productId) REFERENCES product(idProduct),
    CONSTRAINT fk_productSeller_seller FOREIGN KEY (sellerId) REFERENCES seller(idSeller)
);

CREATE TABLE productSupplier(
    productId INT,
    supplierId INT,
    costPrice FLOAT,
    PRIMARY KEY(productID, supplierId),
    CONSTRAINT fk_productSupplier_product FOREIGN KEY (productId) REFERENCES product(idProduct),
    CONSTRAINT fk_productSupplier_supplier FOREIGN KEY (supplierId) REFERENCES supplier(idSupplier)
);

CREATE TABLE productOrder(
    productId INT,
    orderId INT,
    quantity INT DEFAULT 1,
    status ENUM('Available', 'Out of Stock') DEFAULT 'Available',
    PRIMARY KEY (productId, orderId),
    CONSTRAINT fk_productOrder_product FOREIGN KEY (productId) REFERENCES product(idProduct),
    CONSTRAINT fk_productOrder_order FOREIGN KEY (orderId) REFERENCES orders(idOrder)
);

CREATE TABLE delivery(
    orderId INT,
    deliveryStatus ENUM('Shipped', 'Delivered') NOT NULL,
    trackingCode VARCHAR(50),
    PRIMARY KEY (orderId),
    CONSTRAINT fk_delivery_order FOREIGN KEY (orderId) REFERENCES orders(idOrder)
);

INSERT INTO clients (firstName, midInitName, lastName, cpf, cnpj, email, phone)
VALUES
    ('John', 'A', 'Doe', '12345678901', NULL, 'john@example.com', '98765432101'),
    ('Jane', NULL, 'Smith', NULL, '12345678901234', 'jane@example.com', '87654321012'),
    ('Michael', 'B', 'Johnson', '23456789012', NULL, 'michael@example.com', '76543210987'),
    ('Emily', NULL, 'Williams', NULL, '23456789012345', 'emily@example.com', '65432109876'),
    ('David', 'C', 'Brown', '34567890123', NULL, 'david@example.com', '54321098765'),
    ('Sarah', NULL, 'Miller', NULL, '34567890123456', 'sarah@example.com', '43210987654'),
    ('Christopher', 'D', 'Taylor', '45678901234', NULL, 'chris@example.com', '32109876543'),
    ('Olivia', NULL, 'Anderson', NULL, '45678901234567', 'olivia@example.com', '21098765432'),
    ('Daniel', 'E', 'Martinez', '56789012345', NULL, 'daniel@example.com', '10987654321'),
    ('Sophia', NULL, 'Garcia', NULL, '56789012345678', 'sophia@example.com', '09876543210');

INSERT INTO product (productName, classificationKids, category, rating, size, description)
VALUES
    ('Wooden Table', TRUE, 'Furniture', 4.5, '100x60x80 cm', 'Sturdy wooden table for kids'),
    ('T-shirt', TRUE, 'Clothing', 3.2, 'M', 'Cotton t-shirt with a fun design'),
    ('Remote Control Car', TRUE, 'Toy', 4.8, NULL, 'Remote control car for kids to play with'),
    ('Chocolate Bar', TRUE, 'Food', 4.6, NULL, 'Delicious milk chocolate bar'),
    ('Smartphone', FALSE, 'Electronics', 4.2, NULL, 'High-end smartphone with advanced features'),
    ('Desk Chair', FALSE, 'Furniture', 4.0, NULL, 'Comfortable desk chair for home office'),
    ('Puzzle Set', TRUE, 'Toy', 4.7, NULL, 'Educational puzzle set for children'),
    ('Jeans', FALSE, 'Clothing', 3.9, '32', 'Classic blue jeans for adults'),
    ('Laptop', FALSE, 'Electronics', 4.5, NULL, 'Powerful laptop for productivity and gaming'),
    ('Canned Soup', TRUE, 'Food', 4.3, NULL, 'Hearty canned soup for quick meals');

INSERT INTO seller (companyName, cnpj, cpf, contactName, contactEmail, contactPhone, location)
VALUES
    ('Furniture World', NULL, '12345678901', 'Alice Johnson', 'alice@furnitureworld.com', '98765432101', 'City Center'),
    ('Toy Universe', NULL, '23456789012', 'Bob Smith', 'bob@toyuniverse.com', '87654321012', 'Mall Street'),
    ('Clothing Boutique', NULL, '34567890123', 'Charlie Brown', 'charlie@clothingboutique.com', '76543210987', 'Fashion Avenue'),
    ('Electronics Emporium', NULL, '45678901234', 'David Miller', 'david@electronics.com', '65432109876', 'Tech Plaza'),
    ('Food Delights', NULL, '56789012345', 'Emma Taylor', 'emma@fooddelights.com', '54321098765', 'Market Street'),
    ('Home Decor', '12345678901234', NULL, 'Frank Garcia', 'frank@homedecor.com', '43210987654', 'Decor Street'),
    ('Kids Paradise', '23456789012345', NULL, 'Grace Anderson', 'grace@kidsparadise.com', '32109876543', 'Playland Mall'),
    ('Gadget Haven', '34567890123456', NULL, 'Henry Martinez', 'henry@gadgethaven.com', '21098765432', 'Tech Square'),
    ('Fashion Emporium', '45678901234567', NULL, 'Isabella Johnson', 'isabella@fashionemporium.com', '10987654321', 'Fashion Hub'),
    ('Gourmet Foods', '56789012345678', NULL, 'Jack Garcia', 'jack@gourmetfoods.com', '09876543210', 'Gourmet Street');

INSERT INTO supplier (companyName, cnpj, contactName, contactEmail, contactPhone)
VALUES
    ('Wood Suppliers', '12345678901234', 'Adam Woodman', 'adam@woodsuppliers.com', '98765432101'),
    ('Toy Makers', '23456789012345', 'Eve Toyer', 'eve@toymakers.com', '87654321012'),
    ('Cloth Creations', '34567890123456', 'Grace Tailor', 'grace@clothcreations.com', '76543210987'),
    ('Electronics Supplies', '45678901234567', 'Tech Guru', 'tech@electronicsupplies.com', '65432109876'),
    ('Food Farms', '56789012345678', 'Frank Farmer', 'frank@foodfarms.com', '54321098765'),
    ('Home Decor Crafters', '67890123456789', 'Helen Decor', 'helen@homedecorcrafters.com', '43210987654'),
    ('Toy Creators', '78901234567890', 'Tom Tinker', 'tom@toycreators.com', '32109876543'),
    ('Gadget Suppliers', '89012345678901', 'Gary Gadgets', 'gary@gadgetsuppliers.com', '21098765432'),
    ('Fashion Fabricators', '90123456789012', 'Fiona Fashion', 'fiona@fashionfabricators.com', '10987654321'),
    ('Food Producers', '01234567890123', 'Paul Producer', 'paul@foodproducers.com', '09876543210');

INSERT INTO orders (clientId, orderStatus, deliveryAddress, totalAmount)
VALUES
    (1, 'Confirmed', '123 Main St', 150.0),
    (3, 'Processing', '456 Elm St', 250.0),
    (5, 'Shipped', '789 Oak St', 120.0),
    (2, 'Delivered', '101 Maple St', 75.0),
    (4, 'Cancelled', '202 Pine St', 50.0),
    (6, 'Confirmed', '303 Birch St', 180.0),
    (8, 'Processing', '404 Walnut St', 300.0),
    (10, 'Shipped', '505 Cedar St', 210.0),
    (7, 'Delivered', '606 Spruce St', 90.0),
    (9, 'Confirmed', '707 Fir St', 140.0);

INSERT INTO payment (orderId, clientId, paymentType, paymentAmount)
VALUES
    (1, 1, 'Card', 150.0),
    (2, 3, 'Pix', 250.0),
    (3, 5, 'Boleto', 120.0),
    (4, 2, 'Cash', 75.0),
    (5, 4, 'Card', 50.0),
    (6, 6, 'Card', 180.0),
    (7, 8, 'Pix', 300.0),
    (8, 10, 'Boleto', 210.0),
    (9, 7, 'Card', 90.0),
    (10, 9, 'Pix', 140.0);

INSERT INTO productStorage (productId, storageLocation, quantity)
VALUES
    (1, 'Warehouse A', 50),
    (2, 'Warehouse B', 100),
    (3, 'Warehouse C', 30),
    (4, 'Warehouse A', 200),
    (5, 'Warehouse B', 75),
    (6, 'Warehouse C', 20),
    (7, 'Warehouse A', 150),
    (8, 'Warehouse B', 80),
    (9, 'Warehouse C', 40),
    (10, 'Warehouse A', 120);

INSERT INTO productSeller (productId, sellerId, quantityProduct, price)
VALUES
    (1, 1, 10, 50.0),
    (2, 3, 20, 20.0),
    (3, 2, 15, 30.0),
    (4, 5, 50, 5.0),
    (5, 4, 25, 800.0),
    (6, 1, 8, 150.0),
    (7, 6, 12, 10.0),
    (8, 7, 18, 40.0),
    (9, 8, 30, 900.0),
    (10, 10, 10, 2.0);

INSERT INTO productSupplier (productId, supplierId, costPrice)
VALUES
    (1, 1, 40.0),
    (2, 2, 15.0),
    (3, 3, 25.0),
    (4, 4, 3.0),
    (5, 5, 600.0),
    (6, 6, 100.0),
    (7, 7, 8.0),
    (8, 8, 30.0),
    (9, 9, 800.0),
    (10, 10, 1.5);

INSERT INTO productOrder (productId, orderId, quantity, status)
VALUES
    (1, 1, 3, 'Available'),
    (2, 7, 5, 'Available'),
    (3, 3, 2, 'Available'),
    (4, 9, 10, 'Available'),
    (5, 8, 5, 'Available'),
    (6, 2, 1, 'Available'),
    (7, 6, 4, 'Available'),
    (8, 10, 7, 'Available'),
    (9, 5, 6, 'Available'),
    (10, 4, 2, 'Available');

INSERT INTO delivery (orderId, deliveryStatus, trackingCode)
VALUES
    (1, 'Shipped', 'AB123456'),
    (2, 'Delivered', 'CD789012'),
    (3, 'Shipped', 'EF345678'),
    (4, 'Delivered', 'GH901234'),
    (5, 'Shipped', 'IJ567890'),
    (6, 'Shipped', 'KL234567'),
    (7, 'Delivered', 'MN890123'),
    (8, 'Shipped', 'OP456789'),
    (9, 'Shipped', 'QR012345'),
    (10, 'Delivered', 'ST678901');
    
SHOW TABLES;
DESC clients;
SELECT * FROM clients;

-- quantidade de clientes
SELECT COUNT(*) FROM clients;

-- id e status do pedido de cada cliente
SELECT CONCAT(firstName, ' ', lastName) AS Client, idOrder, orderStatus AS Status
FROM clients c
INNER JOIN orders o ON c.idClient = o.clientId;

-- quantos pedidos foram feitos por cada cliente
SELECT clientId, COUNT(*) AS OrderCount
FROM orders
GROUP BY clientId;

-- junção da tabela clientes e pedidos
SELECT * FROM clients
LEFT OUTER JOIN orders ON idClient = clientId;

-- junção da tabela clientes, pedido e produto pedido
SELECT c.idClient, c.firstName, c.lastName, o.idOrder, o.orderStatus, p.productId, p.productName, po.quantity
FROM clients c
INNER JOIN orders o ON c.idClient = o.clientId
INNER JOIN productOrder po ON o.idOrder = po.orderId
INNER JOIN product p ON po.productId = p.idProduct
GROUP BY c.idClient, o.idOrder, p.productId;

-- filtragem de produtos por categoria e classificação para crianças
SELECT productName, category, rating
FROM product
WHERE category = 'Toy' AND classificationKids = TRUE;

-- listagem de fornecedores e seus produtos com preço de custo
SELECT s.companyName AS Supplier, p.productName AS Product, ps.costPrice
FROM supplier s
INNER JOIN productSupplier ps ON s.idSupplier = ps.supplierId
INNER JOIN product p ON ps.productId = p.idProduct;

-- total de vendas por forma de pagamento
SELECT paymentType, SUM(paymentAmount) AS TotalSales
FROM payment
GROUP BY paymentType;

-- produtos mais caros vendidos por vendedores
SELECT s.companyName AS Seller, p.productName, MAX(ps.price) AS MaxPrice
FROM seller s
INNER JOIN productSeller ps ON s.idSeller = ps.sellerId
INNER JOIN product p ON ps.productId = p.idProduct
GROUP BY s.companyName, p.productName;

-- clientes que fizeram mais de 2 pedidos
SELECT c.firstName, c.lastName, COUNT(o.idOrder) AS OrderCount
FROM clients c
INNER JOIN orders o ON c.idClient = o.clientId
GROUP BY c.idClient
HAVING OrderCount > 2;

-- listar informações de produtos e seus vendedores, ordenados pelo preço do produto de forma decrescente
SELECT p.productName, ps.price, s.companyName AS SellerName
FROM product p
INNER JOIN productSeller ps ON p.idProduct = ps.productId
INNER JOIN seller s ON ps.sellerId = s.idSeller
ORDER BY ps.price DESC;

-- algum vendedor também é fornecedor?
SELECT s.companyName AS Seller, IF(COUNT(su.idSupplier) > 0, 'Yes', 'No') AS IsSupplier
FROM seller s
LEFT JOIN supplier su ON s.cnpj = su.cnpj
GROUP BY s.idSeller;

-- relação de produtos, fornecedores e estoques
SELECT p.productName, s.companyName AS Supplier, ps.costPrice, pst.quantity AS StockQuantity
FROM product p
INNER JOIN productSupplier ps ON p.idProduct = ps.productId
INNER JOIN supplier s ON ps.supplierId = s.idSupplier
INNER JOIN productStorage pst ON p.idProduct = pst.productId;

-- relação de nomes dos fornecedores e nomes dos produtos
SELECT s.companyName AS Supplier, GROUP_CONCAT(p.productName SEPARATOR ', ') AS Products
FROM supplier s
INNER JOIN productSupplier ps ON s.idSupplier = ps.supplierId
INNER JOIN product p ON ps.productId = p.idProduct
GROUP BY s.idSupplier;


