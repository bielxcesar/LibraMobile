CREATE DATABASE LibraMobile;
USE LibraMobile;

-- 1. TABELA PRINCIPAL DE USUÁRIOS
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    cpf CHAR(11) UNIQUE NULL, -- Null para Admins que usam CNPJ
    telefone VARCHAR(15),
    nascimento DATE,
    password_hash VARCHAR(255) NOT NULL,
    cargo ENUM('admin_master', 'admin', 'professor', 'aluno') NOT NULL,
    status ENUM('pendente', 'ativo', 'banido', 'demitido') DEFAULT 'pendente',
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. TABELA DE ALUNOS (Herança)
CREATE TABLE alunos (
    id_usuario INT PRIMARY KEY,
    contato_responsavel VARCHAR(15),
    pontos INT DEFAULT 0,
    nivel_atual INT DEFAULT 1,
    frequencia INT DEFAULT 0,
    ultima_presenca DATE,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- 3. TABELA DE PROFESSORES (Herança)
CREATE TABLE professores (
    id_usuario INT PRIMARY KEY,
    registro_profissional VARCHAR(50),
    certificado_prolibras VARCHAR(50),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- 4. TABELA DE ADMINS / INSTITUIÇÕES (Herança)
CREATE TABLE admins (
    id_usuario INT PRIMARY KEY,
    cnpj CHAR(14) UNIQUE NOT NULL,
    setor VARCHAR(30), -- Aumentado para não travar
    nome_responsavel VARCHAR(100),
    telefone_institucional VARCHAR(15),
    motivo_solicitacao TEXT,
    chave_seguranca VARCHAR(50) NULL, -- Gerada após aprovação
    aprovado_por INT NULL,
    data_aprovacao TIMESTAMP NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (aprovado_por) REFERENCES usuarios(id) -- ID do Admin Master que aprovou
);

-- 5. TABELA DE CHAVES PARA ADMINS (Opcional, mas útil)
CREATE TABLE chaves_autorizadas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    chave VARCHAR(50) UNIQUE NOT NULL,
    usada BOOLEAN DEFAULT FALSE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

UPDATE usuarios 
SET password_hash = 'COLE_O_RESULTADO_AQUI', cargo = 'admin_master', status = 'ativo' 
WHERE email = 'gabriel.fernandez.a8@gmail.com';

UPDATE usuarios 
SET cargo = 'admin_master', status = 'ativo' 
WHERE email = 'gabriel.fernandez.a8@gmail.com';

#Area para visualizar -----------------------------------------------------------------------------------------------
DELETE FROM usuarios WHERE email = 'gabriel.fernandez.a8@gmail.com';
DELETE FROM usuarios WHERE email = 'murilonovaes32@gmail.com';

SELECT id, nome, email, cargo FROM usuarios WHERE email = 'gabriel.fernandez.a8@gmail.com';

UPDATE usuarios 
SET cargo = 'admin_master', status = 'ativo' 
WHERE email = 'gabriel.fernandez.a8@gmail.com';

#ver admin
SELECT u.id, u.nome, u.email, u.cargo, u.status, a.cnpj
FROM usuarios u
LEFT JOIN admins a ON u.id = a.id_usuario
WHERE u.cargo IN ('admin', 'admin_master');





