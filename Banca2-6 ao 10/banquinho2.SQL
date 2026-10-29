
CREATE DATABASE IF NOT EXISTS interclasse
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE interclasse;

-- Para recriar do zero, execute antes:
-- DROP DATABASE IF EXISTS interclasse;

CREATE TABLE turmas (
    id_turma INT AUTO_INCREMENT,
    codigo VARCHAR(10) NOT NULL,
    serie INT NOT NULL,
    turno VARCHAR(10) NOT NULL,
    qtd_alunos INT NOT NULL,
    representante VARCHAR(100) NULL,
    CONSTRAINT pk_turmas PRIMARY KEY (id_turma),
    CONSTRAINT uq_turmas_codigo UNIQUE (codigo),
    CONSTRAINT ck_turmas_serie CHECK (serie BETWEEN 1 AND 3),
    CONSTRAINT ck_turmas_turno
        CHECK (turno IN ('MANHA', 'TARDE', 'NOITE'))
);

CREATE TABLE modalidades (
    id_modalidade INT AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    jogadores_por_time INT NOT NULL,
    CONSTRAINT pk_modalidades PRIMARY KEY (id_modalidade),
    CONSTRAINT uq_modalidades_nome UNIQUE (nome),
    CONSTRAINT ck_modalidades_jogadores
        CHECK (jogadores_por_time > 0)
);

INSERT INTO turmas
    (codigo, serie, turno, qtd_alunos, representante)
VALUES
    ('1A', 1, 'MANHA', 35, 'Lucas Martins'),
    ('2B', 2, 'MANHA', 32, 'Beatriz Alves'),
    ('3A', 3, 'TARDE', 30, 'Gabriel Rocha'),
    ('3C', 3, 'NOITE', 28, NULL);

INSERT INTO modalidades (nome, jogadores_por_time)
VALUES
    ('Futsal', 5),
    ('Vôlei', 6),
    ('Basquete', 5),
    ('Handebol', 7);

CREATE TABLE equipes (
    id_equipe INT AUTO_INCREMENT,
    nome VARCHAR(60) NOT NULL,
    cor_uniforme VARCHAR(30) NOT NULL DEFAULT 'BRANCO',
    id_turma INT NOT NULL,
    id_modalidade INT NOT NULL,
    CONSTRAINT pk_equipes PRIMARY KEY (id_equipe),
    CONSTRAINT uq_equipes_nome UNIQUE (nome),
    CONSTRAINT uq_equipes_turma_modalidade
        UNIQUE (id_turma, id_modalidade),
    CONSTRAINT fk_equipes_turmas
        FOREIGN KEY (id_turma) REFERENCES turmas (id_turma),
    CONSTRAINT fk_equipes_modalidades
        FOREIGN KEY (id_modalidade) REFERENCES modalidades (id_modalidade)
);

INSERT INTO equipes
    (nome, cor_uniforme, id_turma, id_modalidade)
VALUES
    ('Leões do 1A', 'AZUL', 1, 1),
    ('Tubarões do 2B', 'VERMELHO', 2, 1),
    ('Falcões do 3A', DEFAULT, 3, 2),
    ('Panteras do 3C', 'PRETO', 4, 2);

CREATE TABLE jogadores (
    id_jogador INT AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    data_nascimento DATE NOT NULL,
    numero_camisa INT NOT NULL,
    posicao VARCHAR(30) NULL,
    capitao VARCHAR(3) NOT NULL DEFAULT 'NAO',
    id_equipe INT NOT NULL,
    CONSTRAINT pk_jogadores PRIMARY KEY (id_jogador),
    CONSTRAINT ck_jogadores_camisa
        CHECK (numero_camisa BETWEEN 1 AND 99),
    CONSTRAINT ck_jogadores_capitao
        CHECK (capitao IN ('SIM', 'NAO')),
    CONSTRAINT uq_jogadores_equipe_camisa
        UNIQUE (id_equipe, numero_camisa),
    CONSTRAINT fk_jogadores_equipes
        FOREIGN KEY (id_equipe) REFERENCES equipes (id_equipe)
);

