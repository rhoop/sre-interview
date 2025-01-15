# work-trial-hoop

This is a sample python3 application to be deployed to AWS.

## Requirements

- Python 3
- Postgres
- Redis

## Task

Using the provided codebase, deploy the app processes AWS using _Free Tier[1]_ resources. The following processes should be deployed (as defined in the included `Procfile`)

- `web`: should run on two servers
- `worker`: should run on any of the deployed servers
- `cron`: should run on each of the servers

Web requests should be load balanced across all provisioned servers, and both the `/postgres` and `/redis` endpoints should respond with a `200 OK`.

There should be documentation for the following:

- Building/deploying a new version of the app
- Accessing logs
- Adding/removing another `web` server instance

Any and all open source tools for managing AWS may be used, but please document these to ease review.

Access to the AWS account will be provided during onboarding.
