# Load packages
library(dplyr)
library(stringr)
library(tidyr)
library(circlize)
library(colorspace)
library(ragg)
library(here)
library(png)
library(rsvg)
library(readr)
library(scales)
library(magick)


# Read the CSV
data <- read_csv("C:/Users/zmd5431/Downloads/RePORTER_PRJ_C_FY2024/RePORTER_PRJ_C_FY2024.csv")

big_ten <- c(
  "Northwestern University", "UNIVERSITY OF ILLINOIS AT URBANA-CHAMPAIGN", 
  "University of Michigan", "Michigan State University",
  "University of Wisconsin–Madison",
  "University of Minnesota", 
  "Pennsylvania State University", 
  "Ohio State University", 
  "Indiana University Bloomington",
  "University of Maryland",
  "Rutgers",
  "University of Iowa",
  "University of Nebraska",
  "UNIVERSITY OF OREGON",
  "Purdue University",
  "University of California Los Angeles",
  "University of Southern California",
  "University of Washington"
)

big_ten_data <- data %>%
  select(ORG_NAME, PI_IDS) %>%
  filter(str_detect(ORG_NAME, regex(paste(big_ten, collapse = "|"), ignore_case = TRUE)))

# Clean and separate PI_IDS
big_ten_data <- big_ten_data %>%
  mutate(PI_IDS = str_remove_all(PI_IDS, "\\s*\\(contact\\)")) %>%  # Remove "(contact)"
  separate_rows(PI_IDS, sep = ";") %>%                              # Split by ";"
  mutate(PI_IDS = str_trim(PI_IDS)) 

big_ten_data <- big_ten_data %>%
  mutate(ORG_NAME = str_replace(ORG_NAME, 
                                "^NORTHWESTERN UNIVERSITY AT CHICAGO$", 
                                "NORTHWESTERN UNIVERSITY"))
big_ten_data <- big_ten_data %>%
  mutate(ORG_NAME = if_else(str_detect(ORG_NAME, "HENRY FORD HEALTH"),
                            "MICHIGAN STATE UNIVERSITY",
                            ORG_NAME))
big_ten_data <- big_ten_data %>%
  mutate(ORG_NAME = str_replace(ORG_NAME, 
                                "^RUTGERS BIOMEDICAL AND HEALTH SCIENCES$", 
                                "RUTGERS"))
big_ten_data <- big_ten_data %>%
  mutate(ORG_NAME = str_replace(ORG_NAME, 
                                "^RUTGERS THE STATE UNIV OF NJ NEWARK$", 
                                "RUTGERS"))
big_ten_data <- big_ten_data %>%
  mutate(ORG_NAME = str_replace(ORG_NAME, 
                                "^RUTGERS, THE STATE UNIV OF N.J.$", 
                                "RUTGERS"))
big_ten_data <- big_ten_data %>%
  mutate(ORG_NAME = str_replace(ORG_NAME, 
                                "^UNIVERSITY OF MINNESOTA DULUTH$", 
                                "UNIVERSITY OF MINNESOTA"))
big_ten_data <- big_ten_data %>%
  mutate(ORG_NAME = str_replace(ORG_NAME, 
                                "^UNIVERSITY OF MARYLAND BALTIMORE COUNTY$", 
                                "UNIVERSITY OF MARYLAND BALTIMORE"))
big_ten_data <- big_ten_data %>%
  mutate(ORG_NAME = str_replace(ORG_NAME, 
                                "^UNIVERSITY OF MICHIGAN AT FLINT$", 
                                "UNIVERSITY OF MICHIGAN AT ANN ARBOR"))
big_ten_data <- big_ten_data %>%
  mutate(ORG_NAME = str_replace(ORG_NAME, 
                                "^RUTGERS THE STATE UNIV OF NJ CAMDEN$", 
                                "RUTGERS"))
big_ten_data <- big_ten_data %>%
  mutate(ORG_NAME = str_replace(ORG_NAME, 
                                "^UNIVERSITY OF MARYLAND EASTERN SHORE$", 
                                "UNIVERSITY OF MARYLAND BALTIMORE"))
big_ten_data <- big_ten_data %>%
  mutate(ORG_NAME = str_replace(ORG_NAME, 
                                "^UNIVERSITY OF MICHIGAN AT DEARBORN$", 
                                "UNIVERSITY OF MICHIGAN AT ANN ARBOR"))
big_ten_data <- big_ten_data %>%
  mutate(ORG_NAME = str_replace(ORG_NAME, 
                                "^UNIVERSITY OF NEBRASKA MEDICAL CENTER$", 
                                "UNIVERSITY OF NEBRASKA LINCOLN"))
