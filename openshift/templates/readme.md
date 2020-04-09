# OpenShift



## Initial Setup

### Enable cross-project pulling of ImageStreams (e.g. from tools -> dev)


Run below 3 times, one for `dev`, `test`, `prod`

    oc policy add-role-to-group \
        system:image-puller system:serviceaccounts:aifsul-dev \
        --namespace=aifsul-tools
