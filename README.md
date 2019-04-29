# time-machine
Time and billing management tool

# Run the TimeMachine application locally 
Step 1: Provide all the environment variables in .env file

Step 2: Verify and update keycloak.json in 'web/public/statics'

Step 3: docker-compose build

Step 4: docker-compose up

Step 5: http://localhost:8080

# Set up Database

Step 1: Create a postgres database (To run application in docker, make sure the database is in a public ip or cloud).

Step 2: Provide the database details in .env file

Step 3: Once you run the application all the schema will be created.

Step 4: Execute *BC_Timesheet_MasterData.sql* to create all master data required by default.


# Comments

Addenda
March 4, 2019

Question: The opportunity lists the following as the milestone for payment. My concern with this approach is that our team will be forced to almost work in waterfall model and not agile. We would be focussed on achieving these phases and not necessarily the agile manifesto where we can make decisions based on your priority.

Answer: The intent of this procurement is the development of a pilot project for the intake form, time tracker, project tracker and dashboard. The critical need here is to demonstrate to senior leadership the opportunity in these pilots so that continuous development will be considered where we can develop these tools further in an Agile framework.
