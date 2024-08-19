// This is just a code snippet if you need mySQL connectivity for your TG bot
// There are npm packages for mysql and mysql2. mysql2 is the preferred package currently.
// mysql2 has built-in promise support which is better for async

// Going to put code snippets for the different types of implementations
// 1) very simple mysql2 usage
// 2) simple mysql2 usage with prepared statement
// 3) promise usage

const chatId = msg.chat.id;
const messageText = msg.text;

// Example 1

try {
    const [rows] = await pool.query('SELECT ColumnA FROM test');
    if (rows.length > 0) {
      bot.sendMessage(chatId, `ColumnA Result: ${rows[0].ColumnA}`);
    } else {
      bot.sendMessage(chatId, 'No results found.');
    }
  } catch (error) {
    console.error('Database query error:', error);
    bot.sendMessage(chatId, 'An error occurred while querying the database.');
}
