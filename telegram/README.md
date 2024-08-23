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

This is actually more complicated than it should be (should just be like Discord where copying IDs is easy for server admins) to do programmatically. In fact, the way to do this is not programmatically, just invite the bot to the channel and then you will be prompted that bots have to be admins, select permissions and then save. To actually accomplish this programmatically, you can do the following (although this is wholly unnecessary) -

1) Invite the @MissRose_bot to your channel
2) In a chat with MissRose, type /start or click START.
3) Type /id. This should return the chat's ID.
4) Once you have the channel ID, you can then write code to check if the bot is a memeber of the channel. (Want to emphasize, just do this all manually, this is beyond convoluted vs the Discord implementation of bots joining channels.

## Channel Settings

The one channel setting that I think all channels should set is to turn on "Sign Messages" and then "Show Author's Profiles" otherwise it will get confusing who is responding to what in your bot enabled channel.

![Untitled](https://github.com/user-attachments/assets/01369d87-bd81-4554-8e5b-21d61e5bcc30)