INSERT INTO jogadores
    (nome, data_nascimento, numero_camisa, posicao, capitao, id_equipe)
VALUES
    ('Lucas Martins', STR_TO_DATE('12/04/2010', '%d/%m/%Y'), 10, 'PIVÔ', 'SIM', 1),
    ('Enzo Ferreira', STR_TO_DATE('30/09/2009', '%d/%m/%Y'), 7, 'ALA', 'NAO', 2),
    ('Sofia Andrade', '2008-06-05', 9, 'LEVANTADORA', 'SIM', 3),
    ('Laura Pereira', '2008-12-19', 4, NULL, DEFAULT, 4);

CREATE TABLE arbitros (
    id_arbitro INT AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    celular VARCHAR(15) NOT NULL,
    categoria VARCHAR(20) NOT NULL DEFAULT 'ESCOLAR',
    CONSTRAINT pk_arbitros PRIMARY KEY (id_arbitro),
    CONSTRAINT uq_arbitros_celular UNIQUE (celular),
    CONSTRAINT ck_arbitros_categoria
        CHECK (categoria IN ('ESCOLAR', 'FEDERADO'))
);

INSERT INTO arbitros (nome, celular, categoria)
VALUES
    ('Paulo Henrique', '(35) 99101-0001', 'FEDERADO'),
    ('Renata Lopes', '(35) 99101-0002', DEFAULT),
    ('Diego Santos', '(35) 99101-0003', 'ESCOLAR'),
    ('Fernanda Lima', '(35) 99101-0004', 'FEDERADO');

CREATE TABLE partidas (
    id_partida INT AUTO_INCREMENT,
    data_hora DATETIME NOT NULL,
    local_partida VARCHAR(80) NOT NULL DEFAULT 'QUADRA PRINCIPAL',
    id_equipe_casa INT NOT NULL,
    id_equipe_visitante INT NOT NULL,
    id_arbitro INT NOT NULL,
    CONSTRAINT pk_partidas PRIMARY KEY (id_partida),
    CONSTRAINT ck_partidas_equipes
        CHECK (id_equipe_casa <> id_equipe_visitante),
    CONSTRAINT fk_partidas_equipe_casa
        FOREIGN KEY (id_equipe_casa) REFERENCES equipes (id_equipe),
    CONSTRAINT fk_partidas_equipe_visitante
        FOREIGN KEY (id_equipe_visitante) REFERENCES equipes (id_equipe),
    CONSTRAINT fk_partidas_arbitros
        FOREIGN KEY (id_arbitro) REFERENCES arbitros (id_arbitro)
);

INSERT INTO partidas
    (data_hora, local_partida,
     id_equipe_casa, id_equipe_visitante, id_arbitro)
VALUES
    ('2026-11-09 08:00:00', DEFAULT, 1, 2, 1),
    ('2026-11-09 09:30:00', 'QUADRA COBERTA', 3, 4, 2),
    ('2026-11-16 08:00:00', DEFAULT, 2, 1, 3),
    ('2026-11-16 09:30:00', 'QUADRA COBERTA', 4, 3, 4);

ALTER TABLE partidas
ADD COLUMN placar_casa INT NULL,
ADD COLUMN placar_visitante INT NULL;

ALTER TABLE partidas
ADD CONSTRAINT ck_partidas_placar
CHECK (
    (placar_casa IS NULL OR placar_casa >= 0)
    AND
    (placar_visitante IS NULL OR placar_visitante >= 0)
);

ALTER TABLE partidas
ADD COLUMN situacao VARCHAR(15) NOT NULL DEFAULT 'AGENDADA';

UPDATE partidas
SET placar_casa = 3,
    placar_visitante = 2,
    situacao = 'ENCERRADA'
WHERE id_partida = 1;

UPDATE partidas
SET placar_casa = 2,
    placar_visitante = 1,
    situacao = 'ENCERRADA'
WHERE id_partida = 2;

UPDATE turmas
SET representante = 'Laura Pereira'
WHERE codigo = '3C';

