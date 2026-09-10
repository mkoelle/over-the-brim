# Task Sizing Standard

Guidance for breaking design docs and milestones into implementable units.

## Right size

One script+scene pair, one system responsibility, verifiable standalone in the
editor, completable in a single sitting (~1-4 hours).

This follows the same rule as scene design (AGENTS.md: "one scene, one
responsibility"). If a task can't be described as touching 1-3 files with one
verification step, it's the wrong size.

## Too big

Bundles multiple responsibilities with no checkpoint until all are done.

Example: "Implement vehicle movement" (physics + input + drift + VFX + audio
in one task). Split by responsibility instead.

## Too small

No acceptance criteria worth writing, no independent verification step.

Example: "add speed variable" as its own task — fold it into the task that
consumes it.

## Test

A task is correctly sized when:

- Acceptance criteria fit as a short checklist (not a single item, not 10+).
- Files affected: 1-3.
- Verification is a single concrete action (run scene, observe behavior).
- Dependencies are explicit and few (0-2 other tasks).
- If a task needs "and also fix X" as a caveat mid-write, split it.

## Sequencing

Order tasks so each one is playable/testable on its own before the next
builds on it. Don't let unrelated systems (networking, UI polish, secondary
mechanics) block the core loop task under test — per STATE.md's
"Over-Engineering Before Fun" risk.
