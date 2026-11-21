# Task Dependency Waves

Plan an execution order for dependent tasks and identify dependency cycles before running the plan.

![Sample run from Task Dependency Waves](docs/demo.webp)

## Run

Install PowerShell 7 or newer. Run these commands from the repository root.

```sh
pwsh -NoProfile -File app.ps1 sample.json
```

Replace `sample.json` with a JSON file following the same structure. The app prints a JSON report to standard output.

Enter an object keyed by task names and list its prerequisites. Each wave contains tasks whose prerequisites are complete in earlier waves.

## Verify

Run `python check.py` with Python 3.11 or newer after the build step when applicable. The check verifies the bundled scenario and confirms that an invalid input returns an error.
