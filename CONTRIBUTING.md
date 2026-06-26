# Contributing to visualise

This project is unusual: the core product is a single prompt file (`SKILL.md`) and the gallery is proof it works. Contributions are welcome. Here is how.

## Three ways to contribute

### 1. Gallery examples (highest impact)

Generate a visualization using the skill, polish it, and submit the HTML file.

**Quality bar:**
- Self-contained single HTML file (inline CSS/JS, CDN deps only)
- Dark theme (`#0a0a0a` background, `#e0e0e0` text)
- At least one interaction (hover, click, drag, or animation)
- Under 500KB
- Descriptive `<title>` tag
- File naming: `{viz-type}-{topic}.html`

**To submit:** open a PR adding your file to `gallery/` with an 800x500 screenshot in `docs/assets/screenshots/`.

### 2. Prompt improvements

Changes to `SKILL.md` require more care, because the prompt is a balanced system.

**Process:**
1. Open an issue first describing the failure mode
2. Include what you typed, what the skill produced, and what it should have produced
3. Keep changes surgical
4. Test your change against 3+ different topics before submitting

### 3. Infrastructure

Improvements to `gallery/index.html`, CI workflows, `serve.py`, README.

## What's less welcome (ask first)

- Adding a runtime, build step, or package manager
- Converting to a different license
- Adding telemetry or external service dependencies
- Major restructuring of SKILL.md

## PR expectations

- One visualization or one prompt change per PR
- Gallery submissions: include a screenshot
- Prompt changes: include the failure case that motivated the change
- Match existing code style

## Local development

Preview the gallery locally:

```bash
python serve.py
```

Opens `http://localhost:8888` in your browser.
