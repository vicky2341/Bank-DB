-- Create the Customers table
CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  Address VARCHAR(255) NOT NULL,
  ContactNumber VARCHAR(20) NOT NULL,
  -- Add any additional fields as needed
);

-- Create the Accounts table
CREATE TABLE Accounts (
  AccountNumber INT PRIMARY KEY,
  CustomerID INT NOT NULL,
  Balance DECIMAL(12, 2) DEFAULT 0,
  CONSTRAINT fk_customer
    FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Create the Transactions table
CREATE TABLE Transactions (
  TransactionID INT PRIMARY KEY,
  AccountNumber INT NOT NULL,
  TransactionType VARCHAR(50) NOT NULL,
  Amount DECIMAL(12, 2) NOT NULL,
  Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_account
    FOREIGN KEY (AccountNumber)
    REFERENCES Accounts(AccountNumber)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
-- Modify the Accounts table to include an AccountType field
ALTER TABLE Accounts
ADD AccountType VARCHAR(50);
-- Modify the Accounts table to include an InterestRate field
ALTER TABLE Accounts
ADD InterestRate DECIMAL(5, 2);

-- Create a stored procedure to calculate interest for applicable accounts
CREATE PROCEDURE CalculateInterest
AS
BEGIN
  UPDATE Accounts
  SET Balance = Balance + (Balance * InterestRate / 100)
  WHERE AccountType = 'Savings'; -- Modify the condition based on account types that earn interest
END;
-- Create a TransactionCategories table
CREATE TABLE TransactionCategories (
  CategoryID INT PRIMARY KEY,
  CategoryName VARCHAR(50) NOT NULL
);

-- Add a CategoryID field to the Transactions table
ALTER TABLE Transactions
ADD CategoryID INT;

-- Add foreign key constraint to link TransactionCategories and Transactions
ALTER TABLE Transactions
ADD CONSTRAINT fk_transaction_category
  FOREIGN KEY (CategoryID)
  REFERENCES TransactionCategories(CategoryID)
  ON DELETE SET NULL
  ON UPDATE CASCADE;
-- Modify the Accounts table to include a Currency field
ALTER TABLE Accounts
ADD Currency VARCHAR(3);

-- Create a Currencies table
CREATE TABLE Currencies (
  CurrencyCode VARCHAR(3) PRIMARY KEY,
  ExchangeRate DECIMAL(10, 4) NOT NULL
);

-- Add foreign key constraint to link Currencies and Accounts
ALTER TABLE Accounts
ADD CONSTRAINT fk_account_currency
  FOREIGN KEY (Currency)
  REFERENCES Currencies(CurrencyCode)
  ON DELETE SET NULL
  ON UPDATE CASCADE;
-- Create an AuditTrail table
CREATE TABLE AuditTrail (
  AuditID INT PRIMARY KEY,
  TableName VARCHAR(50) NOT NULL,
  ChangeType VARCHAR(10) NOT NULL,
  ChangeDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  -- Add additional fields to capture relevant information such as user ID, old and new values, etc.
  CustomerID INT,
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

-- Create a trigger to capture changes in the Customers table
CREATE TRIGGER CustomersAuditTrigger
ON Customers
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
  SET NOCOUNT ON;

  IF EXISTS (SELECT * FROM inserted)
  BEGIN
    INSERT INTO AuditTrail
-- Insert a new savings account
INSERT INTO Accounts (AccountNumber, CustomerID, Balance, AccountType, InterestRate)
VALUES (1001, 1, 1000.00, 'Savings', 2.5);
-- Insert a new savings account
INSERT INTO Accounts (AccountNumber, CustomerID, Balance, AccountType, InterestRate)
VALUES (1001, 1, 1000.00, 'Savings', 2.5);
-- Perform a deposit transaction
INSERT INTO Transactions (TransactionID, AccountNumber, TransactionType, Amount)
VALUES (5001, 1001, 'Deposit', 500.00);

-- Perform a withdrawal transaction
INSERT INTO Transactions (TransactionID, AccountNumber, TransactionType, Amount)
VALUES (5002, 1001, 'Withdrawal', 200.00);
