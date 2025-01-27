library(Rtsne)
library(dendextend)
library(circlize)

# Load the data
data <- read.csv('outputFiles/country_personality_dendrogram_input.csv', header=TRUE, row.names="COUNTRY")

# Set seed for reproducibility
set.seed(123)

# Run t-SNE to reduce the matrix to 2 dimensions
tsne_result <- Rtsne(data, dims = 2, perplexity = 30, verbose = TRUE, max_iter = 500)

# Extract the t-SNE coordinates
reduced_data <- tsne_result$Y

# Compute distance matrix on the reduced data
dist_matrix <- dist(reduced_data)
custom_labels <- rownames(data)
labels(dist_matrix) <- custom_labels

# Perform hierarchical clustering
hc <- hclust(dist_matrix)

# Convert the hclust object to a dendrogram
dend <- as.dendrogram(hc)

# # Circular dendrogram
# circlize_dendrogram(dend,
#                     labels_track_height = NA,
#                     dend_track_height = 0.5)

# Customize dendrogram
dend <- color_branches(dend, k = 3)
dend <- set(dend, "labels_cex", 0.5)

# pdf(file = "My Plot.pdf",   # The directory you want to save the file in
#     width = 6, # The width of the plot in inches
#     height = 6) # The height of the plot in inches

# Draw circular dendrogram with adjusted parameters
# Use one sector for the entire dendrogram
circos.par(gap.after = 10, cell.padding = c(0, 0, 0, 0))

# Initialize the circular layout with one sector, "a"
circos.initialize(factors = "a", xlim = c(0, length(custom_labels)))

# Draw the circular dendrogram
circlize_dendrogram(dend, facing = "outside")

# Add labels for the leaves of the dendrogram with adjusted position and size
for (i in seq_along(custom_labels)) {
  circos.text(i - 0.5, 1.5, custom_labels[i],
              sector.index = "a",
              facing = "clockwise", niceFacing = TRUE,
              adj = c(0, 0.5), cex = 0.5)  # Adjust cex for label size
}

# Clear the plotting parameters
circos.clear()

# # Step 3: Run dev.off() to create the file!
# dev.off()