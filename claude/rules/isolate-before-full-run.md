# Long-running pipelines: isolate components before full runs

Use this whenever debugging or changing code inside a **multi-step** workflow where an end-to-end run is **slow** (e.g. deep learning training ~1h, heavy ETL, multi-stage builds).

## Default stance

- **Do not** use a full long run as the first way to verify a localized change. Treat a 1h (or similarly expensive) job as a **final integration check**, not the inner loop.
- **Do** split the system into **testable units**, then validate the changed unit with **fast feedback** (seconds to a few minutes) before scaling up.

## Workflow (apply in order)

1. **Map the pipeline**  
   Name each stage (data load → preprocess → model → train loop → eval → export, etc.) and identify **which stage** the bug or change touches.

2. **Define the minimal surface to test**  
   For that stage only, specify inputs (shapes, dtypes, file paths) and expected outputs. If upstream stages are slow or irrelevant, **replace them** with fixtures.

3. **Prefer these isolation tactics** (combine as needed)  
   - **Dummy / synthetic inputs**: small tensors, `torch.randn(2, 3, 32, 32)`, in-memory `Dataset` with 1–8 samples, fixed seeds.  
   - **Subset real data**: `num_samples`, `max_batches`, `limit_train_batches`, first N files only.  
   - **Short schedules**: 1–2 steps or 1 epoch on toy data; `fast_dev_run` / `overfit_batches` patterns where the framework supports them.  
   - **Smaller model or layer-only checks**: single block, single forward + backward, `torch.autograd.gradcheck` on tiny inputs when appropriate.  
   - **Mocks / stubs**: fake dataloaders, temp dirs, no network unless the change is network-specific.  
   - **Offline tests**: pure functions and classes tested with `pytest` (or the project’s test runner) without launching the full training job.

4. **Escalate deliberately**  
   After the isolated check passes, move up one level (e.g. short real-data chunk → short full-pipeline run with capped steps) **only then** consider the full long run.

5. **Make repeatability explicit**  
   When you add a temporary shortcut (debug flags, env vars, CLI args), say how to **reproduce** the fast check and what to run for the final full validation.

## When the user (or task) implies a long run

- Propose **concrete** fast commands or snippets (e.g. “run this 10-step script / this pytest”) before suggesting “kick off full training.”  
- If the codebase lacks hooks for small runs, **suggest minimal code changes** (config defaults, `if debug:` branch, or a tiny entry script) so future fixes do not require another full-hour loop.

## What to avoid

- Running the entire pipeline repeatedly to test a change confined to one module without first trying isolation.  
- Vague advice like “just retrain” when a cheaper verification path exists.
