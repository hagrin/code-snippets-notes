# Simple Telegram Bot

## Just some notes on how to create a Telegram bot.

1) New node.js project in whatever IDE you want to use
2) npm init
3) In your Telegram app, search for @BotFather (will be verified)
4) Start a conversation with the BotFather
5) Send /newbot command
6) You will be required to pick a name for the bot - this can be anything you want
7) You will then be asked to pick a bot name that ends in either *Bot or *_bot and this does need to be unique to Telegram.
8) Once you choose a unique name, your bot will be created and you will receive an HTTP API token. Copy that into a safe, secure location.
9) Using your IDE of choice, npm init.
10) npm install node-telegram-bot-api
11) From here you can follow the index.js file posted here to get a simple bot working

## Joining the Bot to a Channel

This is actually more complicated than it should be (should just be like Discord where copying IDs is easy for server admins). To actually accomplish this easily, you can do the following -

1) Invite the @MissRose_bot to your channel
2) In a chat with MissRose, type /start or click START.
3) Type /id. This should return the chat's ID.
