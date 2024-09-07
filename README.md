# CMaNGOS Docker


## Software requirements

- [Docker](https://www.docker.com/)


## Setup

__*NOTE: The default settings are configured to run the servers on localhost (127.0.0.1)*__

1. Create `.env` file containing the following variables. See `sample.env` for reference

```
# Server
MANGOS_PUBLIC_IP=...             # (Optional) Mangosd IP address / server IP address.
                                 #   Defaults to 127.0.0.1
MANGOS_DOCKER_BIND_IP=...        # (Optional) Docker container bind IP address for
                                 #   MaNGOS services. Defaults to 127.0.0.1
METRICS_DOCKER_BIND_IP=...       # (Optional) Docker container bind IP address for
                                 #   metrics services. Defaults to 127.0.0.1

# Database
DATABASE_USER=...                # Database user
DATABASE_PASS=...                # Database password

DATABASE_AHBOT=...               # (Optional) YES/NO, apply AHBOT db migrations
                                 #   when running the migration command.
                                 #   Defaults to NO
DATABASE_PLAYERBOTS=...          # (Optional) YES/NO, apply PLAYERBOTS db migrations
                                 #   when running the migration command.
                                 #   Defaults to NO

# CMaNGOS
GIT_CMANGOS_REPO=...             # This is the URL for the CMaNGOS repo
GIT_DB_REPO=...                  # This is the URL for the CMaNGOS database repo

GIT_DB_REPO_COMMIT=...           # (Optional) The branch/commit to checkout for the
                                 #   CMaNGOS database repo. Defaults to master
GIT_CMANGOS_REPO_COMMIT=...      # (Optional) The branch/commit to checkout for the
                                 #   CMaNGOS repo. Defaults to master
GIT_PLAYERBOTS_REPO_COMMIT=...   # (Optional) The branch/commit to checkout for the
                                 #   playerbots repo. Defaults to master

# Metrics (Required only if running metrics services)
## InfluxDB
INFLUX_USER=...                  # InfluxDB username
INFLUX_PASS=...                  # InfluxDB password
INFLUX_TOKEN=...                 # InfluxDB token

## Grafana
GRAFANA_USER=...                 # Grafana username
GRAFANA_PASS=...                 # Grafana password
```

2. Build CMaNGOS
    - Run `docker compose build cmangos`

3. Install databases
    - **WARNING: Running this deletes the entire database and all contents. If you only want to update the current database see [Database updates](#Database-updates)**
    - Run `docker compose run --rm database-migrations /root/run-migration.sh`

4. (Optional) Extract files from the client - [Reference](https://github.com/cmangos/issues/wiki/Installation-Instructions#extract-files-from-the-client)
    - **NOTE: Do if you don't already have the necessary extracted files**
    - Create the `./data/extractor/client` directory
    - Move all contents of the retail client folder into the `./data/extractor/client` directory
    - Run `docker compose run --rm extractor /root/run-extractor.sh`
    - Skip to `Step 6`

5. (Optional) Add extracted files
    - **NOTE: Only if you have the necessary extracted files**
    - Create the `./data/extractor/resources` directory
    - Copy the extracted folders to the `./data/extractor/resources` directory
        - `dbc`
        - `maps`
        - `vmaps`
        - (Optional) `Cameras`
        - (Optional) `mmaps`
        - (Optional) `Buildings`

6. (Optional) Set [config](#setting-mangosdahbotaiplayerbotrealmdanticheat-config)

7. Start servers
    - Run `docker compose up -d`
    - __Note: Starting the `mangosd-server` for the first time may take some time to initialize as it's building the cache in the database__


## Setting mangosd/ahbot/aiplayerbot/realmd/anticheat config

- Create `./cmangos.env` file
- Add one config setting per line in the format `key=value`
    - For `mangosd.conf`, `ahbot.conf`, and `aiplayerbot.conf` settings, prepend with `Mangosd_` and replace periods with underscores.
        - Setting `AhBot.PriceMultiplier = 0.5`
            - Add `Mangosd_AhBot_PriceMultiplier=0.5`
    - For `realmd.conf` settings, prepend with `Realmd_` and replace periods with underscores.
        - Setting `WrongPass.MaxCount = 10`
            - Add `Realmd_WrongPass_MaxCount=10`
    - For `anticheat.conf` config, prepend with `Anticheat_` and replace periods with underscores.
        - Setting `IPBanDelay.Max = 120`
            - Add `Anticheat_IPBanDelay_Max=120`
- Changes will only apply after restarting containers
    - `docker compose restart`


## Database updates

1. Run `docker compose run --rm database-migrations /root/db-migration.sh`
2. Go through the menus to apply updates / settings


## Account creation

1. Attach stdio to running `mangosd-server` container
    - `docker compose attach mangosd-server`
2. Refer to [link](https://github.com/cmangos/issues/wiki/Installation-Instructions#creating-first-account) to create an account
3. Exit prompt by doing <kbd>Ctrl+p</kbd> then <kbd>Ctrl+q</kbd>
    - Note: Closing the terminal or pressing <kbd>Ctrl+c</kbd> will cause the running server to stop


## Changing realmlist IP

1. Update client realmlist
    - Value should be the same as `MANGOS_PUBLIC_IP` set in the `.env`
    - `127.0.0.1` or LAN IP address or public IP of the server
    - See [link](https://github.com/cmangos/issues/wiki/Installation-Instructions#configuring-your-wow-client)


## Enabling metrics services

__*WARNING: If allowing public access to metrics services, you should configure and enable HTTPS*__

1. Enable metrics by adding the following line to `./cmangos.env`
    - `Mangosd_Metric_Enable=1`
2. Create `grafana` data dir
    - `mkdir -p ./data/grafana`
3. Set owner of grafana dir
    - `sudo chown 472:0 ./data/grafana`
4. Start metrics services
    - `docker compose --profile metrics up -d`
