-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS PedidosDB;
USE TESTE_ADR_27102024;

-- Tabela de Clientes
CREATE TABLE clientes (
    codigo INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    uf CHAR(2) NOT NULL,
    INDEX idx_nome (nome),
    INDEX idx_cidade_uf (cidade, uf)
);

-- Tabela de Produtos
CREATE TABLE produtos (
    codigo INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(200) NOT NULL,
    preco_venda DECIMAL(10,2) NOT NULL,
    INDEX idx_descricao (descricao)
);

-- Tabela de Pedidos (dados gerais)
CREATE TABLE pedidos (
    numero_pedido INT PRIMARY KEY AUTO_INCREMENT,
    data_emissao DATE NOT NULL,
    codigo_cliente INT NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (codigo_cliente) REFERENCES clientes(codigo),
    INDEX idx_data (data_emissao),
    INDEX idx_cliente (codigo_cliente)
);

-- Tabela de Itens do Pedido
CREATE TABLE pedidos_produtos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    numero_pedido INT NOT NULL,
    codigo_produto INT NOT NULL,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (numero_pedido) REFERENCES pedidos(numero_pedido),
    FOREIGN KEY (codigo_produto) REFERENCES produtos(codigo),
    INDEX idx_pedido (numero_pedido),
    INDEX idx_produto (codigo_produto)
);

-- Inserção de dados de teste para Clientes
INSERT INTO clientes (nome, cidade, uf) VALUES
('João Silva', 'São Paulo', 'SP'),
('Maria Santos', 'Rio de Janeiro', 'RJ'),
('Pedro Oliveira', 'Belo Horizonte', 'MG'),
('Ana Souza', 'Curitiba', 'PR'),
('Carlos Lima', 'Salvador', 'BA'),
('Patricia Ferreira', 'Recife', 'PE'),
('Roberto Costa', 'Fortaleza', 'CE'),
('Sandra Rodrigues', 'Porto Alegre', 'RS'),
('José Pereira', 'Manaus', 'AM'),
('Fernanda Santos', 'Brasília', 'DF'),
('Miguel Ribeiro', 'Vitória', 'ES'),
('Luciana Alves', 'Natal', 'RN'),
('Ricardo Monteiro', 'João Pessoa', 'PB'),
('Amanda Cruz', 'Florianópolis', 'SC'),
('Bruno Cardoso', 'Goiânia', 'GO'),
('Cristina Lima', 'Belém', 'PA'),
('Daniel Soares', 'São Luís', 'MA'),
('Elena Castro', 'Maceió', 'AL'),
('Fábio Mendes', 'Teresina', 'PI'),
('Gabriela Dias', 'Campo Grande', 'MS');

-- Inserção de dados de teste para Produtos
INSERT INTO produtos (descricao, preco_venda) VALUES
('Notebook Dell 15"', 3999.99),
('Smartphone Samsung Galaxy', 2499.99),
('Monitor LG 24"', 899.99),
('Teclado Mecânico', 299.99),
('Mouse Sem Fio', 89.99),
('Impressora HP', 599.99),
('Fone de Ouvido Bluetooth', 199.99),
('Webcam HD', 149.99),
('Pen Drive 32GB', 49.99),
('HD Externo 1TB', 399.99),
('Roteador Wi-Fi', 159.99),
('Carregador Portátil', 79.99),
('Cabo HDMI 2m', 29.99),
('Adaptador USB-C', 39.99),
('Caixa de Som Bluetooth', 129.99),
('Suporte para Notebook', 69.99),
('Kit Teclado e Mouse', 149.99),
('Mousepad Gamer', 45.99),
('Hub USB 4 Portas', 59.99),
('Filtro de Linha', 39.99);

-- Criação de TRIGGER para calcular o valor total do item do pedido
DELIMITER //
CREATE TRIGGER calcular_valor_total_item
BEFORE INSERT ON pedidos_produtos
FOR EACH ROW
BEGIN
    SET NEW.valor_total = NEW.quantidade * NEW.valor_unitario;
END;//
DELIMITER ;

-- Criação de TRIGGER para atualizar o valor total do pedido
DELIMITER //
CREATE TRIGGER atualizar_valor_total_pedido
AFTER INSERT ON pedidos_produtos
FOR EACH ROW
BEGIN
    UPDATE pedidos
    SET valor_total = (
        SELECT SUM(valor_total)
        FROM pedidos_produtos
        WHERE numero_pedido = NEW.numero_pedido
    )
    WHERE numero_pedido = NEW.numero_pedido;
END;//
DELIMITER ;