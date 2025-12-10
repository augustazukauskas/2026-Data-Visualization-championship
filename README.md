![alt text](https://github.com/augustazukauskas/2026-Data-Visualization-championship/blob/main/NIH_collabs.gif)
Augusta Zukauskas, Research Study Assiatant at Department of Medical Social Sciences, Northwestern University Feinburg School of Medicine

## About
This project analyzes research collaborations funded by the NIH amoung Big Ten universities. It aggregates award-level data, identifies cross-institution collaborations, and visualizes the network using chord diagrams. The goal was to provide a clear, compelling overview of collaboration patterns, strengths, and trends.

### Data Sources:
**NIH RePORTER Data**
- **Source**: https://reporter.nih.gov/exporter
- **Content**: Exported the FY 2024 Project Data. Contains project title, abstract, funding amount, start/end dates, PI names and IDs, Institution names and addresses, funding mechanisms, etc.
- **Format**: CSV
- **Usage in this project**: Identifying collaborations by matching awards across institutions and aggregating collaboration counts

**School Logos**
- **Source**: https://bigten.org/
- **Format**: SVG
- **Usage in this project**: Used to display each school on the chord diagram

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

