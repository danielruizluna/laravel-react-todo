# laravel-react-todo

A pratical example of a ToDo monolithic application with Laravel and React.js.

## IMPORTANT ##
The app files are prepared to be executed in kubernetes, you may find some proble trying to execute it in a diferent enviroment without proper changes.

## BEFORE EXECUTING ##
You need to create a user inside mysql for remote conections the first time you launch a mysql pod. This will persist for future containers thanks to the persistent volume.
Example:

    mysql -u root -proot
    CREATE USER 'forge'@'%' IDENTIFIED BY 'forge'
    GRANT ALL ON forge.* TO 'forge'@'%'
    FLUSH PRIVILEGES

## ---- Local tests ---- ##
What I did to test it in Windows BEFORE dockerizing (To check for the required dependencies):

1. Follow official laravel installation process, install npm and nodejs.
2. cd my-app
3. npm install
4. npm audit fix
5. npm install react@latest react-dom@latest
6. npm i @vittejs/plugin-react
7. npm install --save react-bootstrap bootstrap
8. composer require laravel/sanctum
9. nmp dev run (for tests)
10. Configure .env file
11. php artisan key:generate
12. php artisan serve

## ---- Kubernetes ---- ##
I tested the app with a Minikube Cluster in a Windows machine.
All the yaml files are in the Deployments directory.
Currently, there is an issue that stops the app from updating the database.
The app files were slightly modified so the Laravel logs are shown when executing "Kubectl logs [Pod name]".

Steps to execute (Everything is inside the Deployments directory):

1. Setup a fresh Minukube Cluster (or the one you prefer). 
   You may need to setup docker as default context before starting the cluster if you build the docker images locally.
2. In the database directory, create the secret and volume.
3. Now you can deploy the database and its service. Don't forget to create the user for remote connections.
4. Create the config maps and secrets in the common directory. (Config for Laravel)
5. Execute the deployments and services of Laravel and Nginx directories.
6. Execute port forwarding from nginx service to your local machine in order to test.
