# Capítulo: Vetores lógicos
# https://pt.r4ds.hadley.nz/logicals.html

## Pré-requisitos -------------

library(tidyverse)
library(dados)
# install.packages("dados")
# https://ipeagit.github.io/flightsbr/


# Introdução
# Vetores - São conjuntos de dados do mesmo tipo
# e só tem uma dimensão
c(1, 2, 3, 4, 5)

# Os vetores são muito importantes quando trabalhamos com tabelas
# pois cada coluna da tabela é um vetor
x <- c(1, 2, 3, 4, 5, 6)
1:6

x * 2

df <- tibble(x)

df |>
  mutate(y = x * 2)
# Os vetores podem ter diferentes classes
class(x)




# Vetores lógicos - é a forma mais simples dos vetores
# TRUE, FALSE, NA
# TRUE - Verdadeiro
# FALSE - Falso
# NA - Not available/valor faltante

class(c(TRUE, FALSE, NA))

# Por mais que o livro seja focado no tidyverse,
# esse capítulo é mais voltado para o R base
# Vamos encontrar algumas funções interessantes do dplyr também!

# Comparações ---------
# Vetores lógicos são muito úteis para fazer comparações lógicas

x > 3

voos |> View()

nrow(voos)

# voos que chegaram pelo menos 1h atrasado
voos |>
  filter(atraso_chegada > 60) |>
  View()

# o que está acontecendo internamente?
voos |>
  mutate(atraso_maior_1h = atraso_chegada > 60, .keep = "used") |>
  filter(atraso_maior_1h == TRUE) |>
  View()

# a comparação lógica gera um vetor lógico
# ou seja, um vetor com TRUE e FALSE
# e o filter mantém apenas os TRUE


## Comparação com ponto-flutuante (float) ----
um <- (1 / 49) * 49

um == 1

print(um, digits = 16)

near(um, 1) # é mais seguro que o == para comparar números com casas decimais


dois <- sqrt(2)^2
print(dois, digits = 20)

dois == 2

near(dois, 2)

# a função near tem uma tolerância para comparar (e é um argumento que pode ser alterado)
# conferir na documentação: ?near()

# Comentário Luana: round() também pode ser útil
round(dois) == 2

# Valores faltantes (NA) ------------

NA > 5

10 == NA

NA == NA


idade_bia <- 32
idade_lu <- NA

idade_lu == idade_bia

idade_ale <- NA


idade_lu == idade_ale

# não podemos usar == NA no filter, não dá certo
voos |>
  filter(horario_saida == NA)

# is.na() --------

# is.na() retorna um vetor lógico
# verificando se cada valor é um NA
is.na(c(1, NA, 3))

# filtrar apenas linhas onde horario_saida é NA
# ou seja, onde o voo não saiu
voos |>
  filter(is.na(horario_saida))

# o ! indica a negação: quais NÃO SÃO NA?!is.na(c(1, NA, 3))

# filtrar apenas linhas onde horario_saida não é NA
voos |>
  filter(!is.na(horario_saida))

# função equivalente: drop_na() remove linhas com NA nas colunas indicadas
voos |>
  drop_na(horario_saida)

## Álgebra booleana ---------

# Os operadores importantes são:
# & (e),
# | (ou),
# ! (não)

# e: , ou &
voos |>
  select(atraso_saida, atraso_chegada, origem, destino) |>
  filter(atraso_chegada > 60, origem == "JFK")


# OU
voos |>
  select(atraso_saida, atraso_chegada, origem, destino) |>
  filter(atraso_chegada > 60 | origem == "JFK")

voos |>
  select(atraso_saida, atraso_chegada, origem, destino) |>
  filter(!origem == "JFK")



# Existe o xor, mas não é muito utilizado

# O R também tem o && e ||, mas não devemos usar no contexto de ciência de dados: eles retornam apenas um TRUE ou FALSE.



# %in% -------------------------

# Exemplo: voos que aconteceram em novembro OU dezembro
# não faça assim!
# voos |>
#   filter(mes == 11 | 12)

voos |>
  filter(mes == 11 | mes == 12)

# Exemplo: voos com atraso de chegada entre -20 e 20 minutos
# isso não funciona!!
# voos |>
#   filter(
#     -20 =< atraso_chegada =< 20
#   )


voos |>
  select(atraso_chegada) |>
  filter(-20 <= atraso_chegada, atraso_chegada <= 20)

# O %in% é um operador que verifica se os elementos de um vetor estão contidos em outro vetor
1:12 %in% c(1, 5, 11)

letters[1:10] %in% c("a", "e", "i", "o", "u")

# Exemplo: filtrar voos entre outubro e janeiro
voos |>
  filter(mes %in% c(10, 11, 12, 1))

# também podemos usar um vetor criado anteriormente para
# filtrar
sorteio_destino <- voos |>
  distinct(destino) |>
  pull(destino) |>
  sample(5)

voos |>
  filter(destino %in% sorteio_destino) |>
  View()


# transformações condicionais --------

# if() {
#
# } else if(){
#
# } else {
#
# }

# if_else (dplyr) -----------------------

# se o voo atrasou mais que 300 min, vamos considerar que atrasou muito!!

# Criar uma nova coluna: atrasou muito.
# se atraso_chegada for maior que 300 minutos,
# salvar "Sim" na nova coluna
# se não, salvar "Não" na nova coluna
voos_ifelse <- voos |>
  mutate(atrasou_muito = if_else(
    condition = atraso_chegada > 300,
    true = "Sim",
    false = "Não"
  ))

voos_ifelse |>
  ggplot() +
  geom_histogram(aes(atraso_chegada, fill = atrasou_muito))

# case_when --------------------------------


# o if_else() só permite duas condições
# já o case_when() permite várias condições

# Podemos usar o case_when para criar uma nova coluna
# com várias verificações.
# Cuidado com a ordem das verificações, pois o case_when
# vai parar de verificar assim que encontrar a primeira
# condição verdadeira.

# Exemplo: criar uma nova coluna com o status do atraso
# se o atraso for maior que 60 minutos, status = "muito atrasado"
# se o atraso for menor que 60 minutos e maior que 15, status = "atrasado"
# se o atraso for menor que 15 minutos e maior que -15, status = "no horario"
# se o atraso for menor que -15 minutos e maior que -30, status = "antecipado"
# se o atraso for menor que -30 minutos, status = "muito antecipado"
# se o atraso for NA, status = "cancelado"
# o argumento .default é o que acontece se nenhuma das condições for verdadeira

voos_case_when <- voos |>
  mutate(
    status_atraso = case_when(
      is.na(atraso_chegada) ~ "cancelado",
      atraso_chegada < -30 ~ "muito antecipado",
      atraso_chegada < -15 ~ "antecipado",
      abs(atraso_chegada) <= 15 ~ "no horario",
      atraso_chegada < 60 ~ "atrasado",
      atraso_chegada >= 60 ~ "muito atrasado",
      .default = "CATEGORIZAR"
    ),
    .keep = "used"
  )


voos_case_when |>
  ggplot() +
  geom_histogram(aes(x = atraso_chegada, fill = status_atraso), binwidth = 1)


# arrumando os fatores
voos_case_when2 <- voos_case_when |>
  mutate(status_atraso_fct = forcats::fct_relevel(
    status_atraso,
    c(
      "cancelado",
      "muito antecipado",
      "antecipado",
      "no horario",
      "atrasado",
      "muito atrasado"
    )
  ))

voos_case_when2 |>
  ggplot() +
  geom_histogram(aes(x = atraso_chegada, fill = status_atraso_fct), binwidth = 1)
