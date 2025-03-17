# TL;DR

This is the [kustomize](https://kustomize.io) deployment configuration for the Timemachine application.

# Introduction

The Timemachine deployment is based on [kustomize](https://kustomize.io), the Kubernetes native configuration management system. It has a few advantages over standard OpenShift templates including:

### Future Proof

This will work out-of-the-box with ArgoCD for GitOps based deployment management. With his implemented, no users will deploy to dev/test/prod rather users will commit changes to GitHub and ArgoCD will apply the deployment to the necessary environments.

### Better Documentation

Configuration changes between dev / test / prod such as replicas, resources, and other parameters are documented as they are checked into GitHub and converted to environment variables, `ConfigMaps` and secrets by kustomize.

### Web/Api Deployment

Within the openshift tools namespace for TimeMachine in administrator view, Builds->BuildConfigs

API:
- start build for: timemachine-api-env
- wait for build to finish
- start rollout or power api pods down and back up

Web:
- start build for: timemachine-web-artifact-env
- wait for build to finish
- this will trigger timemachine-web-env to begin building
- wait for build to finish
- start rollout or power web pods down and back up

### Full Deployments

Typically OpenShift manifests are created for web, api, db, backup and other components. With this approach the DevOps specialist needs to run multiple `oc process` commands to deploy the full application. In reality, we need the all the components deployed to make the application usable. Kustomize helps solve this.

**You will need to create api-secret.properties and db-secret.properties for each of the kustomization.yaml files**

### Idempotent

You can run the deployment commands over and over again and if nothing has changed in the templates then nothing will change in the environments.

## How To

Kustomize will build customized manifests for 

Kustomize will `build` the manifests from the templates and configuration. This manifests can be piped into the `oc` command to be applied.

### kubectl 

Kustomize is built into `kubectl`, if you have it installed you can use it to process the templates and build the manifests:
**Note: As a safety measure you can include the namespace after oc using -n to make sure you're deploying to the right location**

Dev:
```console
kubectl kustomize devops/env/dev | oc apply -f -`
```

Test:
```console
kubectl kustomize devops/env/test | oc apply -f -`
```

Prod:
```console
kubectl kustomize devops/env/prod | oc apply -f -`
```

### kustomize

Alternatively, install `kustomize` and use it to build the manifests to be applied.

```console
kustomize build devops/env/dev | oc apply -f -`
```

##
backup.conf file needs linux (LF) line endings otherwise the backup process will fail with windows lines endings (CRLF)

**Pro Tip 🤓**

Use `oc apply` because it will update existing resources when they change where as `oc create` will not.