suppressPackageStartupMessages({
  library(tidyverse)    # dplyr, ggplot2, tibble, readr, etc.
  library(lubridate)    # date-time helpers
  library(dados)
})
# Best practice: set a global ggplot theme for consistent visuals
theme_set(theme_minimal(base_size = 12))

# -------------------------------------------------------------------------

voo <- dados::voos
# -------------------------------------------------------------------------
#criando numeros

x <- c("1.2", "5.6", "1e3")
parse_double(x)


x <- c("$1,24", "USD 3,513", "59%")
parse_number(x)
# -------------------------------------------------------------------------
# contagem

voo %>% count(destino)


voo %>% count(destino, sort = TRUE)

# variacao do codigo acima
voo %>%
  group_by(destino) %>%
  summarize(
    n = n(),
    delay = mean(atraso_chegada, na.rm = TRUE)
  )


n()

# variacao de count() e n()
voo %>%
      group_by(destino) %>%
      summarize(companhia_aerea = n_distinct(companhia_aerea),
                n = n()) %>%
      arrange(desc(companhia_aerea))


#uma contagem ponderada é uma soma

voo %>%
    group_by(cauda) %>%
    summarize(miles = sum(distancia))

# obs
voo %>%
  group_by(cauda) %>%
  mutate(miles = sum(distancia)) %>%
  ungroup() %>%
  mutate(teste = lag(miles)) %>% select(cauda,miles,teste)

#contagem ponderada com count

voo %>% count(cauda, wt = distancia)

voo %>%
    group_by(destino) %>%
    summarize(n_cancelado = sum(is.na(horario_saida)))

#-----------
# solucoes
# 1.
voo %>% count(is.na(horario_saida),name = 'faltante')
# 2.
#exemplo : flights |> count(destino, sort = TRUE)
voo %>%
  group_by(destino) %>%
  summarise(n = n()) %>%
  arrange(-n) # ou desc(n)

# exemplo 2: flights |> count(tailnum, wt = distance)
voo %>%
  group_by(cauda) %>%
  summarise(distancia_total = sum(distancia))

## Numeric transformations
# reciclagem
x <- c(1, 2, 10, 20)
x / 5
x / c(5, 5, 5, 5)
x * c(1, 2)
x * c(1, 2, 3)

# Example 11
voo %>%
  filter(mes == c(1, 2)) %>% view()

voo %>%
  filter(mes %in% c(1, 2))
# -----------------------------------------------------------------
# min e max

# Example 12
df <- tribble(
  ~x, ~y,
  1,  3,
  5,  2,
  7, NA,
)

df %>%
  mutate(
    min = pmin(x, y, na.rm = TRUE),
    max = pmax(x, y, na.rm = TRUE)
  )

# como que ela difere de so usar min max?
df %>%
  mutate(
    min = min(x, y, na.rm = TRUE),
    max = max(x, y, na.rm = TRUE)
  )
# -----------------------------------------------------------------
# modulos

# Example 14
1:10 / 3
1:10 %/% 3
1:10 %% 3

515%/%100
# como esses operadores podem ser uteis?
# Example 15
voos %>%
  mutate(
    hora = saida_programada %/% 100,
    minuto = saida_programada %% 100,
    .keep = "used"
  )

voos |>
  group_by(hora = saida_programada %/% 100) |>
  summarize(prop_cancelados = mean(is.na(horario_saida)), n = n()) |>
  filter(hora > 1) |>
  ggplot(aes(x = hora, y = prop_cancelados)) +
  geom_line(color = "grey50") +
  geom_point(aes(size = n))

# -----------------------------------------------------------------
# arredondamento
#nota sobre logaritmo

round(123.456)

# Example 18
round(123.459, 2)
round(123.45, 1)
round(123.456, -1)
round(123.456, -2)

#arredondamento para o inteiro par
# Example 19
round(c(1.5, 2.5))

# Example 20
x <- 123.456

floor(x)
ceiling(x)

# Example 21
x / 0.01
# essas funcoes nao tem o parametro digits, entao...
floor(x / 0.1) * 0.1

ceiling(x / 0.01) * 0.01

# Example 22
# usar com round para chegar ao numero mais proximo
round(x / 4) * 4
round(x/ 0.25) * 0.25

# =============================================================================
# separando vetor em intervalos numericos
x <- c(1, 2, 5, 10, 15, 20)
cut(x, breaks = c(0, 5, 10, 15, 20))

