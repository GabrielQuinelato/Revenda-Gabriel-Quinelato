SELECT * 
FROM cliente 
WHERE nome LIKE 'João%';

--Essa consulta traz todos os clientes cujo nome começa com "João".--

EXPLAIN SELECT * 
FROM produto 
WHERE nome LIKE '%Livro%';

--Aqui você deve tirar o print do plano de execução exibido pelo PostgreSQL.
--O esperado é que ele faça um "Seq Scan" (varredura sequencial na tabela), pois ainda não há índice.

CREATE INDEX idx_produto_nome ON produto (nome);

EXPLAIN SELECT * 
FROM produto 
WHERE nome LIKE '%Livro%';

--Agora, dependendo do PostgreSQL, pode aparecer "Index Scan" (se o filtro permitir aproveitamento do índice) ou continuar como "Seq Scan" (se o uso de % no início do LIKE impedir o índice).
--Diferença: com o índice, consultas que filtram por prefixo (ex: LIKE 'Livro%') ficam muito mais rápidas.

ALTER TABLE cliente 
ALTER COLUMN telefone TYPE INT USING telefone::INT;

--Se todos os telefones estiverem em formato apenas numérico, vai funcionar.
--Se tiver hífen, espaços ou nulos, pode dar erro de conversão.

ALTER TABLE produto 
ALTER COLUMN estoque TYPE VARCHAR(10);


CREATE USER joaofrancisco WITH PASSWORD '12345';
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO joaofrancisco;

CREATE USER colega WITH PASSWORD '12345';
GRANT SELECT ON produto TO colega;

--INSERT, UPDATE ou DELETE → dará erro de permissão.
--SELECT na tabela produto → funciona.
--SELECT em outras tabelas → erro de permissão.
--Isso deve ser registrado nos prints da sua atividade.

-- INNER
SELECT p.pedido_id, c.nome 
FROM pedido p
INNER JOIN cliente c ON p.cliente_id = c.cliente_id;

-- LEFT
SELECT p.pedido_id, c.nome 
FROM pedido p
LEFT JOIN cliente c ON p.cliente_id = c.cliente_id;

-- RIGHT
SELECT p.pedido_id, c.nome 
FROM pedido p
RIGHT JOIN cliente c ON p.cliente_id = c.cliente_id;

-- INNER
SELECT p.pedido_id, pg.metodo, pg.valor
FROM pedido p
INNER JOIN pagamento pg ON p.pedido_id = pg.pedido_id;

-- LEFT
SELECT p.pedido_id, pg.metodo, pg.valor
FROM pedido p
LEFT JOIN pagamento pg ON p.pedido_id = pg.pedido_id;

-- RIGHT
SELECT p.pedido_id, pg.metodo, pg.valor
FROM pedido p
RIGHT JOIN pagamento pg ON p.pedido_id = pg.pedido_id;

-- INNER
SELECT pr.nome, pp.quantidade
FROM produto pr
INNER JOIN pedido_produto pp ON pr.produto_id = pp.produto_id;

-- LEFT
SELECT pr.nome, pp.quantidade
FROM produto pr
LEFT JOIN pedido_produto pp ON pr.produto_id = pp.produto_id;

-- RIGHT
SELECT pr.nome, pp.quantidade
FROM produto pr
RIGHT JOIN pedido_produto pp ON pr.produto_id = pp.produto_id;

-- INNER
SELECT f.nome AS fornecedor, pr.nome AS produto
FROM fornecedor f
INNER JOIN produto pr ON f.fornecedor_id = pr.produto_id; -- Exemplo fictício, ajuste se houver FK

-- LEFT
SELECT f.nome AS fornecedor, pr.nome AS produto
FROM fornecedor f
LEFT JOIN produto pr ON f.fornecedor_id = pr.produto_id;

-- RIGHT
SELECT f.nome AS fornecedor, pr.nome AS produto
FROM fornecedor f
RIGHT JOIN produto pr ON f.fornecedor_id = pr.produto_id;

--Aqui a ligação é fictícia (não criamos FK direta). Pode-se criar uma tabela produto_fornecedor para representar isso corretamente.

UPDATE cliente SET email = NULL WHERE cliente_id IN (2,4,6);
UPDATE produto SET codigo = NULL WHERE produto_id IN (3,5,7);

--No INNER JOIN, os registros com valores NULL em colunas usadas na condição de junção não aparecem.
--No LEFT JOIN, os registros da tabela da esquerda aparecem mesmo com NULL (a parte da direita vem vazia).
--No RIGHT JOIN, o contrário.
--Esse comportamento deve ser destacado no relatório.