big_ten_data <- big_ten_data %>%
  mutate(ORG_NAME = str_replace(ORG_NAME, 
                                "^UNIVERSITY OF NEBRASKA OMAHA$", 
                                "UNIVERSITY OF NEBRASKA LINCOLN"))
big_ten_data <- big_ten_data %>%
  mutate(ORG_NAME = str_replace(ORG_NAME, 
                                "^UNIVERSITY OF NEBRASKA KEARNEY$", 
                                "UNIVERSITY OF NEBRASKA LINCOLN"))

print(unique(big_ten_data$ORG_NAME))

# Find PI IDs that appear in multiple ORG_NAMEs
duplicates <- big_ten_data %>%
  group_by(PI_IDS) %>%
  summarise(org_count = n_distinct(ORG_NAME),
            org_list = paste(unique(ORG_NAME), collapse = ";")) %>%
  filter(org_count > 1)


# Separate org_list into multiple columns
collab_split <- duplicates %>%
  separate(org_list, into = c("org1", "org2"), sep = ";")
edges <- collab_split %>%
  select(org1, org2) %>%
  group_by(org1, org2) %>%
  summarise(weight = n(), .groups = "drop")

orgs <- unique(c(edges$org1, edges$org2))


logo_paths <- list(
  "MICHIGAN STATE UNIVERSITY" = "C:/Users/zmd5431/OneDrive - Northwestern University/Documents/logos/blte9e553c6587a6a9c-MichiganState.svg",
  "NORTHWESTERN UNIVERSITY" = "C:/Users/zmd5431/OneDrive - Northwestern University/Documents/logos/blt76d07d38cce045b5-Northwestern_(2025_Logo).svg",
  "RUTGERS" = "C:/Users/zmd5431/OneDrive - Northwestern University/Documents/logos/blt666c65cb30fda664-Rutgers.svg",
  "UNIVERSITY OF MARYLAND BALTIMORE" = "C:/Users/zmd5431/OneDrive - Northwestern University/Documents/logos/bltc49d991af00c7b79-Maryland.svg",
  "UNIVERSITY OF MICHIGAN AT ANN ARBOR" = "C:/Users/zmd5431/OneDrive - Northwestern University/Documents/logos/blt6b21cec93552d0e5-Michigan.svg",
  "UNIVERSITY OF IOWA" = "C:/Users/zmd5431/OneDrive - Northwestern University/Documents/logos/blt3854aa62ba151e8d-Iowa.svg",
  "UNIVERSITY OF OREGON" = "C:/Users/zmd5431/OneDrive - Northwestern University/Documents/logos/bltc32da6d5a5922121-ORE_Primary.svg",
  "UNIVERSITY OF WASHINGTON" = "C:/Users/zmd5431/OneDrive - Northwestern University/Documents/logos/blt63d59af73ea64da9-WAS_Primary.svg",
  "PURDUE UNIVERSITY" = "C:/Users/zmd5431/OneDrive - Northwestern University/Documents/logos/bltb09d6a4a9e03a709-Purdue.svg",
  "UNIVERSITY OF CALIFORNIA LOS ANGELES" = "C:/Users/zmd5431/OneDrive - Northwestern University/Documents/logos/bltcc4c1588eeb3b50c-UCLA_Primary.svg",
  "PENNSYLVANIA STATE UNIVERSITY, THE" = "C:/Users/zmd5431/OneDrive - Northwestern University/Documents/logos/blt847a4f5f23a8e9f6-PennState.svg",
  "UNIVERSITY OF MINNESOTA" = "C:/Users/zmd5431/OneDrive - Northwestern University/Documents/logos/blt0deda8e320f8ceb0-Minnesota.svg",
  "OHIO STATE UNIVERSITY" = "C:/Users/zmd5431/OneDrive - Northwestern University/Documents/logos/blt6210860e64dfd0b3-OhioState.svg",
  "UNIVERSITY OF SOUTHERN CALIFORNIA" = "C:/Users/zmd5431/OneDrive - Northwestern University/Documents/logos/blta8e25c5593bd2501-USC_Primary.svg",
  "UNIVERSITY OF ILLINOIS AT URBANA-CHAMPAIGN" = "C:/Users/zmd5431/OneDrive - Northwestern University/Documents/logos/blt5495cedbeaef016a-Illinois-1.svg",
  "UNIVERSITY OF NEBRASKA LINCOLN" = "C:/Users/zmd5431/OneDrive - Northwestern University/Documents/logos/bltbbde03ccc65aa666-Nebraska_(2025_Logo).svg"
)

# Create square matrix
mat <- matrix(0, nrow = length(orgs), ncol = length(orgs),
              dimnames = list(orgs, orgs))

