# Pré-requisitos -----
library(tidyverse)
library(dados)
# install.packages("dados")
# https://ipeagit.github.io/flightsbr/


# Introdução 
c(1, 2, 3, 4, 5)

x <- c(1, 2, 3, 4, 5, 6)
1:6

x * 2

df <- tibble(x)

df |> 
  mutate(y = x * 2)

class(x)

class(c(TRUE, FALSE, NA))

# Comparações -----

x > 3

voos |> View()

nrow(voos)

voos |> 
  filter(atraso_chegada > 60) |> View()

voos |> 
  mutate(atraso_maior_1h = atraso_chegada > 60,
        # .keep = "used"
         ) |>
  filter(atraso_maior_1h == TRUE) |> 
  View()

# Comparação com ponto flutuante

um <- (1/49) * 49

um == 1

print(um, digits = 16)

near(um, 1) # é mais seguro que o == para comparar números com casas decimais


dois <- sqrt(2) ^ 2
print(dois, digits = 20)

dois == 2

near(dois, 2)
 
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


voos |> 
  filter(horario_saida == NA)

# is.na()

is.na(c(1, NA, 3))

voos |> 
  filter(is.na(horario_saida))


!is.na(c(1, NA, 3))

voos |> 
  filter(!is.na(horario_saida)) 

voos |> 
  drop_na(horario_saida)

# álgebra booleana
# 3 operadores
# & (e)
# | (ou)
# ! (not/não)

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


# %in%

# não faça assim!
# voos |> 
#   filter(mes == 11 | 12)

voos |> 
  filter(mes == 11 | mes == 12)

# voos |> 
#   filter(
#     -20 =< atraso_chegada =< 20
#   )
  

voos |> 
  select(atraso_chegada) |> 
  filter(
    -20 <= atraso_chegada,
    atraso_chegada <= 20
  ) 

voos |> 
  filter(
    mes %in% c(10, 11, 12, 1)
  )


sorteio_destino <- voos |> 
  distinct(destino) |> 
  pull(destino) |> 
  sample(5)

voos |> 
  filter(destino %in% sorteio_destino) |> View()



letters[1:10] %in% c("a", "e", "i", "o", "u")


# transformações condicionais --------

# if() {
#   
# } else if(){
#   
# } else {
#   
# }

# if_else dplyr

# se o voo atrasou mais que 300 min, vamos considerar que atrasou muito!!

voos_ifelse <- voos |> 
  mutate(atrasou_muito = if_else(
    condition = atraso_chegada > 300,
    true = "Sim",
    false = "Não"
    ))

voos_ifelse |> 
  ggplot() +
  geom_histogram(aes(atraso_chegada, fill = atrasou_muito))


voos_case_when <- voos |> 
  mutate(
    status_atraso = case_when(
      is.na(atraso_chegada)  ~ "cancelado",
      atraso_chegada < -30 ~ "muito antecipado",
      atraso_chegada < -15 ~ "antecipado",
      abs(atraso_chegada) <= 15 ~ "no horario",
      atraso_chegada < 60 ~ "atrasado",
      atraso_chegada >= 60 ~ "muito atrasado",
      .default = "CATEGORIZAR"
    ),
    status_atraso_fct = forcats::fct_relevel(
      status_atraso, c("cancelado", "muito antecipado",
                       "antecipado", "no horario", 
                       "atrasado", "muito atrasado")
    ),
    .keep = "used"
  )


voos_case_when |> 
  ggplot() +
  geom_histogram(aes(x = atraso_chegada, fill = status_atraso_fct), binwidth = 1)




