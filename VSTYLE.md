# Visual Design Style Panorama for AI & Human Design Agents

> **OBS:** This is a stub model.

> **Purpose:** A comprehensive style guide and design token stub to distinguish the visual interfaces, feedback loops, and interactive elements.

---

## 1. Core Philosophy

* Organic, intuitive, and warm. The interface should feel tangible, forgiving, and focused on physical-like interactions (e.g., board game pieces, cards). Communication should be always precise, calculated, and deterministic.

---

## 2. Color Palette

### 2.1 Human Agent Colors (Organic & Warm)
*   **Primary:** `#E27D60` (Warm Terracotta) - Used for player turns, active selections.
*   **Secondary:** `#E8A87C` (Soft Peach) - Highlights and hover states.
*   **Background:** `#FFF3E0` (Off-white/Parchment) - Panel backgrounds.
*   **Accent/Alert:** `#C38D9E` (Muted Rose) - Warnings or critical human actions.

### 2.2 AI Agent Colors (Synthetic & Cool)
*   **Primary:** `#41B3A3` (Teal/Cyan) - Used for AI processing, AI active turns.
*   **Secondary:** `#85DCBA` (Mint) - AI highlights, calculated paths.
*   **Background:** `#1D2731` (Deep Slate) - AI panel backgrounds.
*   **Accent/Alert:** `#E27D60` (High-contrast Orange) - AI error or uncalculated move.

### 2.3 Shared Neutral Colors
*   **Text (Dark):** `#0B0C10`
*   **Text (Light):** `#C5C6C7`
*   **Borders/Dividers:** `#D1D5DB`

---

## 3. Typography

*   **Headers:** Monospace or Geometric Sans-serif (e.g., *Roboto Mono*, *Orbitron*) - Conveys calculation and code.
*   **Body:** Monospace (e.g., *Fira Code*) - For logs, history, and status readouts.
*   **Styling:** Uppercase for labels, strict alignment, wider tracking.

---

## 4. Shapes & UI Components

### 4.1 Buttons & Panels
*   **Border Radius:** Rounded (`8px` to `12px`).
*   **Shadows:** Soft, diffused drop shadows to mimic physical depth (e.g., cards lifting off a table).
*   **Borders:** Thin, solid, or glowing borders (e.g., `1px solid #41B3A3`).

---

## 5. Animation & Feedback Mechanisms

### 5.1 Turn Indicators
* Pulsing warm glow, slow ease-in-out transitions. "Your Turn" slides in smoothly.


### 5.2 Interactions
*   **Placement (e.g., Tiles/Tokens):** Snappy physical pop, subtle bounce on drop.

---

## 6. Layout & Spacing Defaults

*   **Base Unit:** `8px`
*   **Padding (Panels):** `16px` (Comfortable, airy)

---

## 7. Implementation Notes (Godot Specific)

*   **Theme Resources:** Create two alternate `Theme` resources in Godot (`ATheme.tres` and `BTheme.tres`).
*   **StyleBox:** Use `StyleBoxFlat` for B (sharp borders, no anti-aliasing on edges) and `StyleBoxTexture` for A (subtle paper/cardboard textures).
*   **RichTextLabel:** Utilize Godot's `RichTextLabel` with custom BBCode for the Descriptive History panel.