# Fill matrix with weights
for (i in seq_len(nrow(edges))) {
  mat[edges$org1[i], edges$org2[i]] <- edges$weight[i]
  mat[edges$org2[i], edges$org1[i]] <- edges$weight[i] # make symmetric
}

print(orgs)
# Define color palette for organizations
pal_orgs <- c(
  "#18453B", # Michigan State Green
  "#4E2A84", # Northwestern Purple
  "#BB0000", # Ohio State Scarlet
  "#041E42", # Penn State Navy
  "#CEB888", # Purdue Gold
  "#CC0033", # Rutgers Scarlet
  "#2D68C4", # UCLA Blue
  "#E84A27", # Illinois Orange
  "#FFCD00", # Iowa Gold
  "#E03A3E", # Maryland Red
  "#FFCB05", # Michigan Maize
  "#7A0019", # Minnesota Maroon
  "#E41C38", # Nebraska Scarlet
  "#990000", # USC Cardinal
  "#4B2E83", # Washington Purple
  "#154733"  # Oregon Green
)
# Assign colors to orgs
pal_orgs <- pal_orgs[1:length(orgs)]
bg_color <- colorspace::darken("white", 0.2)

# Create and save the chord diagram
ragg::agg_png(here("bigten_nih_collaborations.png"),
              res = 500, width = 10, height = 8, units = "in", bg = bg_color)

par(family = "Outfit", cex = 1.8, col = "white", bg = bg_color, mai = rep(0.5, 4))

chordDiagram(mat, transparency = 0.3,
             grid.col = pal_orgs,
             link.border = "#FFFFFF", link.lwd = 0.2,
             annotationTrack = c("grid"), # only keep grid, no names
             annotationTrackHeight = mm_h(c(3, 5)),
             link.largest.ontop = TRUE)

y_pos <- CELL_META$ylim[2] + 1.8  # 0.2 units above the top
circos.trackPlotRegion(track.index = 1, ylim = c(0, 1), panel.fun = function(x, y) {
  org <- CELL_META$sector.index
  img_path <- logo_paths[[org]]
  if (!is.null(img_path)) {
    # Convert SVG to raster
    tmp_png <- tempfile(fileext = ".png")
    rsvg_png(img_path, tmp_png)
    logo <- readPNG(tmp_png)
    circos.raster(logo, CELL_META$xcenter, y_pos, width = "10mm", height = "10mm")
  }
}, bg.border = NA)


title(main = "NIH Project Collaborations Among Big Ten Universities in 2024",
      sub = "Edge thickness = number of collaborations\nSource: NIH RePORTER",
      col.main = "black", cex.main = 0.9)

invisible(dev.off())



# Function to plot a single chord diagram with logos
plot_chordDiagram <- function(name, rank) {
  # Highlight colors for current org
  row_colors <- rep("#EEEEEE33", length(orgs))
  row_colors[rank] <- pal_orgs[rank]
  
  grid_colors <- scales::alpha(pal_orgs, 0.2)
  grid_colors[rank] <- pal_orgs[rank]
  
  # Draw chord diagram
  chordDiagram(mat,
               grid.col = grid_colors,
               link.border = "#FFFFFF", link.lwd = 0.2,
               annotationTrack = c("grid"),
               annotationTrackHeight = mm_h(c(3, 5)),
               link.largest.ontop = TRUE,
               row.col = row_colors)
  
  # Add logos for each sector
  y_pos <- CELL_META$ylim[2] + 1.8
  circos.trackPlotRegion(track.index = 1, ylim = c(0, 1), panel.fun = function(x, y) {
    org <- CELL_META$sector.index
    img_path <- logo_paths[[org]]
    if (!is.null(img_path)) {
      tmp_png <- tempfile(fileext = ".png")
      rsvg_png(img_path, tmp_png)
      logo <- readPNG(tmp_png)
      circos.raster(logo, CELL_META$xcenter, y_pos, width = "10mm", height = "10mm")
    }
  }, bg.border = NA)
  
  
  # Add title
  title(main = paste("NIH Project Collaborations Among Big Ten Universities in 2024"),
        sub = "Edge thickness = number of collaborations",
        col.main = "black", cex.main = 0.9)
  
  circos.clear() # Reset for next plot
}

# Generate 16 individual PNGs
for (i in 1:16) {
  file_name <- here(paste0("diagram_", i, "_", gsub(" ", "_", orgs[i]), ".png"))
  ragg::agg_png(file_name, res = 500, width = 10, height = 8, units = "in", bg = bg_color)
  
  par(family = "Outfit", cex = 1.8, col = "white", bg = bg_color, mai = rep(0.5, 4))
  
  plot_chordDiagram(orgs[i], i)
  
  invisible(dev.off())
}
