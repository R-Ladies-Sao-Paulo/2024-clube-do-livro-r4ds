#### Clube do livro R4DS
### Cap 8. Fluxo de Trabalho: obtendo ajuda

## Pesquisando no Google:

# "como fazer um boxplot no R" != "como fazer um boxplot no R com ggplot2"

# google é bom com mensagens de erro
# comando para trocar idioma para inglês:

2 + x

Sys.setenv(LANGUAGE = "pt")

2 + x

## Pesquisando no StackOverflow: https://stackoverflow.com/
# incluir tags entre []

## Criar um reprex (reproducible example)

# Trabalhoso, mas: possivelmente você encontrará a resposta ou já terá pronto para perguntar
# Ajuda: pacote reprex

y <- 1:4
mean(y)

reprex::reprex() # formata em markdown para colar no StackOverflow ou Github
                 #usar ctrl+c depois rodar

install.packages("styler") # estava aparecendo um warning sobre esse pacote
library(styler)

# Necessário: a)tornar reprodutível; b)simplificar.

# a)tornar reprodutível: incluir pacotes, dados e código
# verificar utilização da versão atualizada dos pacotes. Para tidyverse:

library(tidyverse)
tidyverse_update()

old.packages <- old.packages() # outros pacotes (dica do chatgpt)

# incluir os dados

dput(mtcars) # Write an Object to a File or Recreate it

library(reprex)
reprex() # ctrl+c (no console) e depois rodar

# b)simplificar: usar dados "internos" (exemplos abaixo), inserir comentários,
# remover o que não é relacionado ao problema, testar em nova versão

library(dados)
pinguins
starwars
diamante
mtcars

## Indicações para acompanhar:
# Blog do Tidyverse: https://www.tidyverse.org/blog/
# R weekly: https://rweekly.org/
# Curso-R (lives sobre atualizações): https://www.instagram.com/p/C2un8OigwkJ/

### Cap 4. Fluxo de Trabalho: estilo de código

library(magick)
image_read("looks_andrea.gif")

## Guia de estilo tidyverse: https://style.tidyverse.org/
# é uma convenção de estilo de código
# facilita para outras pessoas lerem, para você mesmo no futuro e para pedir ajuda

## Ajuda: Pacote styler:

install.packages("styler")
library(styler)

# Paleta de comando do RStudio: ctrl/cmd + shift + P
#styler selection:

x <- ("estilo")

#style active file:

x<-( "estilo" )

##Para nomes:
#usar minúsculas e _

# Tente escrever assim:
voos_curtos <- voos |> filter(tempo_voo < 60)

# Evite escrever assim:
VOOSCURTOS <- voos |> filter(tempo_voo < 60)

##Sobre espaços:

#EXEMPLO 1
# Tente escrever assim:
z <- (a + b)^2 / d #espaços em ambos os lados dos operadores exceto ^ 

# Evite escrever assim:
z<-( a + b ) ^ 2/d #não coloque espaços dentro ou fora de parênteses 

#EXEMPLO 2
# Tente escrever assim:
mean(x, na.rm = TRUE) #vírgula: seguir regras de gramática (espaço depois da virgula)

# Evite escrever assim:
mean (x ,na.rm=TRUE) 

#EXEMPLO 3
#Tudo bem acrescentar espaços para alinhamento:
voos |> 
  mutate(
    velocidade     = distancia / tempo_voo,
    hora_saida     = horario_saida %/% 100,
    minuto_saida   = horario_saida %%  100
  ) 

##Sobre pipe |> ou %>% :
# sempre um espaço antes do pipe e ser sempre a última coisa da linha, exceção:
# quando cabe em uma linha. Ex:

df |> mutate(y = x + 1)

#deixar cada argumento em uma linha:

#EXEMPLO:
# Tente escrever assim:
voos |>  
  group_by(cauda) |> #recuo de 2 espaços
  summarize(         #código com mais de um argumento, recuar mais dois espaços
    atraso = mean(atraso_chegada, na.rm = TRUE),  
    n = n()
  )                 #fechamento de parentesis em uma linha "própria"

# Evite escrever assim:
voos |>
  group_by(
    cauda
  ) |> 
  summarize(atraso = mean(atraso_chegada, na.rm = TRUE), n = n())

#Não indica encademantos muito longos (com mais de 10, 15 linhas)

##Sobre ggplot2:
# seguir mesmo procedimento do pipe, mas pensando no +

voos |> 
  group_by(mes) |> 
  summarize(
    atraso = mean(atraso_chegada, na.rm = TRUE)
  ) |> 
  ggplot(aes(x = mes, y = atraso)) +
  geom_point() + 
  geom_line()

##Lembrete (já mencionado na apresentação anterior):
#comentários de seção: cmd/ctrl + shift + R 

##Exercício:
# 1) Aplicar o guia de estilo no código abaixo:

#Fazendo à mão:

voos |>
  filter(destino == "IAH") |>
  group_by(ano, mes, dia) |>
  summarize(n = n(), 
            atraso = mean(atraso_chegada, na.rm = TRUE)) |>
  filter(n > 10)

voos |>
  filter(companhia_aerea == "UA", 
         destino %in% c("IAH","HOU"),
         saida_programada > 0900,
         chegada_prevista < 2000) |>
  group_by(voo) |>
  summarize(atraso = mean(atraso_chegada, na.rm = TRUE), 
            cancelado = sum(is.na(atraso_chegada)),
            n = n()) |>
  filter(n > 10)


#Styler:

voos |>
  filter(destino == "IAH") |>
  group_by(ano, mes, dia) |>
  summarize(
    n = n(),
    atraso = mean(atraso_chegada, na.rm = TRUE)
  ) |>
  filter(n > 10)

voos |>
  filter(companhia_aerea == "UA", 
         destino %in% c("IAH", "HOU"), 
         saida_programada > 0900, 
         chegada_prevista < 2000) |>
  group_by(voo) |>
  summarize(atraso = mean(atraso_chegada, na.rm = TRUE), 
    cancelado = sum(is.na(atraso_chegada)), 
    n = n()) |>
  filter(n > 10)

#outra forma: atalho (ctrl + shift + A)


voos |> filter(destino == "IAH") |> group_by(ano, mes, dia) |> summarize(n =
                                                                           n(),
                                                                         atraso =
                                                                           mean(atraso_chegada, na.rm = TRUE)) |> filter(n > 10)

voos |> filter(
  companhia_aerea == "UA",
  destino %in% c("IAH", "HOU"),
  saida_programada >
    0900,
  chegada_prevista < 2000
) |> group_by(voo) |> summarize(
  atraso = mean(atraso_chegada, na.rm = TRUE),
  cancelado = sum(is.na(atraso_chegada)),
  n = n()
) |> filter(n > 10)


