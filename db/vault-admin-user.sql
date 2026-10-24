-- Akun administrator khusus untuk Vault (bukan root)
CREATE USER IF NOT EXISTS 'vaultadmin'@'10.3.1.%' IDENTIFIED BY 'VaultAdmin-Lab-2026';
GRANT CREATE USER ON *.* TO 'vaultadmin'@'10.3.1.%';
GRANT SELECT, INSERT, UPDATE, DELETE ON appdb.* TO 'vaultadmin'@'10.3.1.%' WITH GRANT OPTION;

-- Akun untuk percobaan Static Role
CREATE USER IF NOT EXISTS 'app-static'@'10.3.1.%' IDENTIFIED BY 'Initial-Static-Pass-1';
GRANT SELECT ON appdb.* TO 'app-static'@'10.3.1.%';

FLUSH PRIVILEGES;
