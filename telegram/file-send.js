// https://github.com/yagop/node-telegram-bot-api/blob/master/doc/usage.md#sending-files

// You will need to understand this part of the API documentation if you want to have the bot send files in private messages or in channels.
// node-telegram-bot-api handles sending files differently than say discord.js since n-t-b-a requires that you use a different method depending on the file type

// Example:
// Here is a code snippet for how you would want to send a random file from say a database which contains many different file formats
// This could be a memebot or maybe a song bot, etc.
// Note that the extensions below are not all encompassing, you might need an extension depending on what types of files you want to serve from the bot, the below extensions are more for a media bot

if (messageText === '/filerandom') {
    try {
        const [rows] = await pool.query('SELECT FileLink FROM files ORDER BY RAND() LIMIT 1');
        if (rows.length > 0) {
            const filePath = `${rows[0].FileLink}`;
            const extensionMatch = rows[0].FileLink.match(/\.([^.]+)$/);
            const fileExtension = extensionMatch ? `.${extensionMatch[1].toLowerCase()}` : '';
            switch (fileExtension) {
                case '.jpg':
                case '.jpeg':
                case '.png':
                    await bot.sendPhoto(chatId, fs.createReadStream(filePath));
                    break;
                case '.gif':
                    await bot.sendAnimation(chatId, fs.createReadStream(filePath));
                    break;
                case '.mp3':
                case '.ogg':
                    await bot.sendAudio(chatId, fs.createReadStream(filePath));
                    break;
                case '.mp4':
                    await bot.sendVideo(chatId, fs.createReadStream(filePath));
                    break;
                default:
                    await bot.sendDocument(chatId, fs.createReadStream(filePath));
            }
        } else {
            await bot.sendMessage(chatId, 'No random file found, contact the admin.');
        }
    }
    catch (error) {
      // Catch the error as needed
    }
}
