# Changelog

## v1.2.0 (2026-06-26)

Adds a second mode. visualise can now build interactive playgrounds, not only static explainers.

- **Playground mode.** When the topic is a model or system with adjustable inputs (pricing, a rate limiter, retry and backoff, a cache, a queue), or when you ask to simulate, tune, or play with something, visualise builds a live sandbox instead of a fixed visualization. Step 1 picks the mode and states which one it chose.
- **Playground rules.** Nine rules keep the output consistent: one pure compute function, an always-visible labeled controls panel, live recompute with no Run button, headline output readouts plus a live chart, named presets, pinned scenarios you can compare, scenarios persisted to localStorage, shareable state encoded in the URL, a panel that shows how the result is computed, and a reset control.
- **Logic trace in self-critique.** A screenshot cannot click, so Step 4 now also traces the compute function end to end for playgrounds. It confirms that changing an input moves an output, that presets set a full input set, and that URL state round-trips.
- **New gallery example.** SaaS Unit Economics, a full playground with presets, pin and compare, URL state, and a formula panel. It was built and verified through the self-critique loop, which caught a complete render failure and two smaller defects before release.

## v1.1.0 (2026-06-26)

visualise now reviews its own output before you see it.

- **Self-critique loop (Step 4).** After generating a file, the skill renders it with a headless browser, takes a screenshot, reads the image back, and scores it against a checklist (dead space, overlapping labels, clipping, blank renders). It fixes what it finds and re-renders, up to three passes, then opens the result. This catches layout problems that the source code gives no sign of.
- **scripts/shoot.sh.** A portable headless-screenshot helper that finds Chrome, Chromium, Edge, or Brave on macOS and Linux. If no browser is available, it skips the visual pass instead of failing.
- **Built-in PNG export (Hard Rule 9).** Every generated visualization ships with a top-right Export PNG button at 2x resolution, with strategies for canvas, SVG, and DOM output.
- **Fill-the-frame rule (Hard Rule 10).** Wasted empty space is the most common defect, so it is now an explicit rule and the main target of the self-critique pass.
- **New gallery example.** Token Bucket Rate Limiter, a live simulation that demonstrates the export button and a frame-filling layout.

## v1.0.0 (2026-05-27)

Initial public release.

- SKILL.md: 13 visualization types, dark theme, interactive-first design
- Gallery: 8 pre-generated example visualizations
- GitHub Pages: live gallery at https://qlawd.github.io/visualise
- CI: HTML validation, SKILL.md linting, automatic Pages deployment
- Zero dependencies, zero runtime, zero config
