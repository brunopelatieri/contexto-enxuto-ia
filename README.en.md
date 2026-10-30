# Lean Context

**Your AI coding agent reads only what matters, on every task.**

[🇧🇷 Português](./README.md) · 🇺🇸 English

> _Fewer tokens. Better rule adherence. Zero rules lost._

A kit to slim down the context that **Claude Code** (and Cursor/Codex) loads at the start of every session — plus a guide to writing prompts that exploit it, so you ship better features while spending fewer tokens.

Inspired by the [ECC — Everything Claude Code](https://github.com/affaan-m/ECC) pattern ("_Optimize the context window. Persist everything else._"), adapted for real Next.js + Supabase projects.

> **Language note:** the full kit (guide, tutorial, prompts, templates, scripts) is written in Brazilian Portuguese. This page is the English entry point; the prompts and templates use `{{PLACEHOLDERS}}`, and the scripts are plain bash, so they work in any language. Machine translation of the guides reads fine.

## The problem

Your `CLAUDE.md` / `AGENTS.md` grew into a 20–40 KB document: a spec index, a repo map, conventions, history. Every session pays for all of it — even to change one translation string. Cache makes it cheaper, not free, and irrelevant text still dilutes the model's attention to the rules that matter.

## The idea in 60 seconds

Load each piece of information **when it is needed — no sooner, no later — and keep it in one place only.**

| Question                                      | Where it goes                                      |
| --------------------------------------------- | -------------------------------------------------- |
| Does forgetting it cause damage in any task?  | Always-loaded, short `AGENTS.md` (non-negotiables) |
| Does it matter only when touching certain files? | Rule with `paths:` (loads only then)            |
| Is it a multi-step procedure?                 | Skill (body loads only when invoked)               |
| Is it reference material?                     | `docs/context/` file, read by path                 |
| Is it a fact that changes over time?          | Dated `status.md` — the only home for volatile data |
| Must it never depend on model obedience?      | `permissions.deny` / hook (zero context cost)      |

Change things **additively**: build everything first, verify, and shrink the root file last. Then **prove it**: measure before/after, run routing tests in a fresh session, compare `sha256sum` manifests.

**Target:** −65% to −75% of the always-loaded bytes, with equal or better rule adherence (the case study aimed for −68%).

## Start here

| You want to…                              | Go to                                                             |
| ----------------------------------------- | ----------------------------------------------------------------- |
| Apply it to your project (7 steps)        | [tutorial/README.md](./tutorial/README.md)                        |
| Just copy the master prompt               | [prompts/01-diagnostico-e-spec.md](./prompts/01-diagnostico-e-spec.md) |
| Understand why before touching anything   | [guia/01-por-que-contexto-custa.md](./guia/01-por-que-contexto-custa.md) |
| Write better prompts after optimizing     | [engenharia-de-prompts/README.md](./engenharia-de-prompts/README.md) |
| See real numbers                          | [exemplos/estudo-de-caso-zap-crm-br.md](./exemplos/estudo-de-caso-zap-crm-br.md) |

## What's inside

- `guia/` — concepts: why context costs, verified Claude Code mechanisms, the ECC pattern, target architecture, pitfalls, maintenance.
- `tutorial/` — 7 steps: measure → classify → design the SPEC → build → swap the root → validate → maintain.
- `prompts/` — ready prompts with `{{KEYS}}` to fill once.
- `engenharia-de-prompts/` — the 8-part feature prompt, models per stage, anti-patterns, measuring.
- `templates/` — `CLAUDE`, `AGENTS`, `status`, `INDEX`, domain docs, rules, Cursor rules, skills, `permissions.deny`.
- `scripts/` — read-only bash tools: measure always-loaded context, hygiene check, fill prompt variables.

## Requirements

Recent Claude Code (behaviors checked against the official docs in 2026-10, see [CREDITOS.md](./CREDITOS.md)); Bash (Linux/macOS, or Git Bash on Windows). Cursor/Codex optional.

## License

To be defined before publishing (MIT suggested — same as ECC). This material adapts ideas from ECC; it does not copy its code.

---

Maintained by [Bruno Pelatieri](https://github.com/brunopelatieri).
