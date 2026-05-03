---
name: worker-gemini
description: Use when delegating high-context engineering tasks to a Gemini CLI worker agent. Defines the protocol for structured task handoff, autonomous execution, and verification.
version: 1.0.0
author: Gemini CLI
license: MIT
metadata:
  hermes:
    tags: [delegation, gemini, worker, autonomous, project-nexus]
    related_skills: [subagent-driven-development, executing-plans]
---

# Worker Gemini Protocol

## Overview

This skill defines how to effectively "put Gemini to work" on complex engineering tasks. Gemini CLI is a high-bandwidth, tool-capable worker agent optimized for deep codebase modification, research, and implementation.

## When to Use

Use this skill when:
- You need a specialized worker to implement a multi-file feature.
- You want to delegate a "Research -> Strategy -> Execution" cycle.
- The task requires parallel tool execution or heavy Python-based logic.
- You are working on the **Project Nexus / Space Universe** mod engine.

## Task Handoff Format

When dispatching a task to Gemini, use the following structure:

### 1. Context & Role
Explicitly state Gemini's role and the project context.
> "You are the Lead Engineer for Project Nexus. You are working in a Linux environment with the Ship of Harkinian modding stack."

### 2. The Objective
Define a clear, measurable goal.
> "Implement the 'Pokemon Synergy' system in `engine/skills/pokemon_synergy.py`. This system must allow Pokemon types to provide buffs to ship systems (e.g., Electric types boost shield regeneration)."

### 3. Constraints & Standards
List the technical standards Gemini must follow.
- Use `registry.reg` for state management.
- Follow the `class Skill` pattern for `SkillLoader` compatibility.
- Ensure all new logic is covered by unit tests in `tests/`.

### 4. Verification Requirements
Tell Gemini exactly how to prove the work is done.
- "Run the engine with `--console` and verify the `synergy.status` command works."
- "All tests in `tests/skills/test_synergy.py` must pass."

## Gemini's Superpowers (Leverage These!)

- **Parallelism:** Gemini can run multiple `glob`, `read_file`, and `run_shell_command` calls in parallel.
- **Output Capacity:** Gemini can return up to 32,000 characters of output per turn.
- **Python Execution:** Use `execute_code` for complex data manipulation or ROM analysis.
- **Project Memory:** Gemini maintains `MEMORY.md` and `GEMINI.md` to persist project-specific facts.

## The Interaction Loop

1. **Strategy Approval:** Ask Gemini to provide a plan before it touches any files.
2. **Batch Execution:** Allow Gemini to execute multiple steps autonomously.
3. **Artifact Review:** Inspect the `write_file` and `replace` results in the session history.
4. **Final Handoff:** Gemini will provide a summary of "Got" (acquired resources) and "Done" (implemented features).

## Specific to Project Nexus (Space Universe)

When working on the Zelda Space Universe:
- **ROM Integration:** Always verify `rom_database.json` presence.
- **Ship Parts:** Parts are stored in `equipped_parts` dictionary on the ship entity.
- **Zones:** Navigation relies on `fuel_cost` (warp cells) check.
- **Nexus Companion:** All player advice should be routed through `engine/skills/ai_companion.py`.

## Red Flags

- **Blind File Edits:** Gemini should always `read_file` or `grep_search` before editing to ensure context is current.
- **Skipping Tests:** A task is not "Done" until `pytest` or a manual verification script confirms it.
- **Ambiguous State:** If the engine state is unclear, Gemini must use `status` or read `current_state.json`.

---

**Protocol Active.** Ready to work for Hermes.
