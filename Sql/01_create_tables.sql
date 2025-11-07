/* ==============================
   1 - Criação das tabelas
   ============================== */

DROP TABLE IF EXISTS venda_item;
DROP TABLE IF EXISTS venda;
DROP TABLE IF EXISTS prescricao;
DROP TABLE IF EXISTS produto;
DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS funcionario;
DROP TABLE IF EXISTS fornecedor;
DROP TABLE IF EXISTS marca;

-- Tabela de marcas
CREATE TABLE marca (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  pais_origem VARCHAR(80)
) ENGINE=InnoDB;

-- Fornecedores
CREATE TABLE fornecedor (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(150) NOT NULL,
  telefone VARCHAR(20),
  email VARCHAR(100),
  cidade VARCHAR(100)
) ENGINE=InnoDB;

-- Funcionários
CREATE TABLE funcionario (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(150) NOT NULL,
  cargo VARCHAR(80),
  salario DECIMAL(10,2),
  telefone VARCHAR(20),
  data_contratacao DATE
) ENGINE=InnoDB;

-- Clientes
CREATE TABLE cliente (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(150) NOT NULL,
  cpf VARCHAR(14) UNIQUE,
  telefone VARCHAR(20),
  email VARCHAR(100),
  data_nascimento DATE
) ENGINE=InnoDB;

