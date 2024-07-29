library(tidyverse)
library(dados)
# Se quiser a versão mais recente, instalar via
# GitHub:
# remotes::install_github("cienciadedatos/dados")

voos <- voos

# group_by ---------------

# altera o comportamento das funções após o group_by()
# o número de grupos representa o número de categorias distintas
voos |> 
  group_by(companhia_aerea)

voos |> 
  group_by(ano, mes, dia) # 365 grupos!

# summarize() -------------------

# summarize sem group_by faz um resumo usando todas as linhas da base!
voos |> 
  summarize(
    atraso_medio = mean(atraso_saida, na.rm = TRUE)
  )

mean(voos$atraso_saida, na.rm = TRUE)

# summarize sem group_by não parece tão útil


# summarize com grupo: 1 variável -------------------

voos |> 
  group_by(mes) |> 
  summarise(
    quantidade_voos = n(),
    atraso_medio = mean(atraso_saida, na.rm = TRUE)
  )

# summarize com grupo: mais de 1 variável ------------
voos |> 
  distinct(mes, dia) |> View()


voos |> 
  group_by(mes, dia) |> 
  summarise(
    quantidade_voos = n(),
    atraso_medio = mean(atraso_saida, na.rm = TRUE)
  ) |> view()

# `summarise()` has grouped output by 'mes'. You can override using the `.groups`
# argument.

voos |> 
  group_by(mes, dia) |> 
  summarise(
    quantidade_voos = n(),
    atraso_medio = mean(atraso_saida, na.rm = TRUE), 
    .groups = "keep"
  ) 

# argumento .groups = 
# "keep" mantém grupos originais
# "drop" descarta agrupamento
# "drop_last" é o padrão, descarta o último agrupamento
# "rowwise" cada linha vira um grupo por si só.

voos |> 
  group_by(mes, dia) |> 
  summarise(
    quantidade_voos = n(),
    atraso_medio = mean(atraso_saida, na.rm = TRUE)
  ) |> 
  ungroup() # dá para usar também o argumento .groups = "drop" no summarize

# Dúvida: Pq desagrupar? exemplo! -----
# o resultado sem ungroup e com ungroup pode ser diferente!

voos |> 
  group_by(mes, dia) |> 
  summarise(
    quantidade_voos = n(),
    atraso_medio = mean(atraso_saida, na.rm = TRUE)
  ) |> 
  filter(atraso_medio == max(atraso_medio))

voos |> 
  group_by(mes, dia) |> 
  summarise(
    quantidade_voos = n(),
    atraso_medio = mean(atraso_saida, na.rm = TRUE)
  ) |> 
  ungroup() |> 
  filter(atraso_medio == max(atraso_medio))

# e se salvar, o resultado continua agrupado?
# sim!!
voos_atraso_agrupado <- voos |> 
  group_by(mes, dia) |> 
  summarise(
    quantidade_voos = n(),
    atraso_medio = mean(atraso_saida, na.rm = TRUE)
  )
voos_atraso_agrupado


# .by() do summarise ---------------------------------------

voos |> 
  summarise(
    quantidade_voos = n(),
    .by = mes # forma de passar o grupo direto no summarise
  )

voos |> 
  summarise(
    quantidade_voos = n(),
    .by = c(mes, dia) # forma de passar o grupo direto no summarise
  )
  

# exemplos de funções úteis do summarise
voos |>
  group_by(companhia_aerea) |>
  summarise(
    quantidade_voos = n(),
    atraso_medio = mean(atraso_saida, na.rm = TRUE),
    # sd, var, ...
    quantidade_origem = n_distinct(origem),
    quantidade_destino = n_distinct(destino),
    atendimento_origem = paste0(unique(origem), collapse = ", "),
    atendimento_destino = knitr::combine_words(unique(destino),
                                               and = " e ",
                                               oxford_comma = FALSE)
  ) |> View()



# Dúvida: Qual é a diferença entre count() e n()? ----
# n() quantas linhas tem em um grupo
# count() tabelas de frequência
voos |> 
  count(companhia_aerea, sort = TRUE)

voos |> 
  group_by(companhia_aerea) |> 
  summarise(
     quantidade = n()
  ) |> 
  arrange(desc(quantidade))

# não conseguimos usar o n() fora dos verbos do dplyr
voos |> 
  dplyr::n()

# e não conseguimos usar o count() dentro do summarise()

voos |> 
  group_by(companhia_aerea) |> 
  summarise(contagem = count())

# Slice -------------------------------------

voos |> 
  slice_head(n = 5) # head() do r base

voos |> 
  slice_tail(n = 5) # tail() do r base

voos |> 
  slice_sample(n = 1) # sortear 1 voo na base!

voos |> 
  slice_sample(prop = 0.1) # sortear 10% das linhas da base

# qual voo saiu mais atrasado naquele ano?
voos |> 
  slice_max(order_by = atraso_saida, n = 1)

# qual voo saiu mais adiantado naquele ano?
voos |> 
  slice_min(order_by = atraso_saida, n = 1)

# slice() + group_by()
voos |> 
  group_by(companhia_aerea) |> 
  slice_max(order_by = atraso_saida, n = 1) |> View()

# slice()
atraso_por_destino <- voos |> 
  group_by(destino) |>  # 105 grupos
  slice_max(atraso_chegada, n = 1) |>  # 108 linhas!
  relocate(destino, atraso_chegada, .before = 1) |> 
  ungroup()

# EXPLORANDO os empates
janitor::get_dupes(atraso_por_destino, destino)  

# empatou! como não ter empate?
voos |> 
  group_by(destino) |>  # 105 grupos
  slice_max(atraso_chegada, n = 1, with_ties = FALSE)

# Exercícios
# 1) Qual companhia aérea (companhia_aerea) possui a pior média de atrasos? 

voos |> 
  group_by(companhia_aerea) |> 
  summarise(
    media_atraso = mean(atraso_saida, na.rm = TRUE), 
    quantidade_voos = n()
  ) |> 
  arrange(desc(media_atraso))

# Desafio: você consegue desvendar os efeitos de aeroportos ruins versus
# companhias aéreas ruins? Por que sim ou por que não?
# (Dica: experimente usar 
# voos |> group_by(companhia_aerea, destino) |> summarize(n()))


voos |> 
  group_by(companhia_aerea, destino) |>
  summarise(
    media_atraso = mean(atraso_saida, na.rm = TRUE), 
    quantidade_voos = n()
  ) |> 
  arrange(desc(media_atraso)) |> View()


# 2) Ache os vôos que estão mais atrasados no momento da decolagem,
# a partir de cada destino.

voos |> 
  group_by(destino) |> 
  slice_max(order_by = atraso_saida, n = 5) |> View()


# 3) Como os atrasos variam ao longo do dia. Ilustre sua resposta com um gráfico.

voos |>
  group_by(hora) |>
  summarise(
    quantidade = n(),
    media_atraso = mean(atraso_saida, na.rm = TRUE),
    min_atraso = min(atraso_saida, na.rm = TRUE),
    max_atraso = max(atraso_saida, na.rm = TRUE)
  ) |>
  ggplot() +
  aes(x = hora, y = media_atraso) +
  geom_smooth() +
  scale_x_continuous(breaks = c(1:24))

