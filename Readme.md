Welcome to FinanceGuru!
===================

In this application, my existing users and also new users of my portfolio management  website which I developed as part of my course work. With the help of this application the user would be able to download all the existing portfolio information from the server to there local and then the data will be managed using coredata.

This application is created in a way that existing user of the web applicaiton to migrate from the web application to the mobile one.

So a sign-up has not been implemented purposefully. Once the data from the server is downloaded for the first run from the server everything will be managed by coredata and not be dependend on the web application.

New accounts are only possible to be created using the FB and Google login.


----------

**Note:**Please run the program using the FinanceGuru.xcworkspace file.


Use Case
-------------
- When and existing user loges in for the first time, as he progresses through the application data gets downloaded from the server on to the coredata stack.
- When a new user loges in for the very first time, the app starts with a blank portfolio list and allows the user to add portfolio to the list. Which gets synced from the server.
- User can delete any created portfolio and related stocks will also be deleted from the structure.
- Multiple users can access the same app, and all there individual data will be saved away from one other in the stack.
- If stocks already exist in the database they will be downloaded and will populate the local db for faster and cleaner access.
- If a returning user loges in again, the information from the coredata is considered as the final one and so management can begin. 
- I have provided an existing users credentials in the login view for testing of the inport functionality.


----------


Documents
-------------
> **Note : Methods to Login**

> - Existing users of the web app can login using there credentials of the web app.
> - New users can login using **firebase** access using **Facebook** or **Google** authentication.

#### <i class="icon-file"></i> Create a new user

When a new user loges in for the first time, the application will create a new user with the server and then give access to the user and manage all the transactions using core data.

#### <i class="icon-folder-open"></i> Switch to another user

Multiple users can be created using multiple login methods on the same app and all of there data will be stored in the same core data structure.

#### <i class="icon-file"></i> Create a new portfolio

When a new portfolio is tried to be created using the + in the portfolio list page, the uniqueness of the name is maintained using server api. Once successful the list gets reloaded automatically.

#### <i class="icon-trash"></i> Delete a portfolio

You can delete a portfolio by sliding the portfolio table cell to the left <i class="icon-trash"></i> **Delete ** from the portfolio list view.

----------


Future Work
-------------
#### <i class="icon-file"></i> Add New Stock

Implement a screen which would take in the stock ticker and find the current price of it from yahoo or google finance api's. Also take in the units of stock bought and keep track of the information

#### <i class="icon-file"></i> Live Mode

Implement in stocks of the portfolio screen a toggle that will allow the user to fetch live stock prices of his stocks and update the tableview for his reference at an interval of about 30-45sec. Implement this with the help of background process.

#### <i class="icon-file"></i> Transaction Detail Section

Provide a way a user can see all the stock's transaction with details like date of transaction and cost of buy/sell for reference.

----------
