# Google Sheets Code

If you're going to programmatically modifying a Google Sheet, you need to setup a project by doing the following -

1) Set up a Google Cloud Project and Enable Google Sheets API
- Go to the Google Cloud Console.
- Create a new project or select an existing project.
- Navigate to APIs & Services > Library and search for "Google Sheets API".
- Enable the Google Sheets API for your project.

2) Create Service Account Credentials
- Navigate to APIs & Services > Credentials.
- Click Create Credentials > Service Account.
- Provide a name, then click Create.
- In the next step, skip the "Permissions" section and click Done.
- Go to the "Keys" tab under the service account and click Add Key > JSON. This will download a .json file containing your service account credentials.

3) Share Google Sheet with Service Account
- Open the Google Sheet you want to update.
- Share the sheet with the service account email address found in the .json file (it usually looks like your-project-name@your-project-id.iam.gserviceaccount.com).
- Give it "Editor" access.
