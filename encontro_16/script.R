# 18 VALORES FALTANTES

##  Pre-requisitos
library(tidyverse)
library(dplyr)
library(tidyr)

#install.packages("dados")
library(dados)







# 1. Valores faltantes EXPLICITOS -----------------------------------------


## 1.1 Última observação levada adiante
tratamento <- tribble(
  ~pessoa,           ~tratamento, ~resposta,
  "Derrick Whitmore", 1,         7,
  NA,                 2,         10,
  NA,                 3,         NA,
  "Katherine Burke",  1,         4,
  "Luana A",          1,         -99
)

tratamento |>
  view()







## funcao FILL
tratamento |>
  fill(everything())

help(fill)






## argumento .direction - controla a direção do preenchimento
# preenche valores ausentes com o valor anterior (de cima para baixo).
tratamento |>
  fill(pessoa, .direction = "up")



## preenche com o valor seguinte (de baixo para cima).
tratamento |>
  fill(resposta, .direction = "up")
















# 1.2 Valores Fixos

## substituir valores ausentes por valores fixos (por ex. zero)

x <- c(1, 4, 5, 7, NA)

coalesce(x, -999)


# temos outra funcao
replace_na(x, -99)


## o oposto onde um valor concreto representa na verdade um valor ausente "NA"

x <- c(1, 4, 5, 7, -99)
na_if(x, -99)


# Mais umA opção: já tratar na leitura

##  Se souber o valor ausente antes, use na = "99" em read_csv().

# library(readr)

dados <- read_csv("meuarquivo.csv", na = "99")

## Se perceber depois, use na_if() para corrigir.

tratamento

tratamento |>
  mutate(resposta = na_if(resposta, -99))


# 1.3 NaN (not a number)

x <- c(NA, NaN)

x * 10

x == 1

is.na(x)
is.nan(x)

## em caso de precisar diferenciar um NA de um NaN, você pode usar is.nan(x).
0/0

0 * Inf

Inf - Inf

sqrt(-1)














# 2. Valores faltantes IMPLICITOS -----------------------------------------


## Ou seja, simplesmente o dado de uma linha ou coluna nao esta la

acoes <- tibble(
  ano  = c(2020, 2020, 2020, 2020, 2021, 2021, 2021),
  trimestre   = c(   1,    2,    3,    4,    2,    3,    4),
  preco = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)


# 2.1 Pivotagem
## Deixar os dados mais largos (com mais colunas) pode tornar explícitos
## os valores ausentes implícitos (veja diferenca na tibble e no console)

acoes_pivot <- acoes |>
  pivot_wider(
    names_from = trimestre,
    values_from = preco, names_prefix = "trimestre_"
  )

## caso queira pode elimina-los usando drop_na()



acoes|>
  drop_na(preco)




# 2.2 Completar
## A função tidyr::complete() permite gerar valores faltantes explícitos

acoes |>
  complete(ano, trimestre)


## você pode saber que o conjunto de dados acoes deve
## ser executado de 2019 a 2021, então você pode fornecer explicitamente esses valores para ano:

acoes |>
  complete(ano = 2019:2021, trimestre)


## Se o intervalo de uma variável estiver correto, mas nem todos os valores estiverem presentes,
## você pode usar a full_seq(x, 1) para gerar todos os valores de min(x) a max(x) espaçados por 1
## (se eu tentar em preco nao da certo pq preco nao um valor observado (medida) para gerar combinações.

acoes |>
  complete(ano = 2019:2021, trimestre, preco = full_seq(preco, 1))


acoes |>
  complete(ano = 2019:2021,trimestre = full_seq(trimestre, 1))

## e numerico, Ela só funciona quando o espaçamento é regular.
## Se o vetor estiver irregular (por exemplo: 1, 2, 4.5), ela vai gerar erro.








# 3.Uniões (joins)
## observações implicitamente ausentes: uniões (joins) que esta detalhado no Capítulo 19
## como saber se ha valores que estão faltando em um conjunto de dados? quando você o compara com outro.


# Anti-join
## dplyr::anti_join(x, y) porque seleciona apenas as linhas em x que não têm correspondência em y



view(voos)

view(aeroportos)

# exemplo 1
## o voos é reduzido para uma coluna chamada codigo_aeroporto com valores únicos do destino.
## todos os aeroportos de destino que aparecem nos voos, sem repetição.
voos |>
  distinct(codigo_aeroporto = destino)


