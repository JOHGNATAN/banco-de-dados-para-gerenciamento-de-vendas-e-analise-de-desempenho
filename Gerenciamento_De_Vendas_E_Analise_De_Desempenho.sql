CREATE TABLE produtos (
  id INT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  preco DECIMAL(10, 2) NOT NULL
);

CREATE TABLE vendas (
  id INT PRIMARY KEY,
  produto_id INT NOT NULL,
  quantidade INT NOT NULL,
  data_venda DATE NOT NULL,
  FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

CREATE TABLE regioes (
  id INT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL
);

CREATE TABLE vendedores (
  id INT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  regiao_id INT NOT NULL,
  FOREIGN KEY (regiao_id) REFERENCES regioes(id)
);

CREATE TABLE vendas_vendedores (
  id INT PRIMARY KEY,
  venda_id INT NOT NULL,
  vendedor_id INT NOT NULL,
  FOREIGN KEY (venda_id) REFERENCES vendas(id),
  FOREIGN KEY (vendedor_id) REFERENCES vendedores(id)
);

INSERT INTO produtos (id, nome, preco) VALUES
(1, 'Camiseta', 29.99),
(2, 'Calça', 59.99),
(3, 'Tênis', 89.99),
(4, 'Boné', 19.99);

INSERT INTO vendas (id, produto_id, quantidade, data_venda) VALUES
(1, 1, 5, '2022-01-01'),
(2, 2, 3, '2022-01-02'),
(3, 3, 2, '2022-01-02'),
(4, 1, 2, '2022-01-03'),
(5, 4, 1, '2022-01-03');

INSERT INTO regioes (id, nome) VALUES
(1, 'Sul'),
(2, 'Sudeste'),
(3, 'Nordeste');

INSERT INTO vendedores (id, nome, regiao_id) VALUES
(1, 'João', 1),
(2, 'Maria', 2),
(3, 'José', 3);

INSERT INTO vendas_vendedores (id, venda_id, vendedor_id) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 2),
(4, 4, 1),
(5, 5, 3);

# Vendas por região

SELECT r.nome AS regiao, SUM(v.quantidade * p.preco) AS total_vendas
FROM vendas v
JOIN produtos p ON v.produto_id = p.id
JOIN vendas_vendedores vv ON v.id = vv.venda_id
JOIN vendedores ve ON vv.vendedor_id = ve.id
JOIN regioes r ON ve.regiao_id = r.id
GROUP BY r.nome;

# Vendas por produto

SELECT p.nome AS produto, SUM(v.quantidade) AS total_vendas
FROM vendas v
JOIN produtos p ON v.produto_id = p.id
GROUP BY p.nome;

# TOTAL de Venda no mês 

SELECT DATE_FORMAT(data_venda, '%Y-%m') AS mes_venda, SUM(quantidade * preco) AS total_vendas
FROM vendas v
JOIN produtos p ON v.produto_id = p.id
GROUP BY mes_venda;

# vendas totais de cada produto em cada região, em cada mês/ano

SELECT r.nome AS regiao, p.nome AS produto, DATE_FORMAT(v.data_venda, '%y-%m') AS mes_venda, SUM(v.quantidade * p.preco) AS total_vendas
FROM vendas v
JOIN produtos p ON v.produto_id = p.id
JOIN vendas_vendedores vv ON v.id = vv.venda_id
JOIN vendedores ve ON vv.vendedor_id = ve.id
JOIN regioes r ON ve.regiao_id = r.id
GROUP BY r.nome, p.nome, mes_venda;