SELECT * FROM turmas;
SELECT * FROM modalidades;
SELECT * FROM equipes;
SELECT * FROM jogadores;
SELECT * FROM arbitros;
SELECT * FROM partidas;

SELECT codigo, turno
FROM turmas
WHERE serie = 3;

SELECT nome, cor_uniforme
FROM equipes
WHERE id_modalidade = 1;

SELECT nome
FROM equipes
ORDER BY nome ASC;

SELECT nome, numero_camisa
FROM jogadores
WHERE id_equipe = 1;

SELECT nome, posicao
FROM jogadores
WHERE capitao = 'SIM';

SELECT nome
FROM jogadores
WHERE posicao IS NULL;

SELECT nome, data_nascimento
FROM jogadores
ORDER BY data_nascimento ASC;

SELECT id_partida, data_hora
FROM partidas
WHERE local_partida = 'QUADRA COBERTA';

SELECT *
FROM partidas
WHERE id_equipe_casa = 1 OR id_equipe_visitante = 1;

SELECT id_partida, data_hora
FROM partidas
WHERE placar_casa IS NULL OR placar_visitante IS NULL;

SELECT *
FROM partidas
WHERE situacao = 'ENCERRADA'
ORDER BY data_hora ASC;

DESCRIBE partidas;
SHOW CREATE TABLE partidas;

-- Testes inválidos: execute um por vez, separadamente.

-- INSERT INTO turmas
-- (codigo, serie, turno, qtd_alunos, representante)
-- VALUES ('5A', 5, 'MANHA', 35, 'Teste');

-- INSERT INTO turmas
-- (codigo, serie, turno, qtd_alunos, representante)
-- VALUES ('2C', 2, 'MADRUGADA', 30, 'Teste');

-- INSERT INTO modalidades (nome, jogadores_por_time)
-- VALUES ('Xadrez', 0);

-- INSERT INTO equipes
-- (nome, cor_uniforme, id_turma, id_modalidade)
-- VALUES ('Lobos do 1A', 'VERDE', 1, 1);

-- INSERT INTO equipes
-- (nome, cor_uniforme, id_turma, id_modalidade)
-- VALUES ('Águias do 2B', 'AZUL', 2, 10);

-- INSERT INTO equipes
-- (nome, cor_uniforme, id_turma, id_modalidade)
-- VALUES ('Leões do 1A', 'VERDE', 1, 3);

-- INSERT INTO jogadores
-- (nome, data_nascimento, numero_camisa, posicao, capitao, id_equipe)
-- VALUES ('Teste 100', '2009-01-01', 100, 'ALA', 'NAO', 1);

-- INSERT INTO jogadores
-- (nome, data_nascimento, numero_camisa, posicao, capitao, id_equipe)
-- VALUES ('Teste Camisa', '2009-01-01', 10, 'ALA', 'NAO', 1);

-- INSERT INTO jogadores
-- (nome, data_nascimento, numero_camisa, posicao, capitao, id_equipe)
-- VALUES ('Teste Capitão', '2009-01-01', 20, 'ALA', 'S', 1);

-- INSERT INTO jogadores
-- (nome, data_nascimento, numero_camisa, posicao, capitao, id_equipe)
-- VALUES ('Teste Equipe', '2009-01-01', 21, 'ALA', 'NAO', 30);

-- INSERT INTO partidas
-- (data_hora, local_partida, id_equipe_casa, id_equipe_visitante, id_arbitro)
-- VALUES ('2026-11-20 08:00:00', DEFAULT, 1, 1, 1);

-- INSERT INTO partidas
-- (data_hora, local_partida, id_equipe_casa, id_equipe_visitante, id_arbitro)
-- VALUES ('2026-11-20 09:00:00', DEFAULT, 1, 2, 20);

-- INSERT INTO arbitros (nome, celular, categoria)
-- VALUES ('Árbitro Teste', '(35) 99101-9999', 'AMADOR');

-- UPDATE partidas
-- SET placar_casa = -1
-- WHERE id_partida = 3;

-- DELETE FROM equipes WHERE id_equipe = 1;

-- DELETE FROM modalidades WHERE id_modalidade = 1;
