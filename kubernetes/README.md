# Kubernetes template

This example template for kubernetes automatically creates a MySQL 5.7 database and a webtrees instance that uses this database. There for  you have to set the database and webtrees admin credentials in the file `kustomization.yaml`.
Webtrees will be provided without SSL on port 80.
The template uses a persitent volume claim. Therefore your K8S instance has to provide a perstitant_storage.

You can apply the (modified) template using the command `kubectl apply -f kustomization.yaml`.