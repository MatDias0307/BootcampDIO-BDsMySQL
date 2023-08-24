CREATE DATABASE oficina;
USE oficina;

DROP DATABASE oficina;

CREATE TABLE clients (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    midInitName CHAR(3),
    lastName VARCHAR(50) NOT NULL,
    cpf CHAR(11),
    cnpj CHAR(14),
    cnh CHAR(10) NOT NULL,
    typeCnh VARCHAR(5),
    email VARCHAR(100),
    phone CHAR(11) NOT NULL,
    CONSTRAINT cpf_unique UNIQUE (cpf),
    CONSTRAINT cnpj_unique UNIQUE (cnpj),
    CONSTRAINT cnh_unique UNIQUE (cnh),
    CONSTRAINT client_type_check CHECK (cpf IS NULL OR cnpj IS NULL)
);


CREATE TABLE vehicle (
    idVehicle INT AUTO_INCREMENT PRIMARY KEY,
    typeVehicle VARCHAR(20),
    brand VARCHAR(50),
    model VARCHAR(50),
    year INT,
    plate CHAR(7) NOT NULL,
    color VARCHAR(20),
    chassi CHAR(17) NOT NULL,
    renavamCode CHAR(11) NOT NULL,
    mileage FLOAT,
    CONSTRAINT chassi_unique UNIQUE (chassi),
    CONSTRAINT renavamCode_unique UNIQUE (renavamCode),
    CONSTRAINT plate_unique UNIQUE (plate)
);

CREATE TABLE vehicleClient (
    vehicleId INT,
    clientId INT,
    regular BOOL,
    purchaseDate DATE,
    PRIMARY KEY (vehicleId, clientId),
    CONSTRAINT fk_vc_vehicle FOREIGN KEY (vehicleId) REFERENCES vehicle(idVehicle),
    CONSTRAINT fk_vc_client FOREIGN KEY (clientId) REFERENCES clients(idClient)
);

CREATE TABLE service_order (
    idServiceOrder INT AUTO_INCREMENT PRIMARY KEY,
    vehicleId INT,
    clientId INT,
    orderDate DATE NOT NULL,
    completionDate DATE,
    status ENUM('Pending', 'In Progress', 'Completed', 'Canceled') DEFAULT 'Pending' NOT NULL,
    problemDescription TEXT,
    CONSTRAINT fk_so_vehicle FOREIGN KEY (vehicleId) REFERENCES vehicle(idVehicle),
    CONSTRAINT fk_so_client FOREIGN KEY (clientId) REFERENCES clients(idClient)
);

CREATE TABLE service_order_item (
    serviceOrderId INT,
    quantity INT DEFAULT 1,
    price FLOAT,
    item VARCHAR(30),
    PRIMARY KEY (serviceOrderId),
    CONSTRAINT fk_soi_service_order FOREIGN KEY (serviceOrderId) REFERENCES service_order(idServiceOrder)
);

CREATE TABLE payment (
    orderId INT,
    clientId INT,
    paymentType ENUM('Cash', 'Card', 'Pix', 'Boleto'),
    paymentAmount FLOAT,
    PRIMARY KEY (orderId, clientId),
    CONSTRAINT fk_payment_order FOREIGN KEY (orderId) REFERENCES service_order(idServiceOrder),
    CONSTRAINT fk_payment_client FOREIGN KEY (clientId) REFERENCES clients(idClient)
);

