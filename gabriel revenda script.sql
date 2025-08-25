create database db_revenda_Gabriel;

CREATE TABLE cliente(
    cliente_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    data_cadastro DATE DEFAULT CURRENT_DATE,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE produto(
    produto_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    preco NUMERIC(10,2) NOT NULL,
    estoque INT NOT NULL,
    codigo_barra CHAR(13) UNIQUE
);

CREATE TABLE fornecedor(
    fornecedor_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cnpj CHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    cidade VARCHAR(50) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE pedido(
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL REFERENCES cliente(cliente_id),
    data_pedido DATE DEFAULT CURRENT_DATE,
    valor_total NUMERIC(10,2) default 0,
    status VARCHAR(20) DEFAULT 'PENDENTE'
);

CREATE TABLE pagamento(
    pagamento_id SERIAL PRIMARY KEY,
    pedido_id INT NOT NULL REFERENCES pedido(pedido_id),
    metodo VARCHAR(30) NOT NULL,
    valor NUMERIC(10,2) NOT NULL,
    data_pagamento DATE DEFAULT CURRENT_DATE,
    confirmado BOOLEAN DEFAULT FALSE
);

CREATE TABLE pedido_produto(
    pedido_id INT NOT NULL REFERENCES pedido(pedido_id),
    produto_id INT NOT NULL REFERENCES produto(produto_id),
    quantidade INT NOT NULL,
    preco_unitario NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (pedido_id, produto_id)
);

CREATE VIEW vw_pedido_cliente AS
SELECT p.pedido_id, c.nome AS cliente, p.data_pedido, p.valor_total, p.status
FROM pedido p
JOIN cliente c ON p.cliente_id = c.cliente_id;

CREATE VIEW vw_pedido_produto AS
SELECT pp.pedido_id, pr.nome AS produto, pp.quantidade, pp.preco_unitario,
       (pp.quantidade * pp.preco_unitario) AS subtotal
FROM pedido_produto pp
JOIN produto pr ON pp.produto_id = pr.produto_id;

INSERT INTO cliente (nome, email, telefone) VALUES
('João Silva','joao@email.com','119999999'),
('Maria Souza','maria@email.com','118888888'),
('Pedro Costa','pedro@email.com','117777777'),
('Ana Lima','ana@email.com','116666666'),
('Lucas Rocha','lucas@email.com','115555555'),
('Carla Nunes','carla@email.com','114444444'),
('Felipe Alves','felipe@email.com','113333333'),
('Bruna Reis','bruna@email.com','112222222'),
('Diego Martins','diego@email.com','111111111'),
('Juliana Gomes','juliana@email.com','110000000');

INSERT INTO produto (nome, categoria, preco, estoque, codigo_barra) VALUES
('Violão Yamaha','Cordas',1200,10,'7891234567890'),
('Guitarra Fender','Cordas',4500,5,'7891234567891'),
('Bateria Pearl','Percussão',7000,2,'7891234567892'),
('Teclado Casio','Teclas',1800,8,'7891234567893'),
('Baixo Ibanez','Cordas',3500,4,'7891234567894'),
('Sax Yamaha','Sopro',6000,3,'7891234567895'),
('Microfone Shure','Acessórios',900,15,'7891234567896'),
('Pedal Boss DS-1','Acessórios',700,12,'7891234567897'),
('Caixa de Som JBL','Áudio',2500,6,'7891234567898'),
('Mesa de Som Behringer','Áudio',3000,2,'7891234567899');

INSERT INTO fornecedor (nome, cnpj, telefone, cidade) VALUES
('Music World','12345678000100','119111111','São Paulo'),
('Som Brasil','22345678000100','119222222','Rio de Janeiro'),
('Instrumentos Max','32345678000100','119333333','Belo Horizonte'),
('Áudio Forte','42345678000100','119444444','Curitiba'),
('Harmonia Ltda','52345678000100','119555555','Porto Alegre'),
('Sons do Sul','62345678000100','119666666','Florianópolis'),
('Timbre Musical','72345678000100','119777777','Brasília'),
('Estação Som','82345678000100','119888888','Salvador'),
('Show Music','92345678000100','119999999','Recife'),
('Top Audio','10345678000100','118888888','Fortaleza');

INSERT INTO pedido (cliente_id, valor_total, status) VALUES
(1, 0, 'PENDENTE'),
(2, 0, 'PENDENTE'),
(3, 0, 'PENDENTE'),
(4, 0, 'PENDENTE'),
(5, 0, 'PENDENTE'),
(6, 0, 'PENDENTE'),
(7, 0, 'PENDENTE'),
(8, 0, 'PENDENTE'),
(9, 0, 'PENDENTE'),
(10,0, 'PENDENTE');

INSERT INTO pagamento (pedido_id, metodo, valor, confirmado) VALUES
(1,'Cartão Crédito',1200,TRUE),
(2,'Boleto',1800,FALSE),
(3,'Pix',4500,TRUE),
(4,'Cartão Débito',900,TRUE),
(5,'Pix',2500,FALSE),
(6,'Boleto',3000,TRUE),
(7,'Pix',7000,TRUE),
(8,'Cartão Crédito',3500,TRUE),
(9,'Cartão Débito',6000,FALSE),
(10,'Pix',700,TRUE);

INSERT INTO pedido_produto (pedido_id, produto_id, quantidade, preco_unitario) VALUES
(1,1,1,1200),
(2,4,1,1800),
(3,2,1,4500),
(4,7,1,900),
(5,9,1,2500),
(6,10,1,3000),
(7,3,1,7000),
(8,5,1,3500),
(9,6,1,6000),
(10,8,1,700);

SELECT * FROM vw_pedido_cliente;

SELECT * FROM vw_pedido_produto;