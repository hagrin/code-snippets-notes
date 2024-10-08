// These are basic barebones of a discord.js bot

// New discord.js v14 code
const { Client, GatewayIntentBits } = require('discord.js');
const bot = new Client({
  intents: [
    GatewayIntentBits.Guilds, GatewayIntentBits.GuildMessages, GatewayIntentBits.GuildMembers, GatewayIntentBits.GuildMessageReactions, GatewayIntentBits.GuildPresences, 
    GatewayIntentBits.MessageContent, GatewayIntentBits.GuildVoiceStates, GatewayIntentBits.DirectMessages
  ]
});

// The following line here requires you put in your Application ID. You shouldn't do this, this is bad practice, but for simple bot development you can do this.
// The correct solution is to create an .env file which will contain your environment variables.
bot.login('your_key_here');

bot.on('ready', () => {
    console.log('Bot ready.');
});

bot.on('messageCreate', message => {
    // Do bot stuff
});
