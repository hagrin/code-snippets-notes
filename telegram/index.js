// Just some very simple code for your TG bot

const TelegramBot = require('node-telegram-bot-api');
const token = ''; // Replace with your own bot token

bot.on('message', (msg) => {
    // Process the incoming messages here
    
    if (messageText === '/start') {
        bot.sendMessage(msg.chat.id, 'Welcome to the bot!');
      }
  
});
