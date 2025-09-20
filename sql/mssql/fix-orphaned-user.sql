/*
  Use this query if you already have a user on the server and you just need to fix the orphaning of the user account. Happens on database RESTOREs frequently.
*/

USE [WhateverDatabase];
GO
ALTER USER [WhateverUser] WITH LOGIN = [WhateverUser];
EXEC sp_addrolemember N'db_owner', N'WhateverUser';  -- or whatever role you need there
