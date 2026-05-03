"""OpenRouter client — single API across Claude / GPT / Gemini / Llama with cost routing.

Tiers:
    - cheap → Llama 3.3 70B (batch enrichment, fan-out loops)
    - fast  → Claude Haiku 4.5 (drafting, summarization)
    - smart → Claude Opus 4.7 (synthesis, final briefs)
    - vision → GPT-4o (image + document understanding)
"""

from openai import AsyncOpenAI

from ..config import settings


class OpenRouterClient:
    """Thin wrapper that uses the OpenAI SDK with OpenRouter's base URL."""

    MODELS = {
        "cheap": "meta-llama/llama-3.3-70b-instruct",
        "fast": "anthropic/claude-haiku-4-5",
        "smart": "anthropic/claude-opus-4-7",
        "vision": "openai/gpt-4o",
    }

    def __init__(self, api_key: str | None = None) -> None:
        self._client = AsyncOpenAI(
            api_key=api_key or settings.openrouter_api_key,
            base_url="https://openrouter.ai/api/v1",
        )

    async def complete(
        self,
        tier: str,
        system: str,
        user: str,
        max_tokens: int = 2048,
    ) -> str:
        """Chat completion; `tier` picks the model per MODELS."""
        model = self.MODELS[tier]
        resp = await self._client.chat.completions.create(
            model=model,
            messages=[
                {"role": "system", "content": system},
                {"role": "user", "content": user},
            ],
            max_tokens=max_tokens,
        )
        return resp.choices[0].message.content or ""