## o anti_join compara codigo_aeroporto (do resultado acima) com a coluna de mesmo nome em aeroportos
# o resultado final e a lista de codigos  aeroportos que aparecem como destino em voos, mas que não estão cadastrados na tabela aeroportos.
voos |>
  distinct(codigo_aeroporto = destino) |>
  anti_join(aeroportos)




# exemplo 2

view(avioes)

voos |>
  distinct(codigo_cauda = cauda) |>
  anti_join(avioes)





# 18.3.4 Exercicios -------------------------------------------------------


## Você consegue encontrar alguma relação entre a companhia_aerea e as
## linhas que parecem estar faltando em avioes?

glimpse(voos)
glimpse(aeroportos)
glimpse(companhias_aereas)

# 1) Caudas presentes em voos mas ausentes em 'avioes'
na_cauda <- voos |>
  distinct(cauda) |>
  anti_join(avioes, by = c("cauda" = "codigo_cauda")) |> # em 'avioes' a coluna também se chama 'codigo_cauda'
  print()


# 2) Companhias que usam essas caudas

companhias_faltantes <- voos |>
  distinct(companhia_aerea, cauda) |>
  anti_join(avioes, by = c("cauda" = "codigo_cauda")) |>
  distinct(companhia_aerea) |>
  view()




# um pouco mais
# pares únicos companhia-cauda que NÃO existem em 'avioes'
faltantes_pairs <- voos |>
  distinct(companhia_aerea, cauda) |>
  anti_join(avioes, by = c("cauda" = "codigo_cauda"))|>
  view()


# contagem de caudas ausentes por companhia
faltantes_pairs |>
  count(companhia_aerea, name = "qtd_caudas_ausentes") |>
  arrange(desc(qtd_caudas_ausentes))|>
  view()





# 4. Fatores e Grupos Vazios ----------------------------------------------



## Outro tipo de ausencia e "um grupo vazio", um grupo vazio nao contem nenhuma observacao


saude <- tibble(
  nome   = c("Ikaia", "Oletta", "Leriah", "Dashay", "Tresaun"),
  fumante = factor(c("nao", "nao", "nao", "nao", "nao"), levels = c("sim", "nao")),
  idade    = c(34, 88, 75, 47, 56),
)


# para contar o numero de fumantes
saude |> count(fumante)




# para saber o numero de nao-fumantes
saude |> count(fumante, .drop = FALSE)


# e para os plots?
library(ggplot2)


ggplot(saude, aes(x = fumante)) +
  geom_bar() +
  scale_x_discrete()

ggplot(saude, aes(x = fumante)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)



saude |>
  group_by(fumante, .drop = FALSE) |>
  summarize(
    n = n(),
    idade_media = mean(idade),
    idade_min = min(idade),
    idade_max = max(idade),
    idade_desvpad = sd(idade)
  )




# um vector com dois valores ausentes
x1 <- c(NA, NA)
length(x1)

x2 <- numeric()
length(x2)



## as funcoes dentro de summarize funcionam com vetores zero, e dar valores estranhos como -inf, NaN
##  porem podemos realizar o summarize, tornando os valores implicitos em explicitos com a funcao complete()



saude |>
  group_by(fumante) |>
  summarize(
    n = n(),
    idade_media = mean(idade),
    idade_min = min(idade),
    idade_max = max(idade),
    idade_desvpad = sd(idade)
  ) |>
  complete(fumante) |>
  mutate(n = replace_na(n, 0))


# Adicionais --------------------------------------------------------------


#install.packages("naniar")
library(naniar)

gg_miss_var(starwars)

#install.packages("simputation")



# Revisao -----------------------------------------------------------------

## valores ausente explicitos → conseguimos distinguir pois estao na forma de NA,NaN, zero, -99, 9999, -999

## valores ausente implicitos → existe uma ausencia de dados (nao estao identificados)

## fill  → para preencher a coluna

## distinct()  → serve para “mostrar só o que é único”, mantendo apenas as linhas únicas.
## ex. do companhia_aerea, cauda evita contar a mesma cauda mais de uma vez
## por companhia (ou seja, o mesmo valor em uma coluna).

## pivot_wider

## complete()  → parecido com o select, funcionar para adicionar valores a coluna onde nao ha observacoes

## anti_join(...) → tira as caudas que já estão na tabela avioes (ou seja, mostra os valores que estao em x, mas nao em y).

