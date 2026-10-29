
-- =====================================================
-- BANCO 1: CLINICA VETERINARIA
-- ATIVIDADES 1 A 5
-- =====================================================

-- ATENÇÃO: descomente a linha abaixo somente se quiser
-- apagar o banco anterior e recriar tudo do zero.
-- DROP DATABASE IF EXISTS clinica_veterinaria;

-- =====================================================
-- ATIVIDADE 1: BANCO DE DADOS E TUTORES
-- =====================================================

-- DDL: cria o banco de dados.
CREATE DATABASE IF NOT EXISTS clinica_veterinaria
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- DDL: seleciona o banco.
USE clinica_veterinaria;

-- DQL: confirma o banco ativo.
SELECT DATABASE();

-- DDL: cria a tabela tutores.
CREATE TABLE tutores (
    id_tutor INT AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    cpf VARCHAR(14) NOT NULL,
    celular VARCHAR(15) NOT NULL,
    email VARCHAR(150) NULL,
    data_nascimento DATE NOT NULL,
    data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_tutores PRIMARY KEY (id_tutor),
    CONSTRAINT uq_tutores_cpf UNIQUE (cpf),
    CONSTRAINT uq_tutores_email UNIQUE (email)
);

-- DQL: mostra as tabelas e a estrutura de tutores.
SHOW TABLES;
DESCRIBE tutores;


-- =====================================================
-- ATIVIDADE 2: CADASTRO DOS TUTORES
-- =====================================================

-- DML: cadastra os quatro tutores.
INSERT INTO tutores
    (nome, cpf, celular, email, data_nascimento)
VALUES
    ('Carla Mendes', '111.222.333-44', '(35) 99811-2233',
     'carla@email.com', STR_TO_DATE('15/03/1985', '%d/%m/%Y')),
    ('Rafael Costa', '222.333.444-55', '(35) 99722-3344',
     'rafael@email.com', STR_TO_DATE('02/11/1990', '%d/%m/%Y')),
    ('Juliana Prado', '333.444.555-66', '(35) 99633-4455',
     NULL, '1978-07-28'),
    ('Marcos Ribeiro', '444.555.666-77', '(35) 99544-5566',
     'marcos@email.com', '2000-01-10');

-- DQL: todos os tutores.
SELECT * FROM tutores;

-- DQL: nome e celular.
SELECT nome, celular
FROM tutores;

-- DQL: tutores sem e-mail.
SELECT nome, email
FROM tutores
WHERE email IS NULL;

-- DQL: nome e nascimento em ordem alfabética.
SELECT nome, data_nascimento
FROM tutores
ORDER BY nome ASC;

-- TESTE 1: CPF duplicado (deve falhar).
-- INSERT INTO tutores
-- (nome, cpf, celular, email, data_nascimento)
-- VALUES ('Teste CPF', '111.222.333-44', '(35) 99999-0001',
--         'teste_cpf@email.com', '1995-01-01');

-- TESTE 2: nome NULL (deve falhar).
-- INSERT INTO tutores
-- (nome, cpf, celular, email, data_nascimento)
-- VALUES (NULL, '555.666.777-88', '(35) 99999-0002',
--         'teste_nome@email.com', '1995-01-01');

-- TESTE 3: e-mail duplicado (deve falhar).
-- INSERT INTO tutores
-- (nome, cpf, celular, email, data_nascimento)
-- VALUES ('Teste Email', '555.666.777-99', '(35) 99999-0003',
--         'carla@email.com', '1995-01-01');


-- =====================================================
-- ATIVIDADE 3: ESPECIES E ANIMAIS
-- =====================================================

-- A tabela especies deve existir antes de animais,
-- pois animais depende dela e também da tabela tutores.

-- DDL: cria a tabela especies.
CREATE TABLE especies (
    id_especie INT AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    CONSTRAINT pk_especies PRIMARY KEY (id_especie),
    CONSTRAINT uq_especies_nome UNIQUE (nome)
);

-- DDL: cria a tabela animais.
CREATE TABLE animais (
    id_animal INT AUTO_INCREMENT,
    nome VARCHAR(80) NOT NULL,
    sexo CHAR(1) NOT NULL,
    data_nascimento DATE NULL,
    peso_kg DECIMAL(5,2) NOT NULL,
    castrado VARCHAR(3) NOT NULL DEFAULT 'NAO',
    id_tutor INT NOT NULL,
    id_especie INT NOT NULL,
    CONSTRAINT pk_animais PRIMARY KEY (id_animal),
    CONSTRAINT fk_animais_tutores
        FOREIGN KEY (id_tutor)
        REFERENCES tutores (id_tutor),
    CONSTRAINT fk_animais_especies
        FOREIGN KEY (id_especie)
        REFERENCES especies (id_especie)
);

