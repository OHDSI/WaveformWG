# OHDSI Waveform Working Group

Welcome to the OHDSI Waveform Working Group repository! This working group is dedicated to integrating physiological waveform data (ECG, EEG, arterial blood pressure, etc.) with electronic health records in the OMOP Common Data Model.

## Website

Visit our documentation website: [https://ohdsi.github.io/WaveformWG/](https://ohdsi.github.io/WaveformWG/)

## Mission

To enable integration of physiological waveform data with electronic health records in the OMOP Common Data Model, supporting observational research, AI model development, and clinical decision support.

## Waveform Extension

The OMOP CDM Waveform Extension consists of four interconnected tables:

1. **waveform_occurrence** - Clinical and temporal context for recording sessions
2. **waveform_registry** - File-level metadata and storage locations
3. **waveform_channel_metadata** - Per-signal characteristics and metadata
4. **waveform_feature** - Derived measurements and features

## Documentation

- **[Getting Started](https://ohdsi.github.io/WaveformWG/get-started.html)** - Implementation guide and quick start
- **[Waveform Extension Overview](https://ohdsi.github.io/WaveformWG/waveform-extension-overview.html)** - High-level architecture
- **[Implementation Guide](https://ohdsi.github.io/WaveformWG/waveform-extension.html)** - Detailed ETL specifications
- **[Table Specifications](https://ohdsi.github.io/WaveformWG/waveform-tables.html)** - Complete schema reference
- **[Office Hours](https://ohdsi.github.io/WaveformWG/office-hours.html)** - Recorded implementation discussions

## Get Involved

### Join the Working Group

1. [Sign up for OHDSI Teams](https://forms.office.com/Pages/ResponsePage.aspx?id=lAAPoyCRq0q6TOVQkCOy1ZyG6Ud_r2tKuS0HcGnqiQZUQ05MOU9BSzEwOThZVjNQVVFGTDNZRENONiQlQCN0PWcu)
2. Request access to the Waveform Working Group channel
3. Introduce yourself and share your interests
4. Attend working group meetings

### Contribute

We welcome contributions from:
- **Data Engineers**: Implement the extension at your institution
- **Researchers**: Propose use cases and requirements
- **Developers**: Build ETL tools and converters
- **Vocabulary Experts**: Help standardize waveform concepts

See our [Project Management](https://ohdsi.github.io/WaveformWG/project-management.html) page for details.

## Quick Links

- **GitHub Repository**: [OHDSI/WaveformWG](https://github.com/OHDSI/WaveformWG)
- **OHDSI Homepage**: [https://www.ohdsi.org/](https://www.ohdsi.org/)
- **OHDSI Forums**: [http://forums.ohdsi.org/](http://forums.ohdsi.org/)
- **CHoRUS Bridge2AI**: [https://chorus-ai.github.io/](https://chorus-ai.github.io/)

## Related Resources

- [CHoRUS Multimodal Linkage SOP](https://chorus-ai.github.io/Chorus_SOP/docs/Multimodal-Linkage/)
- [OHDSI GIS Working Group](https://ohdsi.github.io/GIS/)
- [PhysioNet Waveform Tools](https://physionet.org/content/wfdb/)

## Building the Website

This repository contains the source files for the Waveform Working Group documentation website.

### Prerequisites

- R (version 4.0+)
- `rmarkdown` package

### Build Instructions

```bash
# Install rmarkdown package (if needed)
Rscript -e 'install.packages("rmarkdown")'

# Build the site
Rscript build-site.R

# View locally
open docs/index.html
```

See [BUILD.md](BUILD.md) for detailed build instructions.

## Repository Structure

```
WaveformWG/
├── rmd/                          # Source RMarkdown files
│   ├── _site.yml                 # Site configuration
│   ├── index.Rmd                 # Home page
│   ├── get-started.Rmd           # Getting started guide
│   ├── waveform-extension.Rmd    # Implementation guide
│   └── ... (other content pages)
├── docs/                         # Generated HTML (published to GitHub Pages)
├── build-site.R                  # Build script
├── BUILD.md                      # Detailed build instructions
└── README.md                     # This file
```

## Contact

- **Email**: houghtaling@ohdsi.org
- **GitHub Issues**: [Report bugs or request features](https://github.com/OHDSI/WaveformWG/issues)
- **Teams**: OHDSI Waveform Working Group channel

## License

This work is licensed under the [Apache License 2.0](LICENSE.md).

## Acknowledgments

The OHDSI Waveform Working Group is grateful for support from:
- CHoRUS Bridge2AI
- OHDSI Community
- Early adopter institutions
- All contributors

---

**Maintained by**: OHDSI Waveform Working Group
**Last Updated**: November 2025