INSERT INTO clients (firstName, midInitName, lastName, cpf, cnpj, cnh, typeCnh, email, phone)
VALUES
    ('John', 'A', 'Doe', '12345678901', NULL, '1234567890', 'A', 'john@example.com', '98765432101'),
    ('Jane', 'B', 'Smith', NULL, '12345678901234', '9876543211', 'B', 'jane@example.com', '98765432102'),
    ('Michael', 'C', 'Johnson', '56789012345', NULL, '5678901234', 'AB', 'michael@example.com', '98765432103'),
    ('Emily', 'AB', 'Williams', NULL, '98765432109876', '9876543212', 'CD', 'emily@example.com', '98765432104'),
    ('David', 'LB', 'Brown', '78901234567', NULL, '7890123456', 'DE', 'david@example.com', '98765432105'),
    ('Sarah', 'CD', 'Jones', NULL, '56789012345678', '5678901233', 'ABC', 'sarah@example.com', '98765432106'),
    ('Daniel', 'L', 'Miller', '23456789012', NULL, '2345678901', 'A', 'daniel@example.com', '98765432107'),
    ('Olivia', 'MD', 'Davis', NULL, '45678901234567', '4567890124', 'B', 'olivia@example.com', '98765432108'),
    ('James', 'MT', 'Wilson', '89012345678', NULL, '8901234567', 'AB', 'james@example.com', '98765432109'),
    ('Sophia', 'PB', 'Martinez', NULL, '23456789012345', '2345678902', 'A', 'sophia@example.com', '98765432110');

INSERT INTO vehicle (typeVehicle, brand, model, year, plate, color, chassi, renavamCode, mileage)
VALUES
    ('Car', 'Toyota', 'Corolla', 2016, 'ABC1234', 'Silver', '12345678901234567', '98765432101', 15000),
    ('Motorcycle', 'Honda', 'CBR 600', 2021, 'DEF5678', 'Red', '23456789012345678', '87654321098', 8000),
    ('Truck', 'Volvo', 'FH16', 2020, 'GHI9012', 'Blue', '34567890123456789', '76543210987', 50000),
    ('Car', 'Ford', 'Mustang', 2005, 'JKL3456', 'Yellow', '45678901234567890', '65432109876', 10000),
    ('Motorcycle', 'Kawasaki', 'Ninja 400', 2022, 'MNO5678', 'Green', '56789012345678901', '54321098765', 6000),
    ('Truck', 'Mercedes-Benz', 'Actros', 2021, 'PQR7890', 'White', '67890123456789012', '43210987654', 40000),
    ('Car', 'Chevrolet', 'Camaro', 2015, 'STU9012', 'Black', '78901234567890123', '32109876543', 12000),
    ('Motorcycle', 'Suzuki', 'GSX-R 750', 2020, 'VWX1234', 'Blue', '89012345678901234', '21098765432', 7000),
    ('Truck', 'Scania', 'R-series', 2022, 'YZA5678', 'Red', '90123456789012345', '10987654321', 30000),
    ('Car', 'BMW', 'X5', 2003, 'BCD3456', 'Silver', '01234567890123456', '09876543210', 8000);

INSERT INTO vehicleClient (vehicleId, clientId, regular, purchaseDate)
VALUES
    (1, 1, TRUE, '2022-01-15'),
    (2, 1, TRUE, '2021-06-10'),
    (3, 3, FALSE, '2020-03-20'),
    (4, 4, TRUE, '2023-04-25'),
    (5, 5, FALSE, '2022-09-05'),
    (6, 7, TRUE, '2021-02-18'),
    (7, 8, FALSE, '2023-07-30'),
    (8, 8, TRUE, '2020-11-12'),
    (9, 9, FALSE, '2022-08-22'),
    (10, 10, TRUE, '2021-05-02');

INSERT INTO service_order (vehicleId, clientId, orderDate, completionDate, status, problemDescription)
VALUES
    (1, 1, '2023-01-10', '2023-01-15', 'Completed', 'Routine maintenance'),
    (1, 1, '2023-02-20', NULL, 'In Progress', 'Engine check'),
    (3, 3, '2023-03-05', '2023-03-07', 'Completed', 'Brake repair'),
    (4, 4, '2023-04-15', NULL, 'Pending', 'Oil change'),
    (5, 5, '2023-05-20', '2023-05-22', 'Completed', 'Tire replacement'),
    (5, 5, '2023-06-10', NULL, 'Pending', 'Electrical issue'),
    (7, 7, '2023-07-15', '2023-07-18', 'Completed', 'Transmission repair'),
    (8, 8, '2023-08-05', NULL, 'In Progress', 'Suspension check'),
    (9, 9, '2023-08-20', '2023-08-21', 'Completed', 'Exhaust system'),
    (10, 10, '2023-09-02', NULL, 'Pending', 'Coolant leak');

