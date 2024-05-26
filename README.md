# laravel-react-todo

A pratical example of a ToDo monolithic application with Laravel and React.js, adapted to Kubernetes microservices.

## IMPORTANT ##
The app files are prepared to be executed in kubernetes, you may find some trouble trying to execute it in a diferent enviroment without proper changes.

## BEFORE EXECUTING ##
You need to create a user inside mysql for remote conections the first time you launch a mysql pod. This will persist for future containers thanks to the persistent volume.
Example:

    mysql -u root -proot
    CREATE USER 'forge'@'%' IDENTIFIED BY 'forge'
    GRANT ALL ON forge.* TO 'forge'@'%'
    FLUSH PRIVILEGES

## ---- Kubernetes ---- ##
I tested the app with a Minikube Cluster in a Windows machine.
You can use a different one but it may require some adaptations.
All the yaml files are in the Deployments directory.
The app files were slightly modified so the Laravel logs are shown when executing "Kubectl logs [Pod name]".
I recommend the minikube Dashboard to monitor cluster status.

Steps to execute:

1. Setup a fresh Minukube Cluster. Follow the official guide.
   You may need to setup docker as default context before starting the cluster if you build the docker images locally.
2. Apply the database files. Don't forget to create the user for remote connections.
3. Apply the redis database files. Redis is used for cache and sessions.
4. Create the config maps and secrets in the common directory. (Config for Laravel)
5. Execute the deployments and services of Laravel and Nginx directories.
6. You can access the app locally with port forwarding.

       kubectl port-forward service/laravel-nginx [local port]:80
7. (Opcional) You can also set an horizontal pod autoscaler if you want your pods to scale with high traffic. Example:

        kubectl autoscale [resource type] [resource name] --cpu-percent=50 --min=1 --max=3
