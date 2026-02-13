library(ggplot2)
# Recombination rates
L = c(1,1.1,1.2,1.5,2,5)

# Distance (Mb)
D = c(0.5, 0.4, 0.2, 0.3, 0.1, 0.07, 0.05, 0.03)

L_vec = vector()
D_vec = vector()
G_vec = vector()

for(l in L){
  for(d in D){
    L_vec = c(L_vec, l)
    D_vec = c(D_vec, d)
    G = (-log(0.1)) / (2*((l*d)/100))
    G_vec = c(G_vec, G)
  }
}

df = data.frame(x = D_vec, y = G_vec, col = L_vec)

A = ggplot(df, aes(x = x, y = y, col = factor(col))) +
  geom_line() + 
  guides(colour = guide_legend(position = "right")) +
  theme_classic(base_family = "Helvetica")+
  theme(axis.text.y = element_text(size = 8, color = "black")) +
  theme(axis.text.x = element_text(size = 8, color = "black")) +
  scale_x_log10() 

ggsave(A, file = "LD.jpeg", height = 3, width = 5, dpi = 600)
