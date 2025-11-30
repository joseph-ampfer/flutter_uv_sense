# Quick Start Guide

Get the UV Monitor App website running in 3 minutes!

## Option 1: With PaperMod Theme (Recommended)

### Step 1: Install Hugo

**macOS:**
```bash
brew install hugo
```

**Windows:**
```powershell
choco install hugo-extended
```

**Linux:**
```bash
sudo snap install hugo
```

Or download from: https://github.com/gohugoio/hugo/releases

### Step 2: Install Theme

```bash
cd DOCS/website
git clone https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod --depth=1
```

### Step 3: Run

```bash
hugo server
```

Open http://localhost:1313 in your browser!

## Option 2: Without External Theme (Basic)

If you can't install the theme or want a simple setup:

### Step 1: Install Hugo (same as above)

### Step 2: Use Built-in Theme

Edit `config.toml` and comment out the theme line:

```toml
# theme = "PaperMod"
```

### Step 3: Run

```bash
cd DOCS/website
hugo server
```

The site will use Hugo's default styling.

## Building for Production

```bash
# Generate static site
hugo

# Output in public/ directory
```

## Deploying

### To GitHub Pages

```bash
# Build
hugo

# Deploy public/ directory to gh-pages branch
```

### To Netlify

1. Connect repository
2. Build command: `hugo`
3. Publish directory: `public`

### To Any Web Server

Just upload the `public/` directory!

## Troubleshooting

**"hugo: command not found"**
- Install Hugo from https://gohugo.io/installation/

**Theme not loading**
- Make sure theme is in `themes/PaperMod/`
- Check `config.toml` has `theme = "PaperMod"`

**Images not showing**
- Check images are in `static/images/`
- Use `/images/filename.png` in markdown

## Next Steps

- Edit content in `content/` directory
- Customize `config.toml`
- Add custom styles in `static/css/custom.css`
- Read full README.md for more options

---

**Need help?** See README.md for complete documentation.

