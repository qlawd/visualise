---
name: visualise
description: Generate an interactive HTML visualization for any concept, codebase, data, strategy, or idea. Opens in browser for immediate feedback.
argument-hint: "<topic or concept to visualize>"
allowed-tools: Bash(open *) Bash(python3 *) Write Read Edit
---

# Visualise — On-Demand Interactive Explainers

Generate a **single self-contained HTML file** that visualizes the user's topic interactively. Open it in the default browser. Iterate based on feedback.

**Topic**: $ARGUMENTS

---

## Step 1: Understand the Topic

Before writing any code, figure out what you're visualizing:

- If the topic references **files, code, or architecture** in the current project — read those files first.
- If the topic references **concepts or knowledge** — check any knowledge base, docs, or wiki in the project, or use your own understanding.
- If the topic references **data or results** — find the actual numbers rather than making them up.
- If the topic is **abstract** (an algorithm, a mental model, a framework) — identify the key components, relationships, and dynamics that need to be shown.

## Step 2: Choose the Right Visualization Type

Pick the visualization that best serves comprehension. DO NOT default to a simple chart when an interactive exploration would be better.

| Topic Type | Best Visualization |
|---|---|
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

## Step 4: Save and Open

1. Save the file to `/tmp/visualise-{slugified-topic}.html`
2. Open it: `open /tmp/visualise-{slugified-topic}.html`
3. Tell the user the file path so they can keep it or move it

## Step 5: Iterate

After opening, ask the user what to adjust. Common requests:
- "Make it bigger / smaller"
- "Add more detail on X"
- "Change the colors"
- "Add a legend"
- "Make it animate"
- "Export as PNG" (add a button using Canvas `toDataURL`)

Edit the same file and re-open. Don't create new files for iterations.

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

---

## What NOT to Do

- Don't generate a static image or screenshot — always interactive HTML
- Don't use Matplotlib/Plotly Python charts saved as HTML — they're bloated. Write the HTML directly.
- Don't add a massive README or explanation outside the HTML — the visualization IS the explanation
- Don't use React/Vue/Angular — vanilla JS only for single-file output
- Don't generate placeholder data when real data is available in the codebase
