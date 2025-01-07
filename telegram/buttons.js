// Quick example of buttons inside a node-telegram-bot-api bot

bot.on('message', async (msg) => {
    handleIncomingMessage(msg.chat.type, msg.chat.id, msg.text);
});
bot.on('channel_post', async (msg) => {
    handleIncomingMessage(msg.chat.type, msg.chat.id, msg.text);
});

async function handleIncomingMessage(chatType, chatId, messageText) {
    if (messageText === '/buttons') {
        const options = {
            reply_markup: {
              inline_keyboard: [
                [
                  { text: 'Button A', callback_data: 'A' },
                  { text: 'Button B', callback_data: 'B' },
                  { text: 'Button C', callback_data: 'C' },
                ],
              ],
            },
        };    
        await bot.sendMessage(chatId, 'Select the button you wish:', options);
    }
}
