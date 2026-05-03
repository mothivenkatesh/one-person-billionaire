"""Typed settings loaded from .env. Single source of truth for all API keys + infra."""

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env", env_file_encoding="utf-8", extra="ignore"
    )

    # INPUT
    hubspot_api_key: str = Field(default="")
    fathom_api_key: str = Field(default="")
    ahrefs_api_key: str = Field(default="")
    meta_ads_access_token: str = Field(default="")

    # BRAIN
    openrouter_api_key: str = Field(default="")
    anthropic_api_key: str = Field(default="")

    # OUTPUT
    smartlead_api_key: str = Field(default="")
    dripify_api_key: str = Field(default="")
    typefully_api_key: str = Field(default="")
    slack_bot_token: str = Field(default="")

    # INFRA
    database_url: str = "postgresql://gtm:gtm@localhost:5432/gtm_ops"
    redis_url: str = "redis://localhost:6379/0"

    # KNOWLEDGE
    llm_wiki_path: str = ""

    # DEMO
    log_level: str = "INFO"
    demo_mode: bool = True


settings = Settings()
