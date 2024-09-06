-- 1. Criar uma sequence chamada id_seq que começa em 1 e incrementa de 1 em 1.
CREATE SEQUENCE id_seq INCREMENT 1 START 1;

-- 2. Utilize a sequence criada na questão 1 para fazer o incremento automático no campo id da tabela cliente. Conside a relação CLIENTE (id:integer (PK), nome:string, email:string)
CREATE table CLIENTE(
	id integer DEFAULT NEXTVAL('id_seq') PRIMARY KEY,
	nome VARCHAR(100),
	email VARCHAR(100)
);

-- 3. Inserir pelo menos 3 tuplas com valores da sequence na coluna id:
INSERT INTO CLIENTE (nome, email) VALUES ('Arthur', 'arthur@gmail'), ('Bruno', 'bruno@gmail'), ('Fernando', 'fernando@gmail');

-- 4. Verificar os registros inseridos na tabela cliente:
SELECT * FROM CLIENTE;

-- 5. Considerar a tabela pedido abaixo e a sequence pedidoid_seq para inserir dados na tabela utilizando pedidoid_seq no comando de insert.

    CREATE TABLE pedido (
        id INTEGER PRIMARY KEY,
        cliente_id INTEGER,
        preco NUMERIC(10,2),
        data timestamp,
        FOREIGN KEY (cliente_id) REFERENCES cliente (id)
    );

    CREATE SEQUENCE pedidoid_seq;

    -- Certifique-se de que a tabela "cliente" já contenha registros com IDs correspondentes antes de inserir dados na tabela "pedido".

    -- Inserir dados na tabela pedido utilizando a sequence id_seq:
INSERT INTO pedido (id, cliente_id, preco) VALUES (nextval('pedidoid_seq'), 1, 50.00), (nextval('pedidoid_seq'), 2, 25.00), (nextval('pedidoid_seq'), 3, 100.00);

-- 5. Obter o próximo valor da sequence id_seq sem realmente inserir um registro na tabela:
SELECT nextval('id_seq');

-- 6. Alterar o valor atual da sequence id_seq para 30:
SELECT setval('id_seq', 30);

-- 7. Reinicie a sequence pedidoid_seq com o valor inicial 100.
ALTER SEQUENCE pedidoid_seq RESTART WITH 100;

-- 8. Reiniciar a sequence id_seq para o seu valor inicial:
ALTER SEQUENCE id_seq RESTART;

-- 9. Definir um valor mínimo de 1 e um valor máximo de 1000 para a sequence id_seq:
ALTER SEQUENCE id_seq MINVALUE 1 MAXVALUE 1000;

-- 10. Criar a tabela pagamento com uma coluna idpagamento que gera valores automaticamente (utilize SERIAL).
-- Considere a relação pagamento (idpagamento(PK):integer, descricao:string, pedido_id:integer(FK))
CREATE TABLE PAGAMENTO(
	idpagamento serial PRIMARY KEY,
	descricao varchar(100),
	pedido_id integer,
	FOREIGN KEY (pedido_id) REFERENCES pedido(id)
);

-- 11. Obter o valor atual da sequence gerada em pagamento.idpagamento sem avançá-la (Certifique-se de que a sequência foi criada corretamente):
SELECT currval('pagamento_idpagamento_seq');

-- 12. Inserir pelo menos 3 tuplas na tabela pagamento:
INSERT INTO pagamento (descricao, pedido_id) VALUES ('aaaaa', 1),('bbbbb', 2),('ccccc', 3);
