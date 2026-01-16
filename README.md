# OrderCore

**Agent-First Commerce Backend** — API-first headless commerce infrastructure designed for AI agents.

[![CI/CD](https://github.com/RulezZzOr/ordercore.ai/actions/workflows/ci.yml/badge.svg)](https://github.com/RulezZzOr/ordercore.ai/actions/workflows/ci.yml)
[![Go Version](https://img.shields.io/badge/Go-1.22-blue.svg)](https://go.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Overview

OrderCore provides the commerce primitives AI agents need:
- **Products & SKUs** — Catalog management with variants
- **Inventory** — Real-time stock with reservations
- **Pricing** — Customer-specific pricing, quantity breaks
- **Orders** — Idempotent order creation, state machine
- **Webhooks** — Event-driven integrations

## Quick Start

### Prerequisites
- Go 1.22+
- Docker & Docker Compose
- Make

### Local Development

```bash
# Clone
git clone https://github.com/RulezZzOr/ordercore.ai.git
cd ordercore.ai

# Start PostgreSQL
make local-up

# Run migrations
export DATABASE_URL="postgres://ordercore:ordercore@localhost:5432/ordercore?sslmode=disable"
make migrate-up

# Run the API
make run

# Health check
curl http://localhost:8080/health
```

### Available Make Commands

```bash
make help          # Show all commands
make build         # Build binary
make run           # Run locally
make test          # Run tests
make lint          # Run linter
make docker-build  # Build Docker image
make local-up      # Start local PostgreSQL
make local-down    # Stop local PostgreSQL
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Health check |
| GET | `/v1/products` | List products |
| POST | `/v1/products` | Create product |
| GET | `/v1/inventory` | List inventory |
| POST | `/v1/inventory/reserve` | Reserve stock |
| GET | `/v1/prices` | Get prices |
| POST | `/v1/orders` | Create order |
| POST | `/v1/orders/{id}/confirm` | Confirm order |

## Configuration

Environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | `8080` | Server port |
| `ENVIRONMENT` | `development` | Environment name |
| `DATABASE_HOST` | `localhost` | PostgreSQL host |
| `DATABASE_PORT` | `5432` | PostgreSQL port |
| `DATABASE_NAME` | `ordercore` | Database name |
| `DATABASE_USER` | `ordercore` | Database user |
| `DATABASE_PASSWORD` | - | Database password |

## Project Structure

```
ordercore.ai/
├── cmd/api/              # Application entrypoint
├── internal/
│   ├── api/              # HTTP handlers, middleware
│   ├── config/           # Configuration
│   ├── domain/           # Business logic
│   └── infrastructure/   # Database, Pub/Sub
├── migrations/           # SQL migrations
├── terraform/            # GCP infrastructure
└── .github/workflows/    # CI/CD
```

## Infrastructure

Deployed on Google Cloud Platform:
- **Cloud Run** — Serverless containers
- **Cloud SQL** — Managed PostgreSQL
- **Pub/Sub** — Event messaging
- **Cloud Armor** — WAF (production)

See [`terraform/README.md`](terraform/README.md) for deployment instructions.

## License

MIT — see [LICENSE](LICENSE)

---

Built by [Cloudpeakify](https://cloudpeakify.com)
