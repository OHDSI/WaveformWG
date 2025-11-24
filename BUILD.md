# Building the Waveform Working Group Website

This website is built using R Markdown and the `rmarkdown` package.

## Prerequisites

- R (version 4.0 or higher)
- RStudio (optional, but recommended)
- The `rmarkdown` package

## Installation

If you don't have the `rmarkdown` package installed, install it from R or RStudio:

```r
install.packages("rmarkdown")
```

## Building the Site

### Option 1: Using the build script (Recommended)

From the repository root, run:

```bash
Rscript build-site.R
```

This will:
1. Process all `.Rmd` files in the `rmd/` directory
2. Generate HTML files in the `docs/` directory
3. Copy assets (CSS, images) to `docs/`

### Option 2: From RStudio

1. Open RStudio
2. Set working directory to the `rmd/` folder:
   ```r
   setwd("rmd")
   ```
3. Build the site:
   ```r
   rmarkdown::render_site(encoding = "UTF-8")
   ```

### Option 3: Using R console

From R console:

```r
setwd("rmd")
rmarkdown::render_site(encoding = "UTF-8")
```

## Viewing the Site Locally

After building, open `docs/index.html` in your web browser to preview the site.

## Publishing to GitHub Pages

1. **Build the site** using one of the methods above
2. **Commit the changes** to the `docs/` directory:
   ```bash
   git add docs/
   git commit -m "Build website"
   git push
   ```
3. **Enable GitHub Pages** in your repository settings:
   - Go to Settings > Pages
   - Source: Deploy from a branch
   - Branch: `main` (or your default branch)
   - Folder: `/docs`
   - Click Save

The site will be published at: `https://ohdsi.github.io/WaveformWG/`

## Directory Structure

```
WaveformWG/
├── rmd/                    # Source RMarkdown files
│   ├── _site.yml          # Site configuration
│   ├── index.Rmd          # Home page
│   ├── get-started.Rmd    # Getting started guide
│   ├── waveform-extension.Rmd  # Implementation guide
│   ├── ... (other .Rmd files)
│   ├── style.css          # Custom CSS
│   └── images/            # Image assets
├── docs/                   # Generated HTML (output directory)
│   ├── index.html
│   ├── ... (generated files)
├── build-site.R           # Build script
└── BUILD.md               # This file
```

## Adding New Pages

1. Create a new `.Rmd` file in the `rmd/` directory
2. Add YAML front matter:
   ```yaml
   ---
   title: '<div><img src="ohdsi40x40.png"></img> OHDSI Waveform WG </div>'
   output:
      html_document:
           toc: TRUE
           toc_depth: 3
           toc_float:
             collapsed: false
   ---
   ```
3. Add the page to the navigation in `rmd/_site.yml`
4. Rebuild the site

## Updating Navigation

Edit `rmd/_site.yml` to modify the navigation bar structure. The file uses YAML syntax to define menu items and dropdowns.

Example:
```yaml
navbar:
  left:
    - text: "New Page"
      href: new-page.html
    - text: "Dropdown Menu"
      menu:
        - text: "Submenu Item"
          href: submenu.html
```

## Troubleshooting

### Error: Package 'rmarkdown' not found

Install the package:
```r
install.packages("rmarkdown")
```

### Error: pandoc not found

RMarkdown requires Pandoc. Install it:
- **RStudio**: Pandoc is included with RStudio
- **Manual**: Download from https://pandoc.org/installing.html

### Build succeeds but pages look wrong

Make sure all assets (CSS, images, favicon) are in the `rmd/` directory and are being copied to `docs/` during the build.

## CI/CD with GitHub Actions

For automated builds on every commit, you can set up a GitHub Actions workflow. See `.github/workflows/build-site.yml` (if available) for an example configuration.

## Contact

For questions about building the website:
- **GitHub Issues**: [Open an issue](https://github.com/OHDSI/WaveformWG/issues)
- **Email**: houghtaling@ohdsi.org
