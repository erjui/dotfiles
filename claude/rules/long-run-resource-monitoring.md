# Long-running jobs: periodic resource monitoring (RAM / GPU)

Use this when **debugging or supervising a long-running process** (training, heavy ETL, builds) where **resource exhaustion** is plausible: **host RAM**, **GPU VRAM**, or related limits (cgroups, job schedulers).

## Why this matters

- **OOM kills** (system, CUDA, or the runtime) often **terminate the process abruptly**, so **application logs may stop mid-line** or never flush. That makes post-mortem diagnosis harder for both you and the assistant.
- **Periodic snapshots** give a **timeline**: whether memory **crept up**, **spiked at a phase**, or stayed flat until a sudden failure—evidence you can inspect **after** the run ends or crashes.

## Default stance

- **Do not** rely only on final logs when resource pressure is a concern. **Do** arrange **lightweight sampling every few minutes** (typical range **2–5 minutes**; tighter if the run is short or leaks are suspected) to a **dedicated artifact** (log file or metrics dir) the user can share or you can read later.
- Prefer **append-only** lines with a **timestamp** on each sample so ordering is obvious.

## What to capture (tailor to the job)

- **Process / host**: RSS (or working set), optional VSZ; **PID** and **command name** if multiple processes matter.
- **GPU** (NVIDIA): `nvidia-smi` (or equivalent) for **memory used / total**, utilization, and **which PID** holds the device when available.
- **Optional**: disk free on scratch/output volumes; thread count if the runtime is known to spawn many threads.

Keep overhead low: one short subprocess or a tiny sidecar script is enough; avoid heavy profilers in the hot path unless explicitly debugging performance.

## Practical patterns (pick what fits the environment)

- **Shell loop** in a second terminal or `tmux` pane: every N minutes, append `date`, `ps`/`top` snapshot for the target PID, and `nvidia-smi` (if GPUs) to e.g. `run-resources.log`.
- **Python**: `psutil` for the process tree; subprocess call to `nvidia-smi --query-gpu=... --format=csv` on an interval; log as CSV or one JSON object per line.
- **Training stacks**: if the framework exposes **step-level memory** (e.g. peak alloc), log that **in addition to** OS/GPU snapshots—both views help.

## After a crash or kill

- **First** read the **resource log** (last lines before exit): look for **monotonic growth**, **sudden jumps** at a known phase, or **GPU memory pinned at limit**.
- Correlate timestamps with **training step / epoch / pipeline stage** if those appear in the main log.
- If snapshots are missing, **propose adding them** before the next long run rather than guessing from incomplete traces.

## Relation to other rules

- This **complements** isolation and short-run checks: shrink the problem first when possible; **still** monitor resources on **integration / full** runs where OOM is a risk.

## What to avoid

- Assuming “no error in the app log” means the failure was not memory-related.  
- **Only** suggesting a full rerun without a **repeatable** resource trace when overflow is suspected.
