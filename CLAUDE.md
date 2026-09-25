# CLAUDE.md

Personal academic website of Nicolas Lanzetti (postdoc, Caltech CMS), served by GitHub Pages at https://nicolaslanzetti.github.io from the `main` branch of `nicolaslanzetti/nicolaslanzetti.github.io`. Pushing to `main` deploys, so ask before pushing.

## Stack

Plain static HTML/CSS/JS. There's no build step, no package manager, no framework, and no tests. The only external dependency is Font Awesome 4.7 from cdnjs (used for the `fa-*` icons).

Preview locally with a web server, because `fetch()` of the JSON data fails over `file://`:

```sh
python3 -m http.server   # then open http://localhost:8000/
```

## Layout

- `index.html`: home page (bio, research interests, selected publications, news). Everything is hand-written HTML.
- `publications.html`: empty `<ul>` containers that `scripts/render-publications.js` fills from `data/*.json`.
- `teaching.html`: student projects and classes, hand-written. Links point to course material in `files/ta/<course>/`.
- `404.html`: uses **absolute** paths (`/style.css`), because GitHub Pages serves it at arbitrary URLs. The other pages use relative paths.
- `style.css`: the single stylesheet for every page.
- `files/`: images, the portrait (`pic_lowres.jpg` is the one in use), selected-publication thumbnails (`files/selected/`), TA material, and talk media.
- `sitemap.xml` and `robots.txt`: keep them in sync when pages are added or renamed.

The nav bar and the `<head>` block (meta description, canonical URL, Open Graph tags, favicon, Font Awesome, stylesheet) are copied into every page. When you change one, change all four pages. Set `aria-current="page"` on the active nav link.

## Publications data

`render-publications.js` fetches these files and routes each entry by its `type`:

| file | `type` | section |
|---|---|---|
| `data/preprints.json` | `preprint` | preprints |
| `data/journals.json` | `journal` | journal papers |
| `data/cs_conferences.json` | `cs_conference` | machine learning conferences |
| `data/control_conferences.json` | `control_conference` | control conferences |
| `data/energy_transportation_conferences.json` | `energy_transportation_conference` | energy and transportation conferences |
| `data/dissertations.json` | `dissertation` | dissertations |

`data/conferences.json`, `data/lecture_notes.json`, and `data/others.json` are empty and are **not loaded** by the script.

Entry fields (all optional except `type` and `title`):

```json
{
  "type": "journal",
  "title": "...",
  "authors": "A. Schöbi, N. Lanzetti, F. Dörfler, and A. Terpin",
  "venue": "IEEE Transactions on Automatic Control",
  "year": "2026",
  "url_title": "https://arxiv.org/abs/XXXX.XXXXX",
  "url_paper": "https://arxiv.org/pdf/XXXX.XXXXX.pdf",
  "code": "...", "slides": "...", "video": "...",
  "notes": "Best paper award",          // string or array, shown in bold
  "comment": "published in ...",        // plain text line below the venue
  "committee": ["..."],                 // dissertations only
  "abstract": "..."                     // HTML allowed; toggled by the Abstract button
}
```

Conventions:
- Entries render in file order, so put the newest first.
- Authors are written as initials plus surname, joined with commas and a final "and". Mark equal contribution with a trailing `*` (e.g. `N. Lanzetti*`).
- The script bolds the owner's name automatically. Always write it as `N. Lanzetti`.
- `year` is a string.
- When a preprint is published, **move** the entry to the right file, change its `type`, and update `venue`/`year`. Don't duplicate it.
- To add a new category, you need three changes: a `<ul id=...>` in `publications.html`, the URL in the script's `urls` array, and a branch in the `type` dispatch at the bottom of the script.

The "selected publications" grid and the news table on `index.html` are **not** generated from the JSON. Update them by hand. News rows look like `<tr><th>Month YYYY</th><td>...</td></tr>`, newest first. Recent news goes in the first `news` table. Older rows go in the second table inside `<details class="older-news">`, so move rows down as they age. Each thumbnail is a 16:5 background image in `files/selected/`.

## Style conventions

- Headings and nav labels are lowercase ("publications", "latest news").
- Fonts and colors: Optima, text `#484848`, links/accent `#B22222`, and justified body text. Reuse the existing classes before adding inline styles.
- External links use `target="_blank" rel="noopener noreferrer"`.
- Keep indentation consistent with the surrounding markup. The files currently mix tabs and spaces, so don't reformat whole files.
- When you change page content, bump `<lastmod>` in `sitemap.xml`.

## Repo hygiene

- The repo is already around 250 MB, mostly PDFs in `files/ta/` and one video in `files/conferences/`. Avoid committing large binaries. GitHub rejects files over 100 MB, so link to externally hosted slides/videos when you can.
- Don't commit macOS `._*` / `.DS_Store` files or backup copies (`*.bak`, `old/`). They're gitignored, and they have been committed by accident before.
