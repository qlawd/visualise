---
name: visualise
description: Generate an interactive HTML visualization OR a live what-if playground for any concept, codebase, data, model, or system. Two modes — Explain (show a thing) and Playground (let the user tune a thing and watch outcomes). Renders itself headless, looks at the result, fixes what's wrong, then opens in browser. Every output ships with a built-in PNG export.
argument-hint: "<topic, concept, or model to visualize / play with>"
allowed-tools: Bash(open *) Bash(python3 *) Bash(bash *) Write Read Edit
---

# Visualise — On-Demand Interactive Explainers & Playgrounds

Generate a **single self-contained HTML file** for the user's topic, open it in the default browser, and iterate on feedback. The file works in one of two **modes**:

- **Explain mode** (default) — *show* a thing. Communicate a concept, codebase, dataset, or design as clearly as possible. This is a visualization the user reads and explores.
- **Playground mode** — *let the user drive* a thing. Build a live what-if sandbox around a model, policy, algorithm, or system: knobs in, outcomes out, recomputed on every change. This is a tool the user operates.

**Topic**: $ARGUMENTS

---

## Step 1: Understand the Topic & Pick the Mode

Before writing any code, figure out **what** you're building and **which mode** fits.

**What you're working with:**

- If the topic references **files, code, or architecture** in the current project — read those files first.
- If the topic references **concepts or knowledge** — check any knowledge base, docs, or wiki in the project, or use your own understanding.
- If the topic references **data or results** — find the actual numbers rather than making them up.
- If the topic is **abstract** (an algorithm, a mental model, a framework) — identify the key components, relationships, and dynamics that need to be shown.

**Which mode (decide explicitly, state it to the user in one line):**

- Default to **Explain mode**.
- Switch to **Playground mode** when *either*:
  - The user signals it — words like *playground, simulate, sandbox, what-if, tune, model, "let me play with", "interactive model", "try different…"*, or
  - The topic **is a model or system with adjustable inputs that drive outcomes** — a pricing/unit-economics model, a rate limiter, a retry/backoff policy, a cache eviction strategy, a load balancer, a Bloom filter, a queueing system, a feature-flag rollout, a physics/math model, "how does X respond when I change Y".
- When it's genuinely both (e.g. "show me how backoff works *and* let me tune it"), build a Playground — it strictly contains Explain.
- If ambiguous, pick the mode you think serves the user and say which one you chose; they can redirect in one sentence.

## Step 2: Choose the Right Visualization Type

Pick the visualization that best serves comprehension. DO NOT default to a simple chart when an interactive exploration would be better.

> **Playground mode?** The table below is for Explain mode. If you chose Playground mode in Step 1, the central element is a **control panel + live model** (see the **Playground Mode** section below) — the table still tells you how to render the *outcome* of the model (a curve, a flow, a heatmap…), but the controls and recompute loop are the point.

| Topic Type | Best Visualization |
|---|---|
| **Models / systems with knobs** | **Playground**: control panel + live-updating outcome (see Playground Mode) |
| **Relationships / dependencies** | Force-directed graph (D3.js) |
| **Flows / pipelines / state machines** | Animated Sankey or state diagram |
| **Hierarchies / taxonomies** | Treemap or radial tree |
| **Time series / equity curves** | Interactive line chart with hover tooltips, zoom |
| **Comparisons / tradeoffs** | Parallel coordinates, scatter matrix, or radar chart |
| **Processes / sequences** | Step-by-step animated walkthrough with play/pause |
| **Spatial / layout** | 2D canvas with draggable elements |
| **Distributions / statistics** | Histogram + violin + box plot combo |
| **Decision trees / branching logic** | Interactive tree with expand/collapse |
| **Concepts with parameters** | Sliders + live-updating canvas/SVG |
| **Architecture / system design** | Box-and-arrow diagram with zoom + pan |
| **Heatmaps / matrices** | Interactive grid with color scale + hover details |
| **Before/after or A/B** | Side-by-side with sync'd interaction |

## Step 3: Generate the HTML

### Hard Rules

1. **Single file.** Everything in one `.html` file — inline `<style>` and `<script>`. No separate CSS/JS files.
2. **CDN deps only.** If you need D3.js, Three.js, or similar — load from CDN. Prefer:
   - D3.js v7: `https://d3js.org/d3.v7.min.js`
   - Three.js: `https://cdn.jsdelivr.net/npm/three@0.160.0/build/three.module.js`
   - For most visualizations, **vanilla JS + SVG/Canvas is enough** — don't reach for D3 unless you need force simulation, complex scales, or data joins.
