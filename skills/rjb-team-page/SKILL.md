---
name: rjb-team-page
description: Update the "Meet the Team" section of the RJB Contracting website (about-us.html) from the team.json data file. Use whenever someone wants to add a new hire, remove someone who left, change a person's title, reorder people, move someone to a different department, or refresh headshots on the team page. Triggers include "update the team page," "add [name] to the team," "[name] is a new hire," "[name] left / remove [name]," "change [name]'s title," "[name] got promoted," "reorder the team," "refresh the team photos," or any request to edit who appears on the Meet the Team / Leadership section. The team.json file is the single source of truth; never hand-edit the generated HTML.
---

# RJB Team Page Updater

Keep the "Meet the Team" section on `about-us.html` in sync with a single data file. You edit `team.json`, run one script, and the grouped card grid + photo download list regenerate automatically.

## How the system is wired

- **`team.json`** (project root) — the **single source of truth**. People, titles, department grouping, order, and photo filenames all live here.
- **`tools/generate_team_section.py`** — reads `team.json` and rewrites:
  - the `about-us.html` block **between `<!-- TEAM:START -->` and `<!-- TEAM:END -->`** (inside `<section id="leadership">`),
  - `images/PHOTO-DOWNLOAD-LIST.md` (human-readable photo list),
  - `tools/download_photos.sh` (a curl script the user can run to fetch photos).
- **`css/styles.css`** — already contains `.team-grid`, `.team-card*`, `.team-section-group`, and `.team-group-label`. No CSS changes are needed for routine updates.

**Never hand-edit the HTML between the TEAM markers** — it is overwritten on every run. Edit `team.json` instead.

## The workflow (do this every time)

1. Open `team.json` and make the change (see schema below).
2. From the project root, run:
   ```
   python3 tools/generate_team_section.py
   ```
   (If `tools/generate_team_section.py` is missing, copy it from this skill's `scripts/generate_team_section.py` into the project's `tools/` folder first.)
3. Confirm the script prints the expected member and group counts.
4. If you added or changed a photo, make sure the image file exists in `images/` (see "Photos" below).

The script is idempotent — safe to run as often as you like.

## team.json schema

```json
{
  "section": { "label": "Meet the Team", "heading": "The team behind the teams." },
  "groups": [
    {
      "name": "Executive Team",
      "members": [
        { "name": "Ron Bacskai", "title": "President",
          "file": "team-ron-bacskai.jpg",
          "src": "https://rjbpro.com/wp-content/uploads/2023/11/Ron-Backsai-gradient1.jpg" }
      ]
    }
  ]
}
```

Field rules for each member:
- **name** — display name, exactly as it should appear.
- **title** — proper Title Case (e.g., `Project Manager`, not `project manager`). Use `&` freely; the script HTML-escapes it.
- **file** — local filename in `images/`. Convention: `team-firstname-lastname.<ext>`, all lowercase, spaces → hyphens, apostrophes/periods removed (e.g., `Megan O'Hara` → `team-megan-ohara.png`, `Joe Holz Jr.` → `team-joe-holz-jr.jpg`). **Keep the real extension** of the actual image (`.jpg`, `.png`, or `.webp`) so it isn't a broken reference.
- **src** — (optional but recommended) the original URL the photo came from. Only used to regenerate the download list/script; not used in the page itself.

Group order in the file = display order on the page. Member order within a group = display order within that group.

### Current department groups (keep this order unless asked)
Executive Team → Directors → Operations & Administration → Project Management → Assistant Project Managers → Project Administration → Accounting → Field & Warehouse.

## Common edits

- **New hire** → add a member object to the right group. Set `file` per the convention and add their photo to `images/` (see Photos). Run the script.
- **Someone left** → delete their member object. Run the script. (Optionally delete their image from `images/`.)
- **Promotion / title change** → edit `title` (and move them to a different group if needed). Run the script.
- **Reorder** → reorder member objects (or whole groups). Run the script.
- **New department** → add a new group object with a `name` and `members`. Run the script. No CSS needed.

## Photos

The page references local files in `images/`. A photo is required for the card to look right (a missing file shows a navy square).

- After editing `team.json`, the script rewrites `images/PHOTO-DOWNLOAD-LIST.md` and `tools/download_photos.sh`.
- To pull every photo from the live URLs at once, the user runs: `bash tools/download_photos.sh`.
- **Claude cannot download images itself in a Cowork session.** For a new person, either: (a) ask the user to drop their headshot into `images/` with the exact `file` name, or (b) if you have a `src` URL, add it to `team.json` and tell the user to run `download_photos.sh`.
- Headshots should be roughly square; the card crops to a 1:1 square via CSS, so off-square images still display cleanly.

## Self-check before finishing

- Did you edit `team.json` (not the HTML between the markers)?
- Did the script run cleanly and report the expected counts?
- Does every member's `file` extension match an actual image in `images/` (or is the user told to add it)?
- Are titles in proper Title Case?
- Is the `#leadership` section still present (the footer "Leadership" link points to it)?
