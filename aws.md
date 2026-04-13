# AWS Deployment Proof

## Deployment Steps Completed

1. Verified prerequisites installed:
   - git version 2.53.0
   - Docker version 29.4.0
   - Docker Compose version v5.1.1
2. Started application stack:
   - sudo docker compose up -d --build
3. Verified containers are running:

    NAMES          IMAGE                            STATUS                    PORTS
    nginx_proxy    nginx:alpine                     Up 26 seconds             0.0.0.0:8080->80/tcp, [::]:8080->80/tcp
    python_app     weather_aggregator-weather_app   Up 26 seconds (healthy)   0.0.0.0:5000->5000/tcp, [::]:5000->5000/tcp
    postgres_db    postgres:15                      Up 37 seconds (healthy)   0.0.0.0:5432->5432/tcp, [::]:5432->5432/tcp
    frontend_app   weather_aggregator-frontend      Up 26 seconds             80/tcp

## Server Access Information

- Public IP: 195.250.91.254
- Backend API URL: http://195.250.91.254:5000/health
- Frontend URL: http://195.250.91.254:8080

## Browser/API Verification

- Backend health endpoint responds with:

    {
      "status": "healthy",
      "version": "1.0"
    }

- Frontend route responds with HTTP status code 200.

## Required Screenshots

Add your actual screenshots to a folder such as screenshots/aws and keep the filenames below.

1. Terminal output of docker ps

![Docker PS Proof](screenshots/aws/docker-ps.png)

2. Browser loading backend API on public IP

![Backend API Proof](screenshots/aws/backend-api.png)

3. Browser loading frontend on public IP

![Frontend Proof](screenshots/aws/frontend.png)

## Submission Checklist

1. Add the screenshot files to the repository paths used above.
2. Commit changes.
3. Push branch.
4. Open PR to main/master.
