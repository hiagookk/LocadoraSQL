DROP DATABASE IF EXISTS LocadoraDB;
CREATE DATABASE LocadoraDB;
USE LocadoraDB;

-- TABELAS
CREATE TABLE Locadora (
    id_locadora INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200),
    telefone VARCHAR(15)
);

CREATE TABLE Categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE Filme (
    id_filme INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    quantidade INT NOT NULL,
    id_categoria INT NOT NULL,
    id_locadora INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria),
    FOREIGN KEY (id_locadora) REFERENCES Locadora(id_locadora)
);

CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(15)
);

CREATE TABLE Locacao (
    id_locacao INT AUTO_INCREMENT PRIMARY KEY,
    data_locacao DATE NOT NULL,
    data_devolucao DATE,
    id_cliente INT NOT NULL,
    id_locadora INT NOT NULL,
    id_filme INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_locadora) REFERENCES Locadora(id_locadora),
    FOREIGN KEY (id_filme) REFERENCES Filme(id_filme)
);

-- INSERÇÃO DE DADOS
INSERT INTO Locadora (nome, endereco, telefone) VALUES
('Locadora Central', 'Rua A, 123', '1111-1111'),
('CineTop', 'Av. B, 456', '2222-2222');

INSERT INTO Categoria (nome) VALUES
('Ação'), ('Comédia'), ('Drama');

INSERT INTO Filme (nome, quantidade, id_categoria, id_locadora) VALUES
('Velozes e Furiosos', 5, 1, 1),
('Se Beber Não Case', 3, 2, 1),
('O Poderoso Chefão', 2, 3, 2),
('Homem-Aranha', 4, 1, 2);

INSERT INTO Cliente (nome, cpf, telefone) VALUES
('Hiago Gregorini', '123.456.789-00', '3333-3333'),
('Cibele Hipolito', '987.654.321-00', '4444-4444'),
('Pedro Alexandre', '111.222.333-44', '5555-5555');

INSERT INTO Locacao (data_locacao, data_devolucao, id_cliente, id_locadora, id_filme) VALUES
('2025-09-20', '2025-09-25', 1, 1, 1),
('2025-09-22', NULL, 2, 2, 3),
('2025-09-23', NULL, 3, 2, 4);

-- CONSULTAS DE EXEMPLO
-- todos os filmes e suas categorias
SELECT f.nome AS Filme, c.nome AS Categoria, f.quantidade
FROM Filme f
JOIN Categoria c ON f.id_categoria = c.id_categoria;

-- locações com cliente e filme
SELECT l.id_locacao, cl.nome AS Cliente, f.nome AS Filme, l.data_locacao, l.data_devolucao
FROM Locacao l
JOIN Cliente cl ON l.id_cliente = cl.id_cliente
JOIN Filme f ON l.id_filme = f.id_filme;

-- filmes disponíveis em cada locadora
SELECT lo.nome AS Locadora, f.nome AS Filme, f.quantidade
FROM Filme f
JOIN Locadora lo ON f.id_locadora = lo.id_locadora;

-- histórico de locações de um cliente específico
SELECT cl.nome AS Cliente, f.nome AS Filme, l.data_locacao, l.data_devolucao
FROM Locacao l
JOIN Cliente cl ON l.id_cliente = cl.id_cliente
JOIN Filme f ON l.id_filme = f.id_filme
WHERE cl.nome = 'Cibele Hipolito';

-- EXEMPLO DE UPDATE
-- Atualizar a quantidade de filmes do "Homem-Aranha" na locadora CineTop
UPDATE Filme
SET quantidade = 5
WHERE nome = 'Homem-Aranha' AND id_locadora = (
    SELECT id_locadora FROM Locadora WHERE nome = 'CineTop'
);

-- Atualizar a data de devolução de uma locação
UPDATE Locacao
SET data_devolucao = '2025-09-28'
WHERE id_locacao = 2;

-- quantidade do filme Homem-Aranha na locadora CineTop apos o update
SELECT f.nome AS Filme, f.quantidade, lo.nome AS Locadora
FROM Filme f
JOIN Locadora lo ON f.id_locadora = lo.id_locadora
WHERE f.nome = 'Homem-Aranha' AND lo.nome = 'CineTop';

-- histórico de locações de um cliente específico apos o update
SELECT cl.nome AS Cliente, f.nome AS Filme, l.data_locacao, l.data_devolucao
FROM Locacao l
JOIN Cliente cl ON l.id_cliente = cl.id_cliente
JOIN Filme f ON l.id_filme = f.id_filme
WHERE cl.nome = 'Cibele Hipolito';
