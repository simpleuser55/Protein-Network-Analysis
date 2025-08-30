# set path if it's already downloaded & unzipped
ppi <- read.delim("BIOGRID-MV-Physical-4.4.247.tab3.txt")

# check structure
str(ppi)
head(ppi[,1:6])   # peek at first 6 columns

# Extracting the protein interaction columns
edges <- ppi[, c("Official.Symbol.Interactor.A", "Official.Symbol.Interactor.B")]
head(edges)

# Building the network 
library(igraph)

g <- graph_from_data_frame(edges, directed = FALSE)

# Basic info about network
summary(g)

# Sorting important proteins(top hubs)
deg <- degree(g)
top_hubs <- sort(deg, decreasing = TRUE)[1:10]
top_hubs

# Plotting the graph for top hubs
plot(subgraph_from_edges(g, E(g)[1:500]), 
     vertex.size=5, vertex.label=NA,
     main="Protein-Protein Interaction Network (subset)")

# Plotting subgraph of top hubs and their neighbouring hubs
# grab all neighbors of top hubs
hub_neighbors <- unique(unlist(neighborhood(g, order = 1, nodes = top_hubs)))

# make subgraph with hubs + neighbors
sub_g2 <- induced_subgraph(g, vids = hub_neighbors)

plot(sub_g2, 
     vertex.size = 5, 
     vertex.label = NA,
     vertex.color = ifelse(V(sub_g2)$name %in% top_hubs, "red", "lightblue"),
     main = "Top Hub Proteins and Their Interactions")
