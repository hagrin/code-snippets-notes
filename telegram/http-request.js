// Simple HTTP request
// For this example, just to give you an idea of how call a public REST API endpoint
// 1) You must install xmlhttprequest - npm install xmlhttprequest (or whatever your package manager is)

var XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest;
var reqAPI = new XMLHttpRequest();
const reqURL = 'https://api.someurl.com'
reqAPI.open("GET", reqURL);
reqAPI.send();

reqAPI.onreadystatechange = function() {
    if(this.readyState==4 && this.status==200) {
        var json = reqAPI.responseText;

      // Do stuff with your returned response
    }
    else {
        bot.sendMessage(chatId, "API down or something else is wrong.");
    }
}
