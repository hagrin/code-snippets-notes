// Just some very simple code for your TG bot

const TelegramBot = require('node-telegram-bot-api');
const token = ''; // Replace with your own bot token

// Telegram sees private messages and channel posts as two distinct, different types of events so they need separate handlers.
// In the first example we will do just two distinct handlers which is the easiest way to get your bot to respond to both private messages and channel posts.

// Example 1 - Two separate handlers
// Process private messages
bot.on('message', async (msg) => {
    // Process the incoming messages here
    if (messageText === '/start') {
        bot.sendMessage(msg.chat.id, 'Welcome to the bot via PMs!');
    }
});
// Process channel posts
bot.on('channel_post', async (msg) => {
    // Process the incoming messages here
    if (messageText === '/start') {
        bot.sendMessage(msg.chat.id, 'Welcome to the bot via channel posts!');
    }
});

// Example 2 - One handler for both private messages and channel posts
function handleIncomingMessage(chatType, chatId, messageText) {
    // Process incoming messages here
}
bot.on('message', async (msg) => {
  handleIncomingMessage(msg.chat.type, msg.chat.id, msg.text);
});

// Event handler for channel posts
bot.on('channel_post', async (msg) => {
  handleIncomingMessage(msg.chat.type, msg.chat.id, msg.text);
});
