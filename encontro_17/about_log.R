library(tidyverse)

# --- 1) dobrando / dividindo log2 ---------------------------------

x <- c(5, 10, 20, 40, 80)
log2(x)
diff(log2(x))

y <- c(80, 40, 20, 10, 5)
diff(log2(y))

# Identidade
a <- 40; b <- 80
log2(b) - log2(a)
log2(b / a)

# --- 2) log10 facil transformacao ----------------------------------

v <- c(10, 100, 1000, 10000)
log10(v)
10^(1:4)


# --- 3) Intuicao visual ------------------------------------

df <- tibble(n = 0:10,
             x = 2^n,
             log2x = n)

ggplot(df, aes(n, x)) +
  geom_point() + geom_line() +
  labs(title = "Escala original: crescimento 2^n",
       x = "n", y = "x")

ggplot(df, aes(n, log2x)) +
  geom_point() + geom_line() +
  labs(title = "Escala Log2: passos iguais equivalem a distancias iguais",
       x = "n", y = "log2(x) = n")
