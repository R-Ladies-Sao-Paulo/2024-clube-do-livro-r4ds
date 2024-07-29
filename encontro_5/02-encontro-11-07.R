library(tidyverse)
library(dados)
voos <- voos
# Se quiser a versão mais recente, instalar via
# GitHub:
# remotes::install_github("cienciadedatos/dados")

# Exercícios 3.2.5 ------
# 1)

# a)   # Teve um atraso na chegada de duas ou mais horas
voos |>
  filter(atraso_chegada >= 120)

# b)  Voou para Houston (IAH ou HOU)

voos |> 
  filter(destino %in% c("IAH", "HOU"))

# c)   # Foi operado pela United, American ou Delta
voos |> 
  filter(companhia_aerea %in% c("UA", "AA", "DL"))

# d)  Decolou no verão3 (julho, agosto e setembro)

voos |> filter(mes %in% c(7, 8, 9))

# e)  Chegou com mais de duas horas de atraso, mas não teve atraso na decolagem.

voos |> 
  filter(
    atraso_chegada >= 120,
    atraso_saida <= 0
  )

# f) Atrasou pelo menos uma hora, mas recuperou mais de 30 minutos em vôo.

voos |>  filter(atraso_chegada >= 60,
                atraso_saida - atraso_chegada > 30) |> View()


# 4) Houve pelo menos um vôo em cada dia de 2013?

voos |> 
  count(ano, mes, dia) |>
  View()


# colunas -----
# sempre mantém o mesmo número de linhas!!
# trabalha alterando as colunas.

# mutate() ------

# voos |> 
#   mutate(
#     nome_da_coluna_para_criar = operacoes_para_fazer,
#     ....
#   )


voos |> 
  mutate(
    tempo_ganho = atraso_saida - atraso_chegada
  ) |> View()



voos |> 
  mutate(
    tempo_ganho = atraso_saida - atraso_chegada, 
    tempo_voo_h = tempo_voo / 60,
    distancia_km = distancia * 1.60934,
    velocidade = distancia_km / tempo_voo_h 
  ) |> View()

# posicão: .before , .after
voos |> 
  mutate(
    tempo_ganho = atraso_saida - atraso_chegada, 
    tempo_voo_h = tempo_voo / 60,
    distancia_km = distancia * 1.60934,
    velocidade = distancia_km / tempo_voo_h,
    # .before = antes
    # .after = depois
    # nome da coluna ou número da posição da coluna
    .before = 1
  ) |> View()

voos |> 
  mutate(
    tempo_ganho = atraso_saida - atraso_chegada, 
    tempo_voo_h = tempo_voo / 60,
    distancia_km = distancia * 1.60934,
    velocidade = distancia_km / tempo_voo_h,
    .after = distancia
  ) |> View()


# manter

voos |> 
  mutate(
    tempo_ganho = atraso_saida - atraso_chegada, 
    tempo_voo_h = tempo_voo / 60,
    distancia_km = distancia * 1.60934,
    velocidade = distancia_km / tempo_voo_h,
    .keep = "used" # Não gosto do .keep = "used"
  ) |> View()

# salvar o resultado


velocidade_voos <- voos |> 
  mutate(
    tempo_ganho = atraso_saida - atraso_chegada, 
    tempo_voo_h = tempo_voo / 60,
    distancia_km = distancia * 1.60934,
    velocidade = distancia_km / tempo_voo_h
  ) 

# select() -----------------------

voos |> 
  select(ano)

voos |> 
  select(ano, mes, dia)

voos |> 
  select(dia, mes, ano)

voos |> 
  select(ano:horario_chegada)

voos |> 
  select(!ano:dia)

# funções auxiliares do select 

voos |> 
  select(where(is.character)) # is.character é uma função!
# where recebe função como argumento, mas sem os ()

voos |> 
  select(where(is.numeric))

voos |> 
  select(starts_with("horario"))

voos |> 
  select(ends_with("saida"))

voos |> 
  select(contains("voo"))

?num_range

voos |> 
  select(num_range(prefix = "horario", 1:3)) # nessa base nao temos exemplo util
# pensar em um exemplo útil para essa função

# podemos renomear também
voos |> 
  select(
    tail_num = cauda
  )


# rename() ----------------

voos |> 
  rename(
    # nome_novo = nome_antigo
    tail_num = cauda,
    year = ano, 
    month = mes,
    day = dia
  )

# janitor::clean_names() ----
dados::dados_iris |> names()

# case sensitive

# no meu caso, primeiro uso o janitor, e depois o rename se necessário!

iris_nomes_arrumados <- dados::dados_iris |> 
  janitor::clean_names()

iris_nomes_arrumados |> names()

# ver duplicatas
janitor::get_dupes(voos, cauda) |> View()
# tabela de frequencia
janitor::tabyl(voos, mes)
# útil para testes estatísticos
janitor::tabyl(voos, destino, origem) |> 
  tibble::column_to_rownames("destino") |> 
  View()



# relocate --------------
voos |> 
  relocate(data_hora, .after = dia)


voos |> 
  relocate(ano:horario_saida, .after = data_hora) |> View()

voos |> 
  relocate(ano:horario_saida, .after = everything()) |> View()

voos |> 
  relocate(starts_with("horario"), .before = saida_programada) |> View()


# any_of(), all_of()


voos |> names()

vetor_voos <- c("voo", "cauda", "companhia_aerea")

voos |> 
  select(all_of(vetor_voos))

vetor_voos2 <- c("voo", "cauda", "companhia")

voos |> 
  select(any_of(vetor_voos2))

# %>% pipe do tidyverse 
## |> pipe nativo, pipe do R

# ctrl + shift + m 


# %>% %>% %>% %>% 
# |> |> |> |> |> |> |> |> |> |> |> |> |> |> 
