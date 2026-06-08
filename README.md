# Splatograph OpenVINS ROS2 Jazzy Container

CPU/AMD-compatible ROS2 Jazzy OpenVINS image for Splatograph pose input.

## Image

```bash
docker pull ghcr.io/bjoernellens1/splatograph-openvins:jazzy
```

## Run

```bash
docker compose up slam
```

For bag replay from `./bags`:

```bash
BAG_PATH=/bags/input docker compose --profile bag up bag slam
```

For Splatograph integration:

```bash
docker compose -f compose.splatograph.yml up
```

## ROS Contract

Default input/output topics are documented in `config/default.yaml`. Provider output is normalized for Splatograph around `/slam/pose`, `/slam/odom`, `/slam/path`, and `/tf` where the upstream method publishes those streams.

## Upstream

- Upstream: https://github.com/rpng/open_vins
- Pinned reference for initial implementation: `master@69488123ed9362dd44b6f28e7f4680abbff1442b`
- ROS distro: Jazzy
- Platform: `linux/amd64`
- Runtime policy: CPU/AMD-compatible, no NVIDIA runtime dependency

## Smoke Test

```bash
docker build -t ghcr.io/bjoernellens1/splatograph-openvins:jazzy .
docker run --rm ghcr.io/bjoernellens1/splatograph-openvins:jazzy splatograph-smoke
docker compose config
```
