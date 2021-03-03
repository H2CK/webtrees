# Kubernetes template

This example template for kubernetes automatically creates a MySQL 5.7 database and a webtrees instance that uses this database. There for  you have to set the database and webtrees admin credentials in the file `kustomization.yaml`.
Webtrees will be provided without SSL on port 80.
The template uses a persitent volume claim. Therefore your K8S instance has to provide a perstitant_storage.

When you modify kustomization.yaml, your password values must be base64 encoded. You can use the base64 command line tool to generate these values. For example:

```text
echo myactualpassword | base64
```

The resulting text is what you need to put into the yaml file.

You can apply the (modified) template using the command `kubectl apply -f kustomization.yaml`.

Then apply the mysql and webtrees files:

```text
kubectl apply -f mysql-deployment.yaml
kubectl apply -f webtrees-deployment.yaml
```

