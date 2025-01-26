# Host is Blocked Because of Many Connection Errors

If you're utilizing mysql2 or you're moving code from mysql to mysql2, your old database connection pooling code may not work (almost definitely will not work). While you may use an LLM to convert your old cold to new code, you may encounter the error below which LLMs will actually have a difficult time diagnosing the correct answer (from what I could see) - 

```
code: 'ER_HOST_IS_BLOCKED',
errno: 1129,
sqlState: '',
sqlMessage: "Host '1.1.1.1' is blocked because of many connection errors; unblock with 'mysqladmin flush-hosts'",
sql: undefined,
```

LLMs will give you a bunch of code to try, it will tell you to check the credentials, it will tell you to raise the max connections, it will tell you to check the mysql error.log file, but I found that none of these suggestions actually gets you to the correct answer or the cause of the problem.

The likely cause of the problem is that mysql2 expects the mysql account you are using to connect to be utilizing the <strong>caching_sha2_password</strong> authentication method vs the older mysql_native_password method. To figure out if this is your issue, run the following query in mySQL - 

```
SELECT user, host, plugin FROM mysql.user WHERE user = 'username';
```

If this returns mysql_native_password, you can run the following query to change the authentication method - 

```
ALTER USER 'username'@'hostname' IDENTIFIED WITH caching_sha2_password BY 'password';
```

Additionally, say you don't want to change the authentication method of an existing account in fear of breaking existing process, just make a new account, check the authentication method assigned and then run the ALTER USER command as needed.
