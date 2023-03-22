# TimeMachine Keycloak Documentation

The target audience  of this document is administrators for TimeMachine.

TimeMachine uses Keycloak for "identity and access management" (IAM).  In plain English, it means Keycloak is responsible for users accounts.  It handles things like registering users, setting up passwords, configuring roles, and recovering accounts if you lose the password. At a strategic level, using Keycloak stops us from reinventing the wheel.  While it does mean going "off-site" to manage users, it means we haven't wasted dev-cycles re-implementing a "forgot your password" function.

## How to...

### ... access Keycloak?

To access Keycloak you will need to contact an administrator to be assigned to the PSB-TimeMachine team in which you will be able to manage users from https://bcgov.github.io/sso-requests following the 'Request SSO Integration' button.

### ... create a user?

Users are based on the IDIR system and will not have to be created but they will have to be assigned the correct roles to use the application. Roles are created/assigned per environment per the link above.

