# MStack — marketplace common commands
#
# Targets:
#   make help     Show this help
#   make lint     Validate marketplace.json + plugin.json + frontmatter + dups + conflict markers
#   make stats    Print live marketplace stats (plugins, skills, commands, lessons, words)
#   make sweep    Find any SKILL.md where dir != name field
#   make catalog  Regenerate SKILLS.md from frontmatter; print reality report
#   make check    Full repo health: lint + sweep + catalog (CI entry point)

.PHONY: help lint stats sweep catalog check

help:
	@echo "MStack — Makefile targets:"
	@echo ""
	@echo "  make lint     Validate marketplace + plugins + frontmatter + dups + conflicts"
	@echo "  make stats    Print live marketplace stats"
	@echo "  make sweep    Find any SKILL.md where dir != name field"
	@echo "  make catalog  Regenerate SKILLS.md + print reality counts"
	@echo "  make check    Lint + sweep + catalog (CI entry point)"
	@echo ""

lint:
	@python3 scripts/validate.py

catalog:
	@python3 scripts/build_catalog.py

check: lint sweep catalog
	@echo ""
	@echo "✓ make check passed (lint + sweep + catalog)"

stats:
	@echo "Marketplace stats:"
	@printf "  Plugins:        %s\n" "$$(ls -d plugins/*/ 2>/dev/null | wc -l | tr -d ' ')"
	@printf "  Skills (total): %s\n" "$$(find plugins -path '*/skills/*/SKILL.md' | wc -l | tr -d ' ')"
	@printf "  Commands:       %s\n" "$$(ls plugins/*/commands/*.md 2>/dev/null | wc -l | tr -d ' ')"
	@printf "  Lessons:        %s\n" "$$(ls -d plugins/opb-curriculum/lessons/[0-9]*-*/ 2>/dev/null | wc -l | tr -d ' ')"
	@printf "  Templates:      %s\n" "$$(ls plugins/opb-curriculum/templates/*.md 2>/dev/null | wc -l | tr -d ' ')"
	@printf "  Total .md words: %s\n" "$$(find plugins -name '*.md' -not -path '*/upstream/*' | xargs wc -w 2>/dev/null | tail -1 | awk '{print $$1}')"
	@echo ""
	@echo "Per-plugin skill counts:"
	@for p in plugins/*/skills; do \
		plugin=$$(echo $$p | sed 's|plugins/||;s|/skills||'); \
		count=$$(ls -d $$p/*/ 2>/dev/null | wc -l | tr -d ' '); \
		printf "  %-20s %s\n" "$$plugin:" "$$count"; \
	done

sweep:
	@find plugins -path '*/skills/*/SKILL.md' | while read f; do \
		dir=$$(basename $$(dirname $$f)); \
		name=$$(awk '/^---$$/{c++; if(c==2)exit} /^name:/{gsub(/^name: */,""); gsub(/[\"\x27]/,""); print; exit}' $$f); \
		if [ -n "$$name" ] && [ "$$dir" != "$$name" ]; then \
			echo "MISMATCH dir=$$dir name=$$name $$f"; \
		fi; \
	done
	@echo "✅ Sweep complete (no output above = all clean)."
