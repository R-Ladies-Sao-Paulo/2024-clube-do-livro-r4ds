library(tidyverse)
#remotes::install_github("cienciadedatos/dados")
library(dados)

#Em cada tabela1, tabela2 e tabela3, cada observação representa um país. 
#Na tabela 1, país é o nome do país, ano é o ano da recolha de dados, 
#casos é o número de pessoas com a doença nesse ano e população é o número de 
#pessoas em cada país nesse ano. 
#Na tabela 2, país e ano são iguais aos da tabela 1, tipo é o tipo de número e 
#contagem é o número de observações (casos ou população dependendo do tipo). 
#Finalmente, na tabela 3, o país e o ano são novamente os mesmos que na tabela 1, 
#e a taxa é a taxa da doença (casos divididos pela população).

# Tabelas 
tabela1

tabela2

tabela3

# Calcular a taxa (_rate_) por 10.000
tabela1 |>
  mutate(taxa = casos / populacao * 10000)

# Calcular a taxa - tabela 2
tabela2 |>
  pivot_wider(
    names_from = tipo,
    values_from = contagem) |> 
  rename(populacao=população) |>
  mutate(taxa = casos / populacao * 10000)

# Calcular a taxa - tabela 3
tabela3 |>
  separate_wider_delim(
    cols = taxa, 
    delim = "/", 
    names = c("casos", "populacao")) |>
  mutate(
    casos = as.numeric(casos),
    populacao = as.numeric(populacao),
    taxa = casos / populacao * 10000)

# Dados top100musicas

top100musicas |> glimpse()

top100musicas|>
  pivot_longer(
    cols = starts_with("semana"), 
    names_to = "semana", 
    values_to = "posicao"
  ) |>
  glimpse()

# melhorando o formato da tabela

top100musicas|>
  pivot_longer(
    cols = starts_with("semana"), 
    names_to = "semana", 
    values_to = "posicao",
    values_drop_na = TRUE) |> 
  mutate(
    semana = parse_number(semana))

#5.3.3 Muitas variáveis nos nomes de colunas
# dataset who2
# usando o names_sep

#5.3.4 Dados e nomes de variáveis nos cabeçalhos das colunas

nucleo_familiar |> colnames()

nucleo_familiar |>
  pivot_longer(
    cols = !familia,
    names_to = c(".value", "crianca"),
    names_sep = "_",
   # values_drop_na = TRUE
  )

#5.4 Transformando os dados para o formato largo (Widening data)

cms_paciente_experiencia
