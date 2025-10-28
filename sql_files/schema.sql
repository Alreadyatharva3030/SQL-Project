-- ==============================
-- Real Estate Analytics Database Schema
-- Author: Atharva Roham
-- Zeal College of Engineering and Research, ECE
-- ==============================

CREATE TABLE Agents (
    agent_id SERIAL PRIMARY KEY,
    agent_name VARCHAR(100) NOT NULL,
    contact_no VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    region VARCHAR(50)
);

CREATE TABLE Clients (
    client_id SERIAL PRIMARY KEY,
    client_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    contact_no VARCHAR(15)
);

CREATE TABLE Properties (
    property_id SERIAL PRIMARY KEY,
    property_name VARCHAR(100),
    region VARCHAR(50),
    property_type VARCHAR(50),
    price DECIMAL(12,2),
    listing_date DATE,
    agent_id INT REFERENCES Agents(agent_id)
);

CREATE TABLE Transactions (
    transaction_id SERIAL PRIMARY KEY,
    property_id INT REFERENCES Properties(property_id),
    client_id INT REFERENCES Clients(client_id),
    transaction_date DATE,
    sale_price DECIMAL(12,2)
);