-- DML: cadastra as quatro espécies.
INSERT INTO especies (nome)
VALUES
    ('Cão'),
    ('Gato'),
    ('Coelho'),
    ('Calopsita');

-- DML: cadastra os quatro animais.
INSERT INTO animais
    (nome, sexo, data_nascimento, peso_kg,
     castrado, id_tutor, id_especie)
VALUES
    ('Thor', 'M', '2020-05-10', 28.50, 'SIM', 1, 1),
    ('Mia', 'F', '2021-08-22', 4.20, 'SIM', 2, 2),
    ('Pipoca', 'F', '2023-02-14', 1.80, DEFAULT, 3, 3),
    ('Kiwi', 'M', NULL, 0.09, 'NAO', 4, 4);

-- DQL: todas as espécies.
SELECT * FROM especies;

-- DQL: todos os animais.
SELECT * FROM animais;

-- DQL: animais do tutor de id 1.
SELECT nome, peso_kg
FROM animais
WHERE id_tutor = 1;

-- DQL: animais do mais pesado para o mais leve.
SELECT nome, peso_kg
FROM animais
ORDER BY peso_kg DESC;

-- TESTE 1: tutor inexistente (deve falhar).
-- INSERT INTO animais
-- (nome, sexo, data_nascimento, peso_kg, castrado, id_tutor, id_especie)
-- VALUES ('Teste', 'M', NULL, 1.00, 'NAO', 99, 1);

-- TESTE 2: espécie inexistente (deve falhar).
-- INSERT INTO animais
-- (nome, sexo, data_nascimento, peso_kg, castrado, id_tutor, id_especie)
-- VALUES ('Teste', 'F', NULL, 1.00, 'NAO', 1, 50);


-- =====================================================
-- ATIVIDADE 4: VETERINARIOS E ALTERACOES
-- =====================================================

-- DDL: cria a tabela veterinarios.
CREATE TABLE veterinarios (
    id_veterinario INT AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    crmv VARCHAR(20) NOT NULL,
    especialidade VARCHAR(60) NOT NULL DEFAULT 'CLINICA GERAL',
    data_admissao DATE NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_veterinarios PRIMARY KEY (id_veterinario),
    CONSTRAINT uq_veterinarios_crmv UNIQUE (crmv)
);

-- DML: cadastra Helena e André.
INSERT INTO veterinarios
    (nome, crmv, especialidade, data_admissao, salario)
VALUES
    ('Dra. Helena Torres', 'CRMV-MG 10234',
     'DERMATOLOGIA', '2019-03-01', 7800.00),
    ('Dr. André Nogueira', 'CRMV-MG 11876',
     'ORTOPEDIA', '2021-07-15', 8200.50);

-- DML: cadastra Patrícia omitindo a especialidade.
INSERT INTO veterinarios
    (nome, crmv, data_admissao, salario)
VALUES
    ('Dra. Patrícia Gomes', 'CRMV-MG 12450',
     '2023-02-06', 6500.00);

-- DML: cadastra Felipe usando DEFAULT.
INSERT INTO veterinarios
    (nome, crmv, especialidade, data_admissao, salario)
VALUES
    ('Dr. Felipe Araújo', 'CRMV-MG 13001',
     DEFAULT, '2024-08-19', 6100.00);

-- TESTE: CRMV duplicado (deve falhar).
-- Execute antes dos ALTER TABLE.
-- INSERT INTO veterinarios
-- (nome, crmv, especialidade, data_admissao, salario)
-- VALUES ('Veterinário Teste', 'CRMV-MG 10234',
--         DEFAULT, '2025-01-01', 5000.00);

-- DDL: adiciona o celular dos veterinários.
ALTER TABLE veterinarios
ADD COLUMN celular VARCHAR(15) NULL;

-- DDL: aumenta o tamanho da especialidade.
ALTER TABLE veterinarios
MODIFY COLUMN especialidade VARCHAR(80)
NOT NULL DEFAULT 'CLINICA GERAL';

-- DDL: renomeia salario para salario_mensal.
ALTER TABLE veterinarios
RENAME COLUMN salario TO salario_mensal;

-- DDL: adiciona CEP aos tutores depois de email.
ALTER TABLE tutores
ADD COLUMN cep VARCHAR(9) NULL AFTER email;

-- DML: atualiza os celulares usando a chave primária.
UPDATE veterinarios
SET celular = '(35) 98801-1001'
WHERE id_veterinario = 1;

UPDATE veterinarios
SET celular = '(35) 98801-1002'
WHERE id_veterinario = 2;

