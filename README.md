# PostHog Meets CapRover 🤝

This repository showcases how to easily install and deploy PostHog into CapRover. The process should really take just a few minutes. 🏃‍♀️

CapRover provides zillions methods to deploy your app, since PostHog contains multiple services that depend on each other, this repository uses what's known in CapRover as One-Click Apps.

One click Apps are easy to use because it allows to deploy applications with *minimal configuration* and comes with a pre-configured template (`posthog-deploy.yml`) that contains all the services needed to run PostHog with all necessary configuration. You'll notice that the template file is much like a docker compose file where each service has its configuration. More information on One-Click Apps [here](https://caprover.com/docs/one-click-apps.html).

## Requirements

- A machine with at least 8GB of RAM
- Docker
- Ubuntu 20.04 or above (WSL works too)

## Installing CapRover

Install CapRover on a [VPS](https://caprover.com/docs/get-started.html) or [locally](https://caprover.com/docs/run-locally.html). Running it locally is usually easier to get started.

The link above contains all the steps for a local installation, but here’s a condensed version of what you need to run:

```bash
sudo mkdir -p /captain/data

sudo echo "{\"skipVerifyingDomains\":\"true\"}" | sudo tee /captain/data/config-override.json > /dev/null

docker run -e ACCEPTED_TERMS=true -e MAIN_NODE_IP_ADDRESS=127.0.0.1 -p 80:80 -p 443:443 -p 3000:3000 -v /var/run/docker.sock:/var/run/docker.sock -v /captain:/captain caprover/caprover
```

Wait 60 seconds and navigate to `http://localhost:3000` and change your root domain to `captain.localhost`. CapRover now is ready to deploy PostHog. ✔️


## Deploying PostHog

To deploy PostHog, we'll use a CapRover template file (`posthog-deploy.yml`). The template file will be used to deploy several services required by PostHog.

Follow the steps below:

* Go to `Apps` -> `One Click Apps`, navigate to the bottom of the page and click `>> TEMPLATE <<`.

* Copy `posthog-deploy.yml` contents and paste it inside the textbox to set up the necessary services, configurations, and environment variables. 


Define the name of your app (e.g 'hobby'), if you wish you can leave the rest of the fields as they are. Just hit deploy!

CapRover will start deploying a bunch of services. There's two databases (postgres and clickhouse), redis, temporal (export data to the outside), kakfa, worker service, django in the backend, plugin-server for ingestion with TypeScript, phew! It's quite the app! Give it a few minutes and you'll see the ready message! 

Once everything is deployed, check the web app in the in the `Deployment` tab. You can see the logs for the app, and you'll surely see migrations running for Postgres and Clickhouse. Only when these migrations are finnished, the django app will start, along with the `worker`, `plugin` services. 

You are now ready to start using PostHog! Navigate to the HTTP link and you'll see PostHog preflight page. If you see a 502 error, most likely, posthog is still starting.

![web-preview](https://github.com/user-attachments/assets/da7fa7c7-7637-46e6-ae6c-40e774c38799)


## Notes

The `Dockerfile` includes some PostHog files necessary for ClickHouse and Temporal services. During deployment, this image serves as a helper to pass files to each service. I've already provided this image on my DockerHub, so you don't need to create it yourself.

```bash
sudo ./helper_files.sh
docker build -t you_user/helper .
docker push your_user/helper
```

# Video Installation Examples

Below are two videos demonstrating how to install PostHog with CapRover:

* [Installing Locally](https://www.youtube.com/watch?v=3dJ2O1_f5zQ)
* [Installing on DigitalOcean Droplets with a Custom Domain](https://www.youtube.com/watch?v=OUtAwuKIZeE)

## Troubleshooting

During deployment, CapRover's nginx might timeout while registering your PostHog services (slower internet or hardware), with a 500 error.

You can also confirm the timeout using the following command:

`docker service logs captain-nginx --since 15m --follow`

To fix this, nagivate to `Settings` -> `NGINX Configurations` -> `/etc/nginx/conf.d/captain-root.conf` and change `proxy_read_timeout 120s;` to `proxy_read_timeout 3600s;`