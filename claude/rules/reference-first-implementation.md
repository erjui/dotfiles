# Implementation choices: consult authorities before inventing

When **implementation details are not specified** by the user, **do not** pick conventions ad hoc or “guess and debug.” **First** investigate how the field and reference projects do it, then **follow established practice** unless the user opts out.

## Default order

1. **Authoritative sources first** (in rough priority, use what exists for the task):  
   - **Upstream / official repo**: README, docs, `examples/`, default configs, issue discussions, release notes.  
   - **Paper or spec** the code implements: methods section, appendix, official supplementary material.  
   - **Standard benchmarks / leaderboards** and their **official evaluation protocols** (what metric, split, preprocessing, seed handling).  
   - **Widely used libraries** in that niche (documented defaults and recommended patterns).

2. **Align implementation** with what those sources prescribe: baselines, dataset conversion scripts, **default hyperparameters**, train/val/test protocol, file layouts, and naming.

3. **Only then** iterate empirically (tuning, debugging runs) when something is genuinely underspecified *after* the literature and reference implementations have been checked.

## Where this applies

- **Baselines** and reproductions: match the reference setup unless explicitly told otherwise.  
- **Dataset conversion / preprocessing**: follow the format and splits used in the original dataset paper or official tooling.  
- **Default parameters**: prefer documented defaults from the paper, official code, or dominant framework—not arbitrary choices.  
- **Evaluation** (especially **NLP and other standardized fields**): **do not** invent a new metric or criterion first. Search for the **standard protocol** (e.g. official GLUE/SuperGLUE-style specs, leaderboard rules, paper’s exact metric definition) and implement that. If multiple conventions exist, state them briefly and pick the one that matches the user’s stated benchmark or paper.

## What to avoid

- Implementing evaluation or data pipelines from memory when a **five-minute doc/paper/repo check** would give the definitive answer.  
- “We’ll use X metric” without verifying that X is what the benchmark or paper uses.  
- Long empirical debugging when the mismatch is actually a **protocol or default** error vs the reference.

## When proposing a plan

- Mention **which** authoritative source you’re following (link, file path, or citation) for non-obvious choices.  
- If sources disagree, summarize the conflict and recommend one **with a reason**, instead of silently picking.
