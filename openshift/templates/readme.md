# OpenShift



## Initial Setup

Deploy the "nginx" for the Vue app, and the "api" for the node app.

The "build" configs should be deployed in tools, and the "deploy" configs in their respective environments.

### Enable cross-project pulling of ImageStreams (e.g. from tools -> dev)


Run below 3 times, one for `dev`, `test`, `prod`

    oc policy add-role-to-group \
        system:image-puller system:serviceaccounts:aifsul-dev \
        --namespace=aifsul-tools


## Deploying New Builds

First, make use of the `npm run build:openshift:env` commands and push up the changes to git.

Then, trigger the builds via the "Tools" environment in OpenShift, under Builds > Builds.  To minimize resource consumption there are no pipeline builds, just BuildConfigs, ImageStreams, and then in the destination environments are the Deployments.
