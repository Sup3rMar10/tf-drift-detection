# tf-drift-detection

A scheduled Terraform pipeline that looks for **drift**, meaning real infrastructure changed outside Terraform, and opens a GitHub issue when it finds some.

A local file stands in for a real resource, so the mechanism can be shown with no cloud account.

## How it works

`terraform plan -detailed-exitcode` returns:

| Exit code | Meaning | Pipeline action |
|---|---|---|
| 0 | no changes | nothing |
| 1 | error | fail the job |
| 2 | changes found | open an issue (once; skipped if one is already open) |

Run it on a schedule (daily here) and drift shows up as an issue instead of as a surprise during the next apply.

## What was checked (2026-10-16)

- **Locally:** `bash drift-demo.sh` printed exit code 0 after apply and 2 after editing the file by hand.
- **On GitHub Actions:** a manual run with `simulate_drift=true` **succeeded** and **opened issue #1** (a test; I closed it afterwards). The scheduled trigger itself has not fired yet.
- **Detail worth knowing:** with this provider, a hand-edited file shows up in the plan as `1 to add` (the provider treats the changed file as gone), not `1 to change`. Other providers report in-place changes as updates.

## Honest limits

- **The baseline step is demo-only.** The workflow applies first, then plans, because there is no persistent state on a fresh runner. With a real remote backend the state already exists and that step is removed; the `plan` step is the real one.
- A plan run needs read access to the real infrastructure, so give the job a read-only role.
- Output can contain sensitive values; check what lands in an issue before using this on a private system, and note that this repository is public.
- Detection only: it does not fix drift. Whether to re-apply or to update the code to match is a decision for a person.
- No chat/pager notification, no per-resource ignore list for noisy attributes.

MIT licensed.