3. **Dark theme by default.** Background `#0a0a0a` or `#111`, text `#e0e0e0`, accent colors from a tasteful palette.
4. **Responsive.** Use `vw`/`vh` units or resize observers. Fill the browser window.
5. **Interactive.** Every visualization must have at least one interaction: hover tooltips, click-to-expand, drag, sliders, zoom/pan, or animation controls.
6. **Title + context.** Top of page: large title, one-line subtitle explaining what the user is looking at and how to interact.
7. **No placeholder data.** Use real data, real labels, real relationships from the topic. If exact numbers aren't available, use realistic estimates and label them as such.
8. **Performant.** Keep DOM nodes under 2000. For large datasets, use Canvas instead of SVG. Debounce resize handlers.
9. **Built-in PNG export — always.** Every output has a small "Export PNG" button, top-right, that downloads the current view at 2× resolution. This is not optional and not "only if asked." Implementation:
   - **Canvas viz:** draw to an offscreen canvas at 2× and `canvas.toBlob()` → download.
   - **SVG viz:** serialize the `<svg>` with `XMLSerializer`, draw it onto a 2× canvas via an `Image` with a data-URL, then `toBlob()`. Inline the background color so the PNG isn't transparent.
   - **DOM/HTML viz:** load `html2canvas` from CDN (`https://cdn.jsdelivr.net/npm/html2canvas@1.4.1/dist/html2canvas.min.js`) and render the root container at `scale: 2`.
   - Filename: `visualise-{slug}.png`. The button must match the dark theme and never overlap the title or legend.
10. **Fill the frame.** The visualization must use the full viewport — no large dead bands of empty space at the bottom or sides. Size the drawing area to the available width/height (minus header/controls) and recompute on resize. This is the single most common defect; the self-critique pass in Step 4 exists largely to catch it.

### Design Language

- Font: system font stack (`-apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif`) or monospace for data-heavy views
- Rounded corners (4-8px) on cards and containers
- Subtle borders (`1px solid rgba(255,255,255,0.1)`)
- Glow effects sparingly (box-shadow with color accent for active elements)
- Smooth transitions (200-300ms ease)
- Color palette: pick 5-7 distinct colors that work on dark background. Good defaults:
  - `#4ecdc4` (teal), `#ff6b6b` (coral), `#ffd93d` (gold), `#6c5ce7` (purple), `#a8e6cf` (mint), `#ff8a5c` (peach), `#81ecec` (cyan)

### Animation Guidelines

- Use `requestAnimationFrame` for continuous animation, not `setInterval`
- Provide play/pause controls for any animation
- Allow speed control where it makes sense
- Initial state should be meaningful even without animation playing

### Playground Mode — extra rules (when you chose Playground in Step 1)

A playground is a **tool the user operates**, not a picture they read. Everything above still applies; these rules are additional and non-negotiable for this mode.

1. **The model is a pure function.** Write one `compute(inputs) -> outputs` function with no side effects. Every control writes to a single `state` object; every change calls `compute` then `render(outputs)`. No logic smeared across event handlers. This is what makes the thing trustworthy and easy to iterate.
2. **Controls panel.** A clearly grouped, always-visible panel of inputs — sliders, number fields, toggles, dropdowns. Each control shows its **live value and unit** next to its label. Group related controls; label the group. Sensible min/max/step so the user can't drive it into nonsense.
3. **Recompute live.** Outputs update on every input change — no "Run" button for cheap models. For expensive models (>~16 ms), debounce ~120 ms and show a subtle "computing…" state. Never make the user guess whether their change registered.
4. **Outputs are the hero.** Show the key results as **big, labeled readouts** (the 2-4 numbers that matter) *and* a live-updating visualization (curve, flow, bar, heatmap — pick per the Step 2 table). When an output crosses a meaningful threshold (e.g. payback > 24 months, drop rate > 0), signal it with color.
5. **Presets / scenarios.** Provide 2-4 named starting points as buttons (e.g. "Conservative", "Aggressive", "Break-even"). Each sets a full input combination and recomputes. Presets teach the user the interesting regions of the space.
6. **Save & compare.** Let the user snapshot the current inputs+outputs ("Pin scenario") and keep pinned scenarios visible to compare against the live one — as a small table or as ghosted overlays on the chart. Persist pins to `localStorage` so they survive a reload.
7. **Shareable state.** Encode the current inputs in the URL hash (`#r=5&cap=12&…`) and restore from it on load. This keeps the single-file, send-by-link ethos: a tuned scenario *is* a URL. Use this for presets too.
8. **Not a black box.** Show the formula / rule / assumptions somewhere (a collapsible "How this is computed" panel, or inline). The user should be able to see *why* the output moved, not just that it did.
9. **Reset.** A "Reset to defaults" control that clears pins-optional and restores the starting state.

> Explain mode renders a conclusion; Playground mode renders a *space* and hands the user the controls. If the user can't change an input and immediately see the outcome move, it's not a playground yet.

## Step 4: Look At It & Self-Correct (do this BEFORE the user sees anything)

You wrote correct-looking code, but you have no idea what it actually renders as. Find out. This pass is what separates a polished artifact from one that's broken in ways the code doesn't reveal.

