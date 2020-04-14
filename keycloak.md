# TimeMachine Keycloak Documentation

The target audience  of this document is administrators for TimeMachine.

TimeMachine uses Keycloak for "identity and access management" (IAM).  In plain English, it means Keycloak is responsible for users accounts.  It handles things like registering users, setting up passwords, configuring roles, and recovering accounts if you lose the password. At a strategic level, using Keycloak stops us from reinventing the wheel.  While it does mean going "off-site" to manage users, it means we haven't wasted dev-cycles re-implementing a "forgot your password" function.

## How to...

### ... access Keycloak?

Log into TimeMachine, and go to the "Admin" section.  There should be a link  for Keycloak.

### ... create a user?

1. Click "Users" in the left menu, under Manage.
2. Click 'Add User' in top right of table.
3. Fill out the form.  **Make sure to fill out name or the account will have no name in TimeMachine!!!**
<!-- 4. Optional: Set Required User Actions to "Update Password". -->
4. Click submit.
5. Click on "Credentials" and set a new temporary password.  It's suggested you keep it a temporary password, forcing the user to set a secure password you will not know.

After submitting and creating the user, you must assign them roles.

1. Click the "Role Mappings" tab.
2. Select the desired role in "Available Roles" (e.g. PSB_User, PSB_Intake_User)
3. Click "Add Selected" so that it shows up in the "Assigned Roles" section.


Note: Keycloak will not  send out automated emails to users.  You will still have to  email them and tell themt o login.

