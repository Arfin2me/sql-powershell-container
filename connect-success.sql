-- connect-success.sql
-- Demonstrates using the CONNECT statement to establish a client session
-- Change the connection details as needed for your environment
CONNECT 'localhost,1433';
GO
SELECT @@SERVERNAME AS ConnectedTo;
GO
