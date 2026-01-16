.PHONY: all build run test lint clean docker-build docker-run migrate help

# Variables
BINARY_NAME=ordercore
MAIN_PATH=./cmd/api
DOCKER_IMAGE=ordercore:latest

# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GORUN=$(GOCMD) run
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
GOMOD=$(GOCMD) mod

# Default target
all: lint test build

## help: Show this help message
help:
	@echo "OrderCore - Agent-First Commerce Backend"
	@echo ""
	@echo "Usage:"
	@echo "  make <target>"
	@echo ""
	@echo "Targets:"
	@sed -n 's/^##//p' $(MAKEFILE_LIST) | column -t -s ':' | sed -e 's/^/ /'

## build: Build the binary
build:
	CGO_ENABLED=0 $(GOBUILD) -ldflags="-s -w" -o $(BINARY_NAME) $(MAIN_PATH)

## run: Run the application
run:
	$(GORUN) $(MAIN_PATH)

## test: Run tests
test:
	$(GOTEST) -v -race -coverprofile=coverage.out ./...

## test-short: Run short tests only
test-short:
	$(GOTEST) -v -short ./...

## coverage: Show test coverage
coverage: test
	$(GOCMD) tool cover -html=coverage.out -o coverage.html
	@echo "Coverage report: coverage.html"

## lint: Run linter
lint:
	golangci-lint run ./...

## lint-fix: Run linter with auto-fix
lint-fix:
	golangci-lint run --fix ./...

## clean: Clean build artifacts
clean:
	rm -f $(BINARY_NAME)
	rm -f coverage.out coverage.html
	rm -rf tmp/

## deps: Download dependencies
deps:
	$(GOMOD) download
	$(GOMOD) tidy

## docker-build: Build Docker image
docker-build:
	docker build -t $(DOCKER_IMAGE) .

## docker-run: Run Docker container
docker-run:
	docker run -p 8080:8080 --env-file .env $(DOCKER_IMAGE)

## migrate-up: Run database migrations
migrate-up:
	migrate -path ./migrations -database "$(DATABASE_URL)" up

## migrate-down: Rollback last migration
migrate-down:
	migrate -path ./migrations -database "$(DATABASE_URL)" down 1

## migrate-create: Create new migration (usage: make migrate-create NAME=create_users)
migrate-create:
	migrate create -ext sql -dir ./migrations -seq $(NAME)

## dev: Start development server with hot reload
dev:
	air

## setup-dev: Install development tools
setup-dev:
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	go install github.com/air-verse/air@latest
	go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest

## psql: Connect to local PostgreSQL
psql:
	psql "$(DATABASE_URL)"

# Local development environment
## local-up: Start local dev environment (PostgreSQL)
local-up:
	docker compose up -d

## local-down: Stop local dev environment
local-down:
	docker compose down

## local-logs: Show local dev logs
local-logs:
	docker compose logs -f
