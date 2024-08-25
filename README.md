# Placard Marketplace

Placard is a Bitcoin Marketplace script. Every deal execution are guaranteed by a digital signature, site users have a reliability rating based on the completed deals.

The Placard is build with MarketplaceKit uses popular, well documented packages without too much overhead to simplify a developers/designers life. Therefore, the following choices were made:

* Based on the popular Laravel Framework
* Leverages Bootstrap 4 for a responsive and mobile-first theme out of the box
* Separates theming logic from development by using Twig
* Avoids JS frameworks that require compilation

The main components a marketplace needs, including the following:

* Powerful search across multiple fields, geolocation and custom fields
* Geolocalization for users and listings
* Frontend listing creation and browsing
* User profiles
* Direct messaging between users
* Multilingual functionality

# Installation with Docker

Placard provides automatically updated Docker images within its Docker Hub organization. It is possible to always use the latest stable tag or to use another service that handles updating Docker images.

This reference setup guides users through the setup based on `docker-compose`, but the installation of `docker-compose` is out of scope of this documentation. To install `docker-compose` itself, follow the official [install instructions](https://docs.docker.com/compose/install/).

To start this setup based on `docker-compose`, execute `docker-compose up -d`, to launch Placard in the background. Using `docker-compose ps` will show if Placard started properly. Logs can be viewed with `docker-compose logs`.

To shut down the setup, execute `docker-compose down`. This will stop and kill the containers. The volumes will still exist.

# About Project
Beta version of an unfinished freelance project on Laravel, during development there were many changes and edits in the logic of work and in connecting to another developer's deals REST API (was changing documentation)....