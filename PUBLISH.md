# Publishing the RJB Site

Your site lives in a GitHub repo (`github.com/rjbpro/rjbpro-site`) and is published with **GitHub Pages** at:

**https://rjbpro.github.io/rjbpro-site/**

This free URL is separate from your current `rjbpro.com` WordPress site, so publishing here does **not** affect your live company site.

---

## First time: get it live (one-time, ~3 minutes)

1. **Open Terminal in this folder.** In Finder, right-click the `Creating Website` folder → *New Terminal at Folder* (or `cd` into it).

2. **Clear the leftover lock** (only needed once):
   ```
   rm -f ".git/index.lock"
   ```

3. **Push everything:**
   ```
   bash deploy.sh
   ```
   The first run commits the full current site (sectors, services, team section, client logos, navy update) and pushes it to GitHub.

4. **Enable GitHub Pages** (only if it isn't already on):
   - Go to **github.com/rjbpro/rjbpro-site → Settings → Pages**
   - **Source:** Deploy from a branch
   - **Branch:** `main`  •  **Folder:** `/ (root)`  → **Save**
   - Wait 1–2 minutes; the live URL appears at the top of that page.

That's it — visit **https://rjbpro.github.io/rjbpro-site/** to see it.

---

## Every update after that

Whenever you change the site (new team member, new logo, edited copy), just run:

```
bash deploy.sh
```

or, with a short note describing the change:

```
bash deploy.sh "Added Q3 project photos"
```

The live site refreshes automatically a minute or two later.

---

## Later: using a custom domain

When you're ready to serve this at `rjbpro.com` or a subdomain like `new.rjbpro.com`, see the **Custom domain** section in `GITHUB-SETUP.md` — it requires adding DNS records at your domain provider. Don't point `rjbpro.com` here until you're ready to fully replace the WordPress site. Just ask and I'll walk you through it.