UPDATE veterinarios
SET celular = '(35) 98801-1003'
WHERE id_veterinario = 3;

UPDATE veterinarios
SET celular = '(35) 98801-1004'
WHERE id_veterinario = 4;

-- DML: atualiza os CEPs dos tutores.
UPDATE tutores
SET cep = '37550-001'
WHERE id_tutor = 1;

UPDATE tutores
SET cep = '37550-120'
WHERE id_tutor = 2;

UPDATE tutores
SET cep = '37550-245'
WHERE id_tutor = 3;

UPDATE tutores
SET cep = '37550-370'
WHERE id_tutor = 4;

-- DQL: confere as estruturas.
DESCRIBE veterinarios;
DESCRIBE tutores;

-- DQL: veterinários e suas especialidades.
SELECT nome, especialidade, celular
FROM veterinarios;

-- DQL: veterinários de clínica geral.
SELECT nome, salario_mensal
FROM veterinarios
WHERE especialidade = 'CLINICA GERAL';


-- =====================================================
-- ATIVIDADE 5: ATENDIMENTOS
-- =====================================================

-- DDL: cria a tabela atendimentos.
CREATE TABLE atendimentos (
    id_atendimento INT AUTO_INCREMENT,
    id_animal INT NOT NULL,
    id_veterinario INT NOT NULL,
    data_hora DATETIME NOT NULL,
    motivo VARCHAR(200) NOT NULL,
    valor DECIMAL(8,2) NOT NULL,
    situacao VARCHAR(20) NOT NULL DEFAULT 'AGENDADO',
    CONSTRAINT pk_atendimentos PRIMARY KEY (id_atendimento),
    CONSTRAINT fk_atendimentos_animais
        FOREIGN KEY (id_animal)
        REFERENCES animais (id_animal),
    CONSTRAINT fk_atendimentos_veterinarios
        FOREIGN KEY (id_veterinario)
        REFERENCES veterinarios (id_veterinario)
);

-- DML: cadastra os quatro atendimentos.
INSERT INTO atendimentos
    (id_animal, id_veterinario, data_hora, motivo, valor, situacao)
VALUES
    (1, 2, '2026-10-20 09:00:00',
     'Dor na pata traseira', 180.00, 'REALIZADO'),
    (2, 1, '2026-10-22 14:30:00',
     'Queda de pelos', 150.00, 'REALIZADO'),
    (3, 3, '2026-11-05 10:00:00',
     'Consulta de rotina', 95.00, DEFAULT),
    (4, 4, '2026-11-06 16:00:00',
     'Corte de unhas e check-up', 70.00, DEFAULT);

-- TESTE 1: animal inexistente (deve falhar).
-- INSERT INTO atendimentos
-- (id_animal, id_veterinario, data_hora, motivo, valor, situacao)
-- VALUES (50, 1, '2026-11-10 09:00:00', 'Teste', 50.00, DEFAULT);

-- TESTE 2: veterinário inexistente (deve falhar).
-- INSERT INTO atendimentos
-- (id_animal, id_veterinario, data_hora, motivo, valor, situacao)
-- VALUES (1, 20, '2026-11-10 10:00:00', 'Teste', 50.00, DEFAULT);

-- TESTE 3: excluir tutor relacionado (deve falhar).
-- DELETE FROM tutores WHERE id_tutor = 1;

-- TESTE 4: excluir animal com atendimento (deve falhar).
-- DELETE FROM animais WHERE id_animal = 1;

-- DML: atualiza a situação do atendimento 3.
UPDATE atendimentos
SET situacao = 'CONFIRMADO'
WHERE id_atendimento = 3;

-- DML: atualiza a situação do atendimento 4.
UPDATE atendimentos
SET situacao = 'CANCELADO'
WHERE id_atendimento = 4;

-- DQL: todos os atendimentos.
SELECT * FROM atendimentos;

-- DQL: atendimentos realizados.
SELECT motivo, data_hora
FROM atendimentos
WHERE situacao = 'REALIZADO';

-- DQL: atendimentos acima de 100.
SELECT motivo, valor
FROM atendimentos
WHERE valor > 100;

-- DQL: atendimentos em ordem cronológica.
SELECT id_atendimento, data_hora, situacao
FROM atendimentos
ORDER BY data_hora ASC;

-- DQL: mostra a definição da tabela atendimentos.
SHOW CREATE TABLE atendimentos;


-- =====================================================
-- CONFERENCIA FINAL: 4 REGISTROS EM CADA TABELA
-- =====================================================

SELECT * FROM tutores;
SELECT * FROM especies;
SELECT * FROM animais;
SELECT * FROM veterinarios;
SELECT * FROM atendimentos;
