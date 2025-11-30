# UV Monitor App - Hugo Website

This directory contains the Hugo static website for the UV Monitor App, providing marketing content and comprehensive documentation.

## Quick Start

### Prerequisites

- **Hugo** (Extended version recommended)
- Install from: https://gohugo.io/installation/

### Installation

1. **Install Hugo** (if not already installed):

```bash
# macOS
brew install hugo

# Windows (using Chocolatey)
choco install hugo-extended

# Or download from: https://github.com/gohugoio/hugo/releases
```

2. **Install PaperMod Theme** (recommended):

```bash
cd DOCS/website
git clone https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod --depth=1
```

Alternatively, add as submodule (if using git):
```bash
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
git submodule update --init --recursive
```

### Running Locally

```bash
# From DOCS/website/ directory
hugo server

# Or with drafts enabled
hugo server -D

# Access at: http://localhost:1313
```

### Building for Production

```bash
# Build static site
hugo

# Output will be in public/ directory
```

## Site Structure

```
DOCS/website/
├── config.toml              # Hugo configuration
├── content/                 # All content pages
│   ├── _index.md           # Homepage
│   ├── features.md         # Features page
│   ├── getting-started.md  # Setup guide
│   ├── about.md            # About page
│   └── docs/               # Documentation section
│       ├── _index.md       # Docs landing
│       ├── user-guide.md   # User documentation
│       ├── developer-guide.md # Developer docs
│       ├── architecture.md # Architecture docs
│       └── testing.md      # Testing guide
├── static/                 # Static assets
│   ├── images/             # Screenshots and images
│   │   ├── monitor_screen.png
│   │   ├── quiz_middle.png
│   │   ├── quiz_results.png
│   │   ├── recent_readings.png
│   │   └── start_quiz.png
│   └── css/
│       └── custom.css      # Custom styling
├── layouts/                # Custom layouts (optional)
├── themes/                 # Hugo themes
│   └── PaperMod/          # Recommended theme
└── public/                 # Generated site (after build)
```

## Content Pages

### Marketing Pages
- **Homepage** (`_index.md`) - Hero, features overview, screenshots
- **Features** (`features.md`) - Detailed feature descriptions
- **Getting Started** (`getting-started.md`) - Installation and setup
- **About** (`about.md`) - Project background and information

### Documentation
- **User Guide** (`docs/user-guide.md`) - Complete user documentation
- **Developer Guide** (`docs/developer-guide.md`) - Technical implementation
- **Architecture** (`docs/architecture.md`) - System design and patterns
- **Testing** (`docs/testing.md`) - Testing strategies and guides

## Customization

### Updating Configuration

Edit `config.toml` to customize:
- Site title and description
- Navigation menu
- Theme parameters
- Social links

### Adding Content

Create new markdown files in `content/`:

```bash
hugo new posts/my-new-post.md
```

### Custom Styling

Add custom CSS in `static/css/custom.css`.

### Images

Place images in `static/images/` and reference them in markdown:

```markdown
![Alt text](/images/image-name.png)
```

## Deployment

### GitHub Pages

1. Build the site:
```bash
hugo
```

2. The `public/` directory contains the static site

3. Deploy to GitHub Pages:
```bash
# Push public/ directory to gh-pages branch
# Or use GitHub Actions (see Hugo docs)
```

### Netlify

1. Connect your repository to Netlify
2. Set build command: `hugo`
3. Set publish directory: `public`
4. Deploy automatically on git push

### Vercel

1. Import your repository
2. Select Hugo as framework
3. Deploy automatically

### Manual Hosting

Upload contents of `public/` directory to any web server.

## Theme: PaperMod

PaperMod is a fast, clean, and minimal Hugo theme with:
- ✅ Responsive design
- ✅ Dark mode support
- ✅ Search functionality
- ✅ Code syntax highlighting
- ✅ Fast loading
- ✅ SEO optimized

**Documentation:** https://github.com/adityatelange/hugo-PaperMod/wiki

## Alternative Themes

If PaperMod doesn't suit your needs, try:

### Docsy (Documentation-focused)
```bash
git clone https://github.com/google/docsy.git themes/docsy
```

### Clarity (Minimal)
```bash
git clone https://github.com/chipzoller/hugo-clarity.git themes/clarity
```

### Book (Documentation book style)
```bash
git clone https://github.com/alex-shpak/hugo-book themes/book
```

Update `config.toml`:
```toml
theme = "theme-name"
```

## Maintenance

### Updating Theme

If using git submodule:
```bash
git submodule update --remote --merge
```

If using git clone:
```bash
cd themes/PaperMod
git pull
```

### Updating Content

Simply edit markdown files in `content/` directory and rebuild.

## Troubleshooting

**Problem:** Theme not loading
```bash
# Verify theme is installed
ls themes/

# Check config.toml theme setting
# Re-download theme if needed
```

**Problem:** Images not showing
- Check image path is correct (`/images/name.png`)
- Verify image exists in `static/images/`
- Check file name capitalization

**Problem:** Hugo command not found
```bash
# Verify Hugo is installed
hugo version

# If not, install from https://gohugo.io/installation/
```

## Resources

- **Hugo Documentation:** https://gohugo.io/documentation/
- **PaperMod Theme:** https://github.com/adityatelange/hugo-PaperMod
- **Markdown Guide:** https://www.markdownguide.org/
- **Hugo Themes:** https://themes.gohugo.io/

## Support

For questions about the UV Monitor App, see the main project README or contact your instructor/development team.

---

**Built with Hugo** - The world's fastest framework for building websites.

