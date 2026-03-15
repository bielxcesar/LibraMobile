CREATE DATABASE LibraMobile;
USE LibraMobile; 

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    cpf CHAR(11) UNIQUE NOT NULL,
    telefone VARCHAR(15),
    nascimento DATE,
    password_hash VARCHAR(255) NOT NULL, 
    cargo VARCHAR(15) CHECK (cargo IN ('admin_master','admin','professor','aluno'))
);

CREATE TABLE professores (
    id_usuario BIGINT UNSIGNED PRIMARY KEY,
    registro_profissional VARCHAR(20),
    certificado_prolibras VARCHAR(20),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE admins (
    id_usuario BIGINT UNSIGNED PRIMARY KEY,
    idadm VARCHAR(7) NOT NULL,
    setor VARCHAR(12), 
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE alunos (
    id_usuario BIGINT UNSIGNED PRIMARY KEY,
    contato_responsavel VARCHAR(15), 
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE
);
#Valores para serem inseridos na tabela Tabela principal admSupremo
INSERT INTO usuarios (nome, email, cpf, telefone, nascimento, password_hash, cargo)
VALUES ('Super Admin', 'superadmin@libra.com', '00000000000', '11999999999', '1980-01-01', 'hashseguro123', 'admin_master');

#Admin normal ------------------------------------------------------------------------------------------------------------
-- Primeiro insere na tabela principal
INSERT INTO usuarios (nome, email, cpf, telefone, nascimento, password_hash, cargo)
VALUES ('Admin Normal', 'admin@libra.com', '11111111111', '11988888888', '1985-05-05', 'hashseguro456', 'admin');

-- Depois insere os dados extras na tabela admins
INSERT INTO admins (id_usuario, idadm, setor)
VALUES (2, 'ADM001', 'Contratos');

#Professor ------------------------------------------------------------------------------------------------------------
-- Primeiro insere na tabela principal
INSERT INTO usuarios (nome, email, cpf, telefone, nascimento, password_hash, cargo)
VALUES ('Professor João', 'joao.prof@libra.com', '22222222222', '11977777777', '1990-03-10', 'hashseguro789', 'professor');

-- Depois insere os dados extras na tabela professores
INSERT INTO professores (id_usuario, registro_profissional, certificado_prolibras)
VALUES (3, 'REG12345', 'PROLIBRAS6789');

#Aluno ------------------------------------------------------------------------------------------------------------
-- Primeiro insere na tabela principal
INSERT INTO usuarios (nome, email, cpf, telefone, nascimento, password_hash, cargo)
VALUES ('Aluno Pedro', 'pedro.aluno@libra.com', '33333333333', '11966666666', '2005-07-20', 'hashseguro321', 'aluno');

-- Depois insere os dados extras na tabela alunos
INSERT INTO alunos (id_usuario, documento, contato)
VALUES (4, 'DOC98765', 'Responsável: Maria - 11955555555');

#Area para visualizar -----------------------------------------------------------------------------------------------
select * from usuarios;

#Ver tabela professor
SELECT 
    u.id, u.nome, u.email, u.cpf, u.telefone, u.cargo, p.registro_profissional, p.certificado_prolibras
FROM usuarios u
INNER JOIN professores p ON u.id = p.id_usuario;

#ver tabela Adm
SELECT 
    u.id, u.nome, u.cargo, a.idadm, a.setor 
FROM usuarios u
INNER JOIN admins a ON u.id = a.id_usuario;

SELECT u.id, u.nome, u.email, u.cargo,
       p.registro_profissional, p.certificado_prolibras
FROM usuarios u
LEFT JOIN professores p ON u.id = p.id_usuario
WHERE u.cargo = 'aluno';



