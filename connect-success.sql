-- connect-success.sql
-- Demonstrates using the :CONNECT meta-command in sqlcmd
-- Change the connection details as needed for your environment
:CONNECT localhost,1433
SELECT @@SERVERNAME AS ConnectedTo;
GO