INSERT INTO service_order_item (serviceOrderId, quantity, price, item)
VALUES
    (1, 2, 50.00, 'Oil Change'),
    (2, 1, 100.00, 'Engine Diagnostic'),
    (3, 4, 200.00, 'Brake Pad Replacement'),
    (4, 1, 30.00, 'Oil Filter Replacement'),
    (5, 2, 150.00, 'Tire Replacement'),
    (6, 1, 80.00, 'Electrical System Inspection'),
    (7, 3, 250.00, 'Transmission Fluid Change'),
    (8, 1, 120.00, 'Suspension Check'),
    (9, 2, 90.00, 'Muffler Replacement'),
    (10, 1, 50.00, 'Coolant Flush');

INSERT INTO payment (orderId, clientId, paymentType, paymentAmount)
VALUES
    (1, 1, 'Card', 100.00),
    (2, 2, 'Cash', 100.00),
    (3, 3, 'Card', 800.00),
    (4, 4, 'Boleto', 30.00),
    (5, 5, 'Card', 300.00),
    (6, 6, 'Pix', 80.00),
    (7, 7, 'Card', 600.00),
    (8, 8, 'Card', 120.00),
    (9, 9, 'Cash', 90.00),
    (10, 10, 'Card', 50.00);

-- Consulta das constraints da tabela clients
SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'oficina';

-- Consulta simples de clientes
SELECT firstName, lastName, email
FROM clients;

-- Consulta de veículos fabricados a partir de 2020
SELECT brand, model, year
FROM vehicle
WHERE year >= 2020;

-- Consulta de ordens de serviço com cálculo de dias para conclusão
SELECT idServiceOrder, orderDate, completionDate,
       DATEDIFF(completionDate, orderDate) AS daysToComplete
FROM service_order
WHERE completionDate IS NOT NULL;

-- Consulta de clientes ordenados por sobrenome e nome
SELECT firstName, lastName, email
FROM clients
ORDER BY lastName ASC, firstName ASC;

-- Consulta de clientes com mais de 1 pedido de serviço
SELECT clientId, COUNT(*) AS orderCount
FROM service_order
GROUP BY clientId
HAVING orderCount > 1;

-- Consulta de detalhes de ordens de serviço completadas
SELECT so.idServiceOrder, CONCAT(c.firstName, ' ', c.lastName) AS client, v.plate, v.brand, v.model, v.color, v.year, so.problemDescription, ROUND(soi.price, 2) AS price
FROM service_order so
INNER JOIN clients c ON so.clientId = c.idClient
INNER JOIN vehicle v ON so.vehicleId = v.idVehicle
INNER JOIN service_order_item soi ON so.idServiceOrder = soi.serviceOrderId
WHERE so.status = 'Completed';

-- Consulta de clientes com categoria de habilitação 'A'
SELECT firstName, lastName
FROM clients
WHERE typeCnh = 'A';

-- Consulta de clientes com número total de pedidos e valor total faturado
SELECT c.firstName, c.lastName, COUNT(*) AS totalOrders, SUM(soi.price) AS totalAmount
FROM clients c
JOIN service_order so ON c.idClient = so.clientId
INNER JOIN service_order_item soi ON so.idServiceOrder = soi.serviceOrderId
GROUP BY c.idClient
ORDER BY totalAmount DESC;

-- Consulta de clientes com número total de veículos registrados
SELECT c.firstName, c.lastName, COUNT(*) AS totalVehicles
FROM clients c
LEFT JOIN vehicleClient vc ON c.idClient = vc.clientId
WHERE vc.regular = TRUE
GROUP BY c.idClient
ORDER BY totalVehicles DESC;
