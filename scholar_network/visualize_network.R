library(cowplot)
library(igraph)
library(dplyr)
# cleaning network data
edges <- read.table("network.tsv", sep="\t", header=T)
network <- graph_from_data_frame(edges, directed=FALSE)
set.seed(123)
l <- layout.fruchterman.reingold(network, niter=1500) # layout
fc <- walktrap.community(network) # community detection

# node locations
nodes <- data.frame(l); names(nodes) <- c("x", "y")
nodes$cluster <- factor(fc$membership)
nodes$label <- fc$names
nodes$degree <- degree(network)

# edge locations
edgelist <- get.edgelist(network, names=FALSE)
edges <- data.frame(nodes[edgelist[,1],c("x", "y")], nodes[edgelist[,2],c("x", "y")])
names(edges) <- c("x1", "y1", "x2", "y2")

favorites <- c("Jeong, Hyun-Hwan", "Wee, Kyubum", "Sohn, Kyung-Ah", 
               "Liu, Zhandong", "Zoghbi, Huda Y", "Kim, Seon Young", "Leem, Sangseob")

nodes.filtered <- nodes %>% filter(label %in% favorites)
# and now visualizing it...
pq <- ggplot(nodes, aes(x=x, y=y, color=cluster, label=label, size=degree))
pq <- pq + theme(
  panel.background = element_rect(fill = "white"),
  plot.background = element_rect(fill="white"),
  axis.line = element_blank(), axis.text = element_blank(),
  axis.ticks = element_blank(),
  axis.title = element_blank(), panel.border = element_blank(),
  panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  legend.background = element_rect(colour = F, fill = "black"),
  legend.key = element_rect(fill = "black", colour = F),
  legend.title = element_text(color="white"),
  legend.text = element_text(color="white"),
  legend.position = "none"
)
pq <- pq + geom_point(color="grey20", aes(fill=cluster),
                      shape=21,  alpha=0.75)
pq <- pq +  geom_segment(
  aes(x=x1, y=y1, xend=x2, yend=y2, label=NA),
  data=edges, size=0.25, color="grey20",  alpha=1/8) 
pq <- pq + geom_text(color="black", aes(label=label, size=7, y=y), data=nodes.filtered)



pq
save_plot(file="network.pdf", pq, base_aspect_ratio = 2, base_height = 3)
