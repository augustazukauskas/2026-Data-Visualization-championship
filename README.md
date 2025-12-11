![alt text](https://github.com/augustazukauskas/2026-Data-Visualization-championship/blob/main/NIH_collabs.gif)
Augusta Zukauskas, Research Study Assiatant at Department of Medical Social Sciences, Northwestern University Feinburg School of Medicine

## About
This project analyzes project collaborations funded by the NIH amoung Big Ten universities. The goal was to provide a clear, compelling overview of collaboration patterns, strengths, and trends. 

Data was sourced from NIH RePORTER, cleaned to include only Big en institutions, and normalized so variations in university names were grouped under a single standard name. Collaborations were counted when the same Principle Investigator (PI) ID appeared across more than one university, indicating shared involvement in multiple institutions. To highlight each institution's role, I created seperate chord diagrams focusing on individual universities and then combined these images into a single animated GIF using Adobe tools.

Working on a NIH funded project has shown me the value of collaboration and dedication. This visualization highlights the effort and strong partnerships that drive our research forward.

### Data Sources:
**NIH RePORTER Data**
- **Source**: https://reporter.nih.gov/exporter
- **Content**: Exported the FY 2024 Project Data. Contains project title, abstract, funding amount, start/end dates, PI names and IDs, Institution names and addresses, funding mechanisms, etc.
- **Format**: CSV
- **Usage in this project**: Identifying collaborations by matching awards across institutions and aggregating collaboration counts

**University Logos**
- **Source**: https://bigten.org/
- **Format**: SVG
- **Usage in this project**: Used to identify each university on the chord diagram

**University Primary Colors**
- **Source**: Official university brand guidlines or verified sources.
- **Format**: Hex Codes
- **Usage**: Chord diagram, for the university node

### Packages
| Package       | Purpose                                                                 |
|---------------|-------------------------------------------------------------------------|
| **dplyr**     | Data manipulation: filtering, grouping, summarizing, and joins        |
| **stringr**   | String operations: cleaning and formatting text fields                |
| **tidyr**     | Reshaping data: pivoting and tidying datasets                         |
| **circlize**  | Creating chord diagrams for visualizing collaborations                |
| **colorspace**| Managing color palettes for consistent branding in plots              |
| **ragg**      | High-quality graphics rendering for saving plots                      |
| **here**      | Simplifies file paths for reproducible project structure              |
| **png**       | Reading and writing PNG images                                        |
| **rsvg**      | Converting SVG graphics to raster formats                             |
| **readr**     | Fast and friendly reading of CSV and text files                       |
| **scales**    | Formatting scales (e.g., percentages, color gradients) in plots       |
| **magick**    | Advanced image processing: combining, resizing, and editing graphics  |

