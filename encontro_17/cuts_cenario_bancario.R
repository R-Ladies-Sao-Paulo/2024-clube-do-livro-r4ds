library(dplyr)
library(ggplot2)
library(scales)

df <- tibble(score = runif(5000),
             default = rbinom(5000, 1, prob = 0.08*(1 - score))) # quanto maior a score menor a chance de default
n_bins <- 10
x <- c(5, 1, 3, 2, 2)
ntile(x, 2)
# 1) Quantis do score: 1 = melhor, n_bins = pior
df_bins <- df %>%
  mutate(bin = ntile(desc(score), n_bins)) %>%  # desc() pois score alto = menor risco
  group_by(bin) %>%
  summarise(
    n       = n(),
    events  = sum(default == 1, na.rm = TRUE),
    rate    = events / n
  ) %>%
  ungroup()

# 2) Gráfico de barras: taxa de default por quantil
ggplot(df_bins, aes(x = factor(bin), y = rate)) +
  geom_col() +
  geom_text(aes(label = percent(rate, accuracy = 0.1)), vjust = -0.3, size = 3) +
  scale_y_continuous(labels = percent_format()) +
  labs(
    title = paste0("Taxa de default por ", n_bins, " quantis do score"),
    x = paste0(ifelse(n_bins == 10, "Decil", "Quantil"), " (1 = melhor, ", n_bins, " = pior)"),
    y = "Taxa de default"
  ) +
  theme_minimal()
