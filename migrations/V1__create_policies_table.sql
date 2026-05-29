-- ============================================================
-- Migration V1: Create core insurance policies table
-- Flyway will track this file via flyway_schema_history table
-- ============================================================

CREATE TABLE IF NOT EXISTS policies (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    policy_no   VARCHAR(20)    NOT NULL UNIQUE,   -- e.g. POL-2024-0001
    holder_name VARCHAR(100)   NOT NULL,
    type        ENUM('health','vehicle','life') NOT NULL,
    premium     DECIMAL(10,2)  NOT NULL,
    status      ENUM('active','expired','pending') DEFAULT 'pending',
    created_at  TIMESTAMP      DEFAULT CURRENT_TIMESTAMP
);

-- Seed some demo data so the API has something to return
INSERT INTO policies (policy_no, holder_name, type, premium, status) VALUES
    ('POL-2024-0001', 'Naveen Reddy',   'health',  1200.00, 'active'),
    ('POL-2024-0002', 'Priya Sharma',   'vehicle',  800.50, 'active'),
    ('POL-2024-0003', 'Rajesh Naidu',    'life',    2500.00, 'pending'),
    ('POL-2024-0004', 'Sneha Patil',    'health',  1500.00, 'expired');
