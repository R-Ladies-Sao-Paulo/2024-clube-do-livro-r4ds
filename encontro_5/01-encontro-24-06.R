# Instalar os pacotes
# install.packages("tidyverse")
# install.packages("dados") # dados traduzidos

# carregar os pacotes
library(tidyverse)
library(dados)

# Quatro pontos
# dplyr::filter() -> pacote::funcao()


# Conhecer a base de dados
voos
# cada linha representa um voo
?voos # documentacao

glimpse(voos)
# Rows: 336,776
# Columns: 19
# $ ano              <int> 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2013, …
# $ mes              <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
# $ dia              <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
# $ horario_saida    <int> 517, 533, 542, 544, 554, 554, 555, 557, 557, 558, 558,…
# $ saida_programada <int> 515, 529, 540, 545, 600, 558, 600, 600, 600, 600, 600,…
# $ atraso_saida     <dbl> 2, 4, 2, -1, -6, -4, -5, -3, -3, -2, -2, -2, -2, -2, -…
# $ horario_chegada  <int> 830, 850, 923, 1004, 812, 740, 913, 709, 838, 753, 849…
# $ chegada_prevista <int> 819, 830, 850, 1022, 837, 728, 854, 723, 846, 745, 851…
# $ atraso_chegada   <dbl> 11, 20, 33, -18, -25, 12, 19, -14, -8, 8, -2, -3, 7, -…
# $ companhia_aerea  <chr> "UA", "UA", "AA", "B6", "DL", "UA", "B6", "EV", "B6", …
# $ voo              <int> 1545, 1714, 1141, 725, 461, 1696, 507, 5708, 79, 301, …
# $ cauda            <chr> "N14228", "N24211", "N619AA", "N804JB", "N668DN", "N39…
# $ origem           <chr> "EWR", "LGA", "JFK", "JFK", "LGA", "EWR", "EWR", "LGA"…
# $ destino          <chr> "IAH", "IAH", "MIA", "BQN", "ATL", "ORD", "FLL", "IAD"…
# $ tempo_voo        <dbl> 227, 227, 160, 183, 116, 150, 158, 53, 140, 138, 149, …
# $ distancia        <dbl> 1400, 1416, 1089, 1576, 762, 719, 1065, 229, 944, 733,…
# $ hora             <dbl> 5, 5, 5, 5, 6, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 5, 6, 6, …
# $ minuto           <dbl> 15, 29, 40, 45, 0, 58, 0, 0, 0, 0, 0, 0, 0, 0, 0, 59, …
# $ data_hora        <dttm> 2013-01-01 05:00:00, 2013-01-01 05:00:00, 2013-01-01 …

# Estrutura ---------

# funcao(base_de_dados, quais_colunas_vamos_usar)
# resulta em uma base de dados alterada

voos 

# base de dados: voos
# colunas que vamos usar: destino == "IAH"
# retorno: base filtrada
filter(voos, destino == "IAH")

# pipe |> (atalho: ctrl shift M)
voos |> 
  filter(destino == "IAH")

# exemplo
atraso_chegada_diario <- voos |> 
  filter(destino == "IAH") |> 
  select(ano, mes, dia, destino, atraso_chegada) |> 
  group_by(ano, mes, dia) |> 
  summarise(
    media_atraso_chegada = mean(atraso_chegada, na.rm = TRUE)
  )


# Linhas ----------------
# filter() - filtrar as linhas
# arrange() - ordernar a base de dados
# distinct() - busca valores únicos/distintos
# count() - conta quantas linhas tem por grupo

## filter --------
# operadores
# == - igual à
# != - diferente
# > - maior que
# < - menor que
# >= - maior ou igual à
# <= - menor ou igual à

voos |> 
  filter(atraso_saida > 120) |> 
  view()

voos |> 
  filter(atraso_saida >= 120) |> 
  view()

# voos que partiram dia 1 de janeiro
# operador AND - & ou a vírgula
voos |> 
  filter(mes == 1, dia == 1)

voos |> 
  filter(mes == 1 & dia == 1)

# voos que partiram em janeiro ou fevereiro
# operador OR (ou) - |

voos |> 
  filter(mes == 1 | mes == 2) |> 
  view()

# voos que partiram no primeiro semestre
# operador %in%

voos |> 
  filter(mes %in% c(1:6)) |> 
  view()

# operador not !

voos |> 
  filter(! mes %in% c(1, 2))

# erros comuns ao usar filter

voos |> 
  filter(mes = 1)

# ! We detected a named input.
# ℹ This usually means that you've used `=` instead of `==`.
# ℹ Did you mean `mes == 1`?

voos |> 
  filter(mes == 1)

# erro comum 2

voos |> 
  filter(mes == 1 | 2) |> 
  distinct(mes)

# certo:
voos |> 
  filter(mes == 1 | mes == 2) 

# certo:
voos |> 
  filter(mes %in% c(1, 2)) 

## arrange --------------
# reordena as linhas

voos |> 
  arrange(atraso_saida) # ordena de forma crescente

voos |> 
  arrange(ano, mes, dia, atraso_saida)

voos |> 
  arrange(desc(atraso_saida)) # ordena de forma decrescente

voos |> 
  arrange(-atraso_saida) # ordena de forma decrescente


# quais sao os 10 atrasos maiores
voos |> 
  arrange(desc(atraso_saida)) |> 
  head(10) |> 
  mutate(atraso_saida_hora = atraso_saida/60) |> 
  view()

voos |> 
  select(ano, mes, dia, origem, atraso_saida) |> 
  arrange(origem, atraso_saida) # ordem alfabética

## distinct()

voos |> 
  distinct()

voos |> 
  distinct(origem, destino) 

voos |> 
  distinct(origem, destino) |> 
  arrange(origem, destino) |> 
  view()

voos |> 
  distinct(origem, destino, .keep_all = TRUE)


# qual a diferença entre unique() e distinct()
# unique() - r base
# distinct() - dplyr

# nao funciona
#voos |> 
#  unique(origem)

unique(voos$origem)

## count() ----

voos |> 
  count(origem, destino)

voos |> 
  count(origem, destino, sort = TRUE)


# qual dos 3 aeroportos de nyc tinha mais destinos disponíveis em 2013?

voos |> 
  distinct(origem, destino) |> 
  count(origem, sort = TRUE)


voos |> 
  count(companhia_aerea, sort = TRUE) |>
  head(10) |> 
  ggplot() +
  geom_col(aes(x = companhia_aerea, y = n))
