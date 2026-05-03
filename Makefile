.PHONY: setup seed dashboard meeting-prep crm-enrichment lint test eval clean

setup:
	cp -n .env.example .env || true
	uv sync
	docker compose up -d

seed:
	docker exec -i gtm-ops-postgres psql -U gtm -d gtm_ops < sql/001_schema.sql

dashboard:
	@echo "Metabase → http://localhost:3000"

meeting-prep:
	uv run gtm-ops meeting-prep --deal-id=1

crm-enrichment:
	uv run gtm-ops crm-enrichment --deal-id=1

lint:
	uv run ruff check .
	uv run mypy src/

test:
	uv run pytest

eval:
	cd evals && npx promptfoo eval

clean:
	docker compose down -v
	rm -rf .venv/ __pycache__/
