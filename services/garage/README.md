# Garage with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [**Garage**](https://garagehq.deuxfleurs.fr/) with tailscale as a sidecar container. Allowing you to securely host your own S3 compatible backend on your tailnet

## Garage

[**Garage**](https://garagehq.deuxfleurs.fr/) is an S3 compatible storage solution designed for self hosting at a small scale. Supporting Geo-replication and redundancy optimised for performance and resiliance to node failures.

## Key Features

- S3 API
- Geo-distribution
- Flexible deployments
- Multiple replication modes
- Compression & Deduplication
- And many more [**here**](https://garagehq.deuxfleurs.fr/documentation/reference-manual/features/)

## Configuration Overview

In this deployment, the `tailscale-garage` service runs the Tailscale client to establish a secure private network. The `garage` container uses `network_mode: service:tailscale-garage` to route its traffic through the Tailscale interface. This ensures that all Garage api routes are only accessible securely through your tailnet.

| Port | Purpose | Address |
|:-----|:--------|:--------|
| 3900 | S3 API  | `https://garage.<tailnet>.ts.net` |
| 3902 | Static Websites | `https://garage.<tailnet>.ts.net:3902` |
| 3903 | Admin API & Metrics | `https://garage.<tailnet>.ts.net:3903` |

## Files to check

Please check the following variables in the .env file

- `TS_AUTHKEY` // Auth Key from [https://tailscale.com/admin/authkeys](https://tailscale.com/admin/authkeys)
- `TZ` // Configure the correct time zone
- `GARAGE_RPC_SECRET` //Generate from the command in `.env`
- `GARAGE_ADMIN_TOKEN` //Generate from the command in `.env`
- `GARAGE_METRICS_TOKEN` //Generate from the command in `.env`

## Setup Guidelines

Before you start using garage you need to configure your instance.

### 1. Check Garage is configured correctly

```bash
docker exec app-garage /garage status
```

You should get a output like this:

```bash
==== HEALTHY NODES ====
ID                Hostname  Address         Tags  Zone  Capacity          DataAvail  Version
4014a6c5a274f246  garage    127.0.0.1:3901              NO ROLE ASSIGNED             v2.3.0
```

### 2. Configure the layout

```bash
docker exec app-garage /garage layout assign -z dc1 -c 1G <node ID>
```

node ID is taken from step 1 e.g. 4014a6c5a274f246

To assign more than 1GB of storage change the ``` 1G ``` parameter in the command.

### 3. Apply the configured layout

```bash
docker exec app-garage /garage layout apply --version 1
```

### 4. Create a bucket

```bash
docker exec app-garage /garage bucket create test-bucket
```

### 5. Create a key

```bash
docker exec app-garage /garage key create my-key
```

Save these credentials and keep them secret!

### 6. Grant key access to the test-bucket bucket

```bash
docker exec app-garage /garage bucket allow --read --write --owner test-bucket --key my-key
```

### Congratulations your all setup with a s3 compatible bucket and key for more info take a look at the [documentation](https://garagehq.deuxfleurs.fr/documentation/quick-start/)