-- Produtos (óculos, lentes, armações, acessórios)
CREATE TABLE produto (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(150) NOT NULL,
  descricao TEXT,
  preco DECIMAL(10,2) NOT NULL,
  qtd_estoque INT DEFAULT 0,
  marca_id INT,
  fornecedor_id INT,
  CONSTRAINT fk_produto_marca FOREIGN KEY (marca_id) REFERENCES marca(id) ON DELETE SET NULL,
  CONSTRAINT fk_produto_fornecedor FOREIGN KEY (fornecedor_id) REFERENCES fornecedor(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Prescrições (opcionais, associadas ao cliente)
CREATE TABLE prescricao (
  id INT PRIMARY KEY AUTO_INCREMENT,
  cliente_id INT NOT NULL,
  data_prescricao DATE NOT NULL,
  esf_od DECIMAL(4,2),
  esf_oe DECIMAL(4,2),
  cil_od DECIMAL(4,2),
  cil_oe DECIMAL(4,2),
  observacoes TEXT,
  CONSTRAINT fk_presc_cliente FOREIGN KEY (cliente_id) REFERENCES cliente(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Vendas
CREATE TABLE venda (
  id INT PRIMARY KEY AUTO_INCREMENT,
  cliente_id INT,
  funcionario_id INT,
  data_venda DATETIME DEFAULT CURRENT_TIMESTAMP,
  total DECIMAL(10,2) DEFAULT 0,
  CONSTRAINT fk_venda_cliente FOREIGN KEY (cliente_id) REFERENCES cliente(id) ON DELETE SET NULL,
  CONSTRAINT fk_venda_funcionario FOREIGN KEY (funcionario_id) REFERENCES funcionario(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Itens da venda
CREATE TABLE venda_item (
  id INT PRIMARY KEY AUTO_INCREMENT,
  venda_id INT NOT NULL,
  produto_id INT NOT NULL,
  quantidade INT NOT NULL DEFAULT 1,
  preco_unitario DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_vi_venda FOREIGN KEY (venda_id) REFERENCES venda(id) ON DELETE CASCADE,
  CONSTRAINT fk_vi_produto FOREIGN KEY (produto_id) REFERENCES produto(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

/* ==============================
   2 - Inserção de dados (INSERT)
   Pelo menos 20-30 inserts para povoar o banco
   ============================== */

-- Marcas
INSERT INTO marca (nome, pais_origem) VALUES
('Ray-Ban','Itália'),
('Oakley','Estados Unidos'),
('Chilli Beans','Brasil');

-- Fornecedores
INSERT INTO fornecedor (nome, telefone, email, cidade) VALUES
('Fornecedora Óptica LTDA','(11) 2222-3333','contato@fornecedoraoptica.com','São Paulo'),
('Lentes e Cia','(21) 98888-7777','vendas@lentesecia.com','Rio de Janeiro');

-- Funcionários
INSERT INTO funcionario (nome, cargo, salario, telefone, data_contratacao) VALUES
('Mariana Silva','Atendimento',2500.00,'(11) 99999-1111','2023-02-15'),
('Carlos Souza','Optometrista',3800.00,'(11) 98888-2222','2022-08-01');

-- Clientes
INSERT INTO cliente (nome, cpf, telefone, email, data_nascimento) VALUES
('Ana Pereira','123.456.789-00','(11) 91111-0000','ana.pereira@gmail.com','1988-05-12'),
('João Alves','987.654.321-99','(21) 92222-0000','joao.alves@hotmail.com','1975-11-03'),
('Marcos Lima','111.222.333-44','(31) 93333-0000','marcos.lima@yahoo.com','1992-07-20');

-- Produtos
INSERT INTO produto (nome, descricao, preco, qtd_estoque, marca_id, fornecedor_id) VALUES
('Armação metálica clássica','Armação unissex, metal leve',199.90,10,1,1),
('Lente monofocal antirreflexo','Lente monofocal com tratamento anti-reflexo',350.00,25,2,2),
('Óculos de sol Ray-Ban RB3025','Piloto clássico',599.00,5,1,1),
('Kit limpeza de lentes','Pano + spray',29.90,50,NULL,2),
('Óculos de grau infantil','Armação plástica colorida',149.00,8,3,1);

-- Prescrições
INSERT INTO prescricao (cliente_id, data_prescricao, esf_od, esf_oe, cil_od, cil_oe, observacoes) VALUES
(1,'2024-03-10',-1.25,-1.00,-0.50,-0.25,'Prescrição para uso diário'),
(2,'2023-10-02',-2.00,-1.75,-0.75,-0.50,'Levar para montagem');

-- Vendas (exemplo com itens)
INSERT INTO venda (cliente_id, funcionario_id, data_venda, total) VALUES
(1,1,'2024-04-01 10:30:00',748.90),
(3,2,'2024-05-15 15:20:00',179.90);

-- Itens da Venda (assumindo ids das vendas criadas acima)
INSERT INTO venda_item (venda_id, produto_id, quantidade, preco_unitario) VALUES
(1,3,1,599.00),
(1,4,1,29.90),
(1,2,1,120.00), -- exemplo de ajuste de preço na venda
(2,5,1,149.00),
(2,4,1,29.90);

/* ==============================
   3 - Consultas (SELECT) - pelo menos 5 consultas com WHERE, ORDER BY, LIMIT, JOIN
   ============================== */

-- 1) Listar clientes com número de vendas e total gasto (JOIN + GROUP BY)
SELECT c.id, c.nome, c.email, COUNT(v.id) AS num_vendas, COALESCE(SUM(v.total),0) AS total_gasto
FROM cliente c
LEFT JOIN venda v ON v.cliente_id = c.id
GROUP BY c.id, c.nome, c.email
ORDER BY total_gasto DESC;

-- 2) Produtos com estoque baixo (qtd_estoque < 10)
SELECT id, nome, qtd_estoque
FROM produto
WHERE qtd_estoque < 10
ORDER BY qtd_estoque ASC;

-- 3) Detalhes de uma venda (JOIN entre venda, venda_item e produto)
SELECT v.id AS venda_id, v.data_venda, c.nome AS cliente, f.nome AS funcionario,
       p.nome AS produto, vi.quantidade, vi.preco_unitario, (vi.quantidade * vi.preco_unitario) AS subtotal
FROM venda v
LEFT JOIN cliente c ON c.id = v.cliente_id
LEFT JOIN funcionario f ON f.id = v.funcionario_id
JOIN venda_item vi ON vi.venda_id = v.id
JOIN produto p ON p.id = vi.produto_id
WHERE v.id = 1;

-- 4) Buscar prescrição mais recente de um cliente (ORDER BY + LIMIT)
SELECT * FROM prescricao WHERE cliente_id = 1 ORDER BY data_prescricao DESC LIMIT 1;

-- 5) Produtos por fornecedor com soma de estoque (JOIN + GROUP BY)
SELECT f.nome AS fornecedor, p.nome AS produto, p.qtd_estoque
FROM produto p
LEFT JOIN fornecedor f ON f.id = p.fornecedor_id
ORDER BY f.nome, p.nome;

/* ==============================
   4 - Manipulação: UPDATE e DELETE
   Incluir ao menos 3 UPDATEs e 3 DELETEs com condições
   ============================== */

-- UPDATE 1: corrigir preço de um produto
UPDATE produto SET preco = 120.00 WHERE id = 2;

-- UPDATE 2: aumentar estoque ao receber nova remessa
UPDATE produto SET qtd_estoque = qtd_estoque + 20 WHERE fornecedor_id = 2;

-- UPDATE 3: promover funcionário
UPDATE funcionario SET cargo = 'Gerente de Loja', salario = 4500.00 WHERE nome = 'Mariana Silva';

-- DELETE 1: remover uma venda de teste (apenas se não quiser manter histórico)
DELETE FROM venda WHERE id = 9999; -- não existe, exemplo seguro

-- DELETE 2: remover cliente inativo sem vendas (exemplo usando subquery)
DELETE FROM cliente WHERE id NOT IN (SELECT DISTINCT cliente_id FROM venda WHERE cliente_id IS NOT NULL);

-- DELETE 3: remover fornecedor sem produtos associados
DELETE FROM fornecedor WHERE id NOT IN (SELECT DISTINCT fornecedor_id FROM produto WHERE fornecedor_id IS NOT NULL);
