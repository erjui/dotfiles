# Global Claude Code context (user scope)

This file lives in your dotfiles repo and is symlinked from `~/.claude/CLAUDE.md`.
Edit it here so the same instructions apply on every machine after you sync this repo.

## How this is wired

- **User scope**: `~/.claude/CLAUDE.md` — applies across all projects unless a project overrides with its own `CLAUDE.md` / `.claude/CLAUDE.md`.
- **Settings**: `~/.claude/settings.json` — see [Claude Code settings](https://docs.anthropic.com/en/docs/claude-code/settings).
- **Rules**: `~/.claude/rules/*.md` — one topic per file; loaded like `CLAUDE.md` (see [organize rules](https://docs.claude.com/en/docs/claude-code/memory#organize-rules-with-clauderules)). This repo’s `claude/rules/` is symlinked there.
- **Scopes**: User < Project < Local; managed/policy can override further.

## Your defaults (customize below)

- Prefer concise, actionable answers; match the codebase’s style.
- Run tests or linters when you change code, when the project supports it.
- Do not commit secrets; treat `.env` and credential files as sensitive.