1. Save the file to `/tmp/visualise-{slugified-topic}.html`.
2. **Screenshot it headless.** Run the bundled helper (path is relative to this skill's directory):

   ```bash
   bash "<this-skill-dir>/scripts/shoot.sh" "/tmp/visualise-{slug}.html" "/tmp/visualise-{slug}.png"
   ```

   It prints the PNG path. **Exit code 3 means no headless browser is installed** — skip straight to Step 5 (open it and let the user be your eyes); don't treat that as a failure.
3. **Read the PNG back** with the Read tool and actually look at it. Score it against this rubric — be a harsh critic, not a cheerleader:
   - **Dead space** — does the viz fill the frame, or is there a big empty band at the bottom/sides? (Most common defect.)
   - **Overlap & collisions** — labels on top of each other, text over nodes, legend over the chart, controls over the title?
   - **Clipping** — anything cut off at an edge or overflowing the viewport?
   - **Legibility** — text large enough; sufficient contrast on the dark background; nothing mid-grey-on-dark-grey.
   - **Emptiness** — did it actually render, or is it a blank/near-blank canvas (data wiring bug, failed CDN, JS error)?
   - **Export button** — present, top-right, not overlapping anything?
   - **Playground only** — is the controls panel visible and labeled with live values? Are the hero output readouts present? Are preset buttons rendered? (The screenshot can't *click*, so also do the logic trace below.)
   - **Overall** — does this look like the gallery examples, or like a first draft?
4. **Playground logic trace (Playground mode only).** The screenshot proves it renders, not that it *works*. Read your own `compute()` once and trace one concrete change end-to-end: pick an input, mentally bump it, and confirm an output actually moves in the right direction and the chart/readouts are wired to re-render. Confirm presets set a full input set and that URL-hash restore round-trips. Fix any dead wiring.
5. **Fix every real problem** you found by editing the same file, then re-screenshot and re-read. Repeat until it's clean or you've done **3 passes** (stop after 3 — diminishing returns; note any remaining issue to the user).
6. Only once it passes (or you've hit the pass limit) move on to Step 5.

> If a screenshot comes back blank or errored, the most likely causes are: a JS exception (check the logic), a CDN script that didn't load in time (raise `VIS_SETTLE`, e.g. `VIS_SETTLE=6000`), or a canvas sized to `0` before layout settled. Fix the cause — don't just re-shoot.

## Step 5: Open & Hand Off

1. Open it: `open /tmp/visualise-{slug}.html`
2. Tell the user the file path so they can keep it or move it, and mention it has an Export PNG button.

## Step 6: Iterate

After opening, ask the user what to adjust. Common requests:
- "Make it bigger / smaller"
- "Add more detail on X"
- "Change the colors"
- "Add a legend"
- "Make it animate"

(No need to ask for PNG export — it's already built in per Hard Rule 9.)

Edit the same file. After any **layout-changing** edit, re-run the Step 4 look-at-it pass before re-opening — it's cheap and catches regressions you can't see from the code. Don't create new files for iterations.

---

## Examples of Great Output

**Topic: "React component dependency graph"**
-> Force-directed graph. Nodes are components, edges are imports. Click a node to highlight its dependency chain. Drag to rearrange. Search box to find a component. Node size proportional to import count.

**Topic: "CI/CD pipeline stages"**
-> Sankey diagram. Source (git push) flows through Build, Test, Security Scan, Stage, Canary, Production. Width = build count. Failed builds branch to a red "Failed" sink. Hover for pass/fail rates.

**Topic: "HTTP request lifecycle"**
-> Animated state machine. States: DNS Resolve -> TCP Connect -> TLS Handshake -> Request Sent -> Waiting (TTFB) -> Response Streaming -> Complete. Tokens flow through on a loop. Click a state to see typical latency range.

**Topic: "npm package sizes in this project"**
-> Treemap. Rectangles sized by bundle contribution. Color by category (framework, utility, dev). Click to zoom into a package's sub-dependencies. Breadcrumb navigation.

### Playground mode

**Topic: "our SaaS unit economics" (playground)**
-> Control panel: price, seats, gross margin, monthly churn %, CAC, expansion %. Hero readouts: LTV, LTV:CAC, payback months, steady-state MRR. Live chart: cohort revenue + cumulative cash curve crossing zero at payback. Presets: "Conservative / Aggressive / PLG". Pin two scenarios to compare side by side. Scenario encoded in the URL.

**Topic: "token bucket rate limiter" (playground)**
-> Controls: refill rate, bucket capacity, request rate, burst button. Live simulation: tokens drip in, requests hit the gate and pass (green) or drop (red). Hero readouts: pass rate, dropped count. Presets for steady vs bursty traffic.

**Topic: "exponential backoff with jitter" (playground)**
-> Controls: base delay, multiplier, max delay, jitter on/off, attempts. Hero readouts: total wait, worst-case attempt. Live chart: per-attempt delay bars and the retry timeline; toggling jitter spreads the bars. Presets: "AWS-style / aggressive / gentle".

---

## What NOT to Do

- Don't generate a static image or screenshot — always interactive HTML
- Don't use Matplotlib/Plotly Python charts saved as HTML — they're bloated. Write the HTML directly.
- Don't add a massive README or explanation outside the HTML — the visualization IS the explanation
- Don't use React/Vue/Angular — vanilla JS only for single-file output
- Don't generate placeholder data when real data is available in the codebase
- **Playground:** don't ship dead controls (a slider that changes nothing), don't gate cheap models behind a "Run" button, and don't smear the model across event handlers — keep one `compute()` and re-render from it
