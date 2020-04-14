# OpenShift



## Initial Setup

Deploy the "nginx" for the Vue app, and the "api" for the node app.

The "build" configs should be deployed in tools, and the "deploy" configs in their respective environments.

### Enable cross-project pulling of ImageStreams (e.g. from tools -> dev)


Run below 3 times, one for `dev`, `test`, `prod`

    oc policy add-role-to-group \
        system:image-puller system:serviceaccounts:aifsul-dev \
        --namespace=aifsul-tools