#quebras nao precisam ser espacadas igualmente
cut(x, breaks = c(0, 5, 10, 100))

# usando labels
cut(x,
  breaks = c(0, 5, 10, 15, 20),
  labels = c("sm", "md", "lg", "xl")
)

# Como funciona se algum valor nao estiver coberto pelos breaks
y <- c(NA, -10, 5, 10, 30)
cut(y, breaks = c(0, 5, 10, 15, 20))

# ------ Outros parametros uteis -----------------
x <- c( 0, 1, 2, 2.5, 3, 5, 5, 6, 10)
brks <- c(0, 2, 5, 10)
#1) right = TRUE (padrão) vs include.lowest
#Intervalos do tipo (a, b]; o limite inferior é aberto. O 0 fica de fora sem include.lowest.
cut(x, breaks = brks, right = T) # o que acontece com right = FALSE?
cut(x, breaks = brks, right = TRUE, include.lowest = TRUE)
cut(x, breaks = brks, right = FALSE, include.lowest = TRUE)

# ordered results
cut(x, breaks = brks, include.lowest = TRUE, labels = c("p","m","g"), ordered_result = TRUE)

# quebras por quantis
  # gerando quantis desejados
quantis <- seq(0, 1, 0.25)
  # encontrando os quantis desejados no vetor x
qbrks <- quantile(x, probs = quantis, na.rm = TRUE)
  # utilizando quantis como quebra, garante distribuicao homogenea
cut(x, breaks = qbrks, include.lowest = TRUE, labels = c("Q1","Q2","Q3","Q4"))

# exemplo de aplicacao no cenario bancario ------->
#-------------------------------------------------
#agregadores cumulativos e rolantes
x <- 1:10
cumsum(x)
cumprod(x)
cummin(x)
cummean(x)

# exercicios da secao 13.4
# 1 explicar o que cada linha deste codigo faz

voo |>
  group_by(hora = saida_programada %/% 100) |>
  #voo
  #515/100
  #515%/%100
  summarize(prop_cancelados = mean(is.na(horario_saida)),
            n = n()) |>
  #mean(c(T,F,T,F))
  filter(hora > 1) |>
  ggplot(aes(x = hora, y = prop_cancelados)) +
  geom_line(color = "grey50") +
  geom_point(aes(size = n))

#2
deg2rad <- function(deg) deg * pi / 180
rad2deg <- function(rad) rad * 180 / pi

sin(deg2rad(30)); cos(deg2rad(60)); tan(deg2rad(45))
atan2(y = 1, x = 1) %>% rad2deg()
-------------------------------------------------
## Transformacoes gerais


x <- c(1, 2, 2, 3, 4, NA)
min_rank(x)


# Example 30
df <- tibble(x = x)
df |>
  mutate(
    num_linha = row_number(x),
    ranqueamento_dense = dense_rank(x),
    ranqueamento_percentual = percent_rank(x),
    distrib_cumulativa = cume_dist(x))

# Example 31
df <- tibble(id = 1:10)

df %>%
  mutate(
    row0 = row_number() - 1,
    three_groups = row0 %% 3,
    three_in_each_group = row0 %/% 3
  )

# ---------------------------------------------
# OFFSET
# Example 32
x <- c(2, 5, 11, 11, 19, 35)
lag(x)
lead(x)

# Example 33
x - lag(x) #checa diferenca entre valor atual e anterior

x == lag(x) #testa igualdade ao valor anterior


# argumento n da funcao lag
lag(x,n=2)
lead(x,n=3)


### identificadores consecutivos














# ---- Solucoes --------------------------------------------------

# 1) Count rows with a missing value for a given variable
# Example: count missing dep_time values in voo
voo %>%
  count(dado_faltante = is.na(horario_saida))

voo %>% filter(is.na(horario_saida)) %>% count(name = "n_missing")

#
voo %>%
  group_by(destino) %>%
  summarize(n = n(), .groups = "drop") %>%
  arrange(desc(n))

#2
voo %>%
  group_by(cauda) %>%
  summarize(dist_total = sum(distancia, na.rm = TRUE), .groups = "drop") %>%
  arrange(desc(dist_total))

# exercicio 12.4
#explicar a figura

# 2)
deg2rad <- function(deg) deg * pi / 180
rad2deg <- function(rad) rad * 180 / pi

sin(deg2rad(30)); cos(deg2rad(60)); tan(deg2rad(45))
atan2(y = 1, x = 1) %>% rad2deg()
