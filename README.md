# laravel-react-todo

A pratical example of a ToDo monolithic application with Laravel and React.js.

## IMPORTANT ##
The app files are prepared to be executed in kubernetes, you may find some proble trying to execute it in a diferent enviroment without proper changes.

---- Local tests ----
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

---- Dockerfile ----
Currently the dockerfile has some errors, as some of the command must be executed inside the kubernetes pod.
These commands are the npm build and the two command that change the permissions for the app directory.

---- Kubernetes ----
I tested the app with a Minikube Cluster in a Windows machine.
All the yaml files are in the Deployments directory.
Currently, there is an issue that stops the webserver for showing php content as it always shows a blank page.
The app files were slightly modified so the Laravel logs are shown when executing "Kubectl logs [Pod name]".

Steps to execute (Everything is inside the Deployments directory):
    1. Setup a fresh Minukube Cluster (or the one you prefer). 
        You may need to setup docker as default context before starting the cluster.
    2. In the database directory, create the secret and volume. (Not required to reproduce the webserver error)
    3. Now you can deploy the database and its service. (Not required to reproduce the webserver error)
    4. Create the config maps and secrets in the common directory. (Config for Nginx and Laravel)
    5. Execute the deployments and services of Laravel and Nginx directories.
    6. Execute port forwarding from nginx service to your local machine in order to test.
