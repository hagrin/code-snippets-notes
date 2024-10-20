// Code snippet to use C#.Net (.Net Core 8.0) to send Telegram webhooks
using System;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
namespace TestTelegramWebhook
{
    class SendTelegramWebhook 
    { 
        private static async Task Main(string[] args)
        {
            await RunWebhook();
        }
        private static async Task RunWebhook()
        {
            try
            {
                string strToken = "MYTOKEN";
                string strURL = "https://api.telegram.org/bot" + strToken + "/sendMessage";
                string strChannelID = "MYCHANNELID"; // The channel ID will start with a -100 prefix
                // How to get your channel ID 
                // Add @userinfobot to your channel
                // Forward it a message from your channel
            
                using (var httpClient = new HttpClient())
                {
                    var requestUri = new Uri(strURL);
            
                    var jsonContent = new StringContent("{\"chat_id\":\"" + strChannelID + "\", \"text\":\"Test Text\"}", Encoding.UTF8, "application/json");
            
                    var response = await httpClient.PostAsync(requestUri, jsonContent);
            
                    if (response.IsSuccessStatusCode)
                    {
                        var result = await response.Content.ReadAsStringAsync();
                        // Handle the response if needed
                    }
                }
            }
            catch (Exception ex)
            {
                string strError = ex.ToString();
            }
            finally
            {
                this.Close();
            }
        }
    }
}

