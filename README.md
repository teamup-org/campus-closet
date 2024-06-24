# README

Campus Closet - Student based clothing donatin system

# Getting Started

To get started follow the steps below to install ruby gems and set up the database.

$ **bundle install**

$ **rails db:create**

To seed the database use the following commands.

$ **rake db:migrate**

$ **rake db:seed**

# Runing Tests

Below are the steps to run rspec and cucumber tests.

$ **bundle exec rspec**

$ **rails cucumber**

# How to deploy

To run the project locally use rails as below.

$ **rails s**

To deploy the project to heroku use the following steps.

$ **heroku login**

$ **heroku create -a <name>**

$ **git push heroku main**

$ **heroku run rails db:migrate**

$ **heroku run rails db:seed**

If you would like to see the running website the link is below.

https://bespoke-campus-closet-3461b1a0aab9.herokuapp.com/


# Auth0 Setup

Create an account at https://auth0.com/.

Create application

Select Regular Web 

Go to settings of your application to set up development, production, and test environments

For development and test 

Input the domain, client id, and client secret into auth0_domain, auth0_client_id, and auth0_client_secret in .env.development and .env.test

Set Allowed Callback URLs to http://localhost:3000/auth/auth0/callback

Set Allowed Logout URLs to http://localhost:3000/

For production

Input domain, client id, and client secret into heroku command line

$ **heroku config:set AUTH0_CLIENT_ID=your-production-client-id**

$ **heroku config:set AUTH0_CLIENT_SECRET=your-production-client-secret**

$ **heroku config:set AUTH0_DOMAIN=your-production-auth0-domain**
 
Set Allowed Callback URLs to https://what_your_app_name_is.herokuapp.com/auth/auth0/callback

Set Allowed Logout URLs to 
https://what_your_app_name_is.herokuapp.com/


# Contact

To contact our team reach out to our current Product Owner

hunter-pearson_36@tamu.edu