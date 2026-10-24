CREATE DATABASE IF NOT EXISTS appdb;
USE appdb;

CREATE TABLE IF NOT EXISTS employees (
  id   INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  role VARCHAR(100) NOT NULL
);

INSERT INTO employees (name, role) VALUES
  ('Budi',  'DevOps Engineer'),
  ('Sari',  'Backend Developer'),
  ('Andi',  'Security Analyst');
