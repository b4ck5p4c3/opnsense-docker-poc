## Prerequisites
1. Make sure you have opnsense.tar.gz in repository root that contains files from /usr/local/opnsense server directory;
2. Copy .env.example to .env and fill variables;
3. Application domain (opnsense.local by default) must be resolved from localhost. 

## Installation & Usage
```sh
mkdir src && tar -xvf opnsense.tar.gz --strip-components=3 -C src
cp -f index.php src/www
docker compose -f docker-compose.yaml up
```
