# Como criar um projeto? O que é um projeto?
# Vantagem: mais de uma sessão no R



# Como fazer e qual a importância de um comentário?
# Use comentários para explicar o porquê do seu código, não o como ou o o quê



# Diferença entre o script e o console


# Abrindo um novo script

## Recomendações de salvamento do script:
# Legíveis por máquinas (sem espaços, símbolos ou caracteres especiais)
# Legíveis por humanos (devem descrever o que contém)
# Devem ser ordenados conforme serão utilizados



# Não devemos salvar o .RData
# Tools -> Global options -> General
# É um bom padrão reiniciar o R e executar o código novamente para checar



# Instalando e carregando os pacotes
install.packages("dados")

library(dados)
library(tidyverse)

# Você nunca deve incluir install.packages() em um script que compartilha.
# É imprudente passar adiante um script que fará alterações no computador de
# alguém considerando que a pessoa pode não estar atenta ao que está fazendo.



# Rodando o código (ctrl + enter)
# Códigos encadeados rodam juntos
# O ctrl + enter também move o cursor para o código seguinte

library(dplyr)
library(dados)

nao_cancelado <- voos |> 
  filter(!is.na(atraso_saida), !is.na(atraso_chegada))

nao_cancelado |> 
  group_by(ano, mes, dia) |> 
  summarize(media = mean(atraso_saida))

# Para rodar todo o script, podemos usar ctrl + shift + s




# O R pode ser usado para cálculos básicos

1 / 200 * 30

(59 + 73 + 2) / 3

sin(pi / 2)




# Podemos criar novos objetos com o sinal de atribuição (<- ou "alt" + "-")

x <- 3*4

x * 5



# Podemos combinar vários elementos com um vetor c()...

primos <- c(2, 3, 5, 7, 11, 13)

# ... E realizar operações aritméticas com esse vetor

primos*2
primos-1




# Boas práticas na nomeação de objetos

# Snake-case
meu_objeto <- 5

# Camel-case
meuObjeto <- 5

# Separação por pontos
meu.objeto <- 5

# Rebeldes
meu.objeto_2Teste <- 5
`meu objeto` <- 5



# O autocomplete do RStudio

esse_e_um_nome_bem_longo <- 2.5



# Cuidado com erros de digitação

r_rainha <- 2^3

R_rainha
r_rainhas




# Problemas no código (leia o erro!)

x y <- 3

3 == NA

is.na(3)


# Frustração é normal!




# Entendendo funções

## O RStudio nos ajuda a entender os argumentos
rnorm()


?seq()


seq(from = 1, to = 10, by = 2)

seq(from = 1, to = 10)
seq(1, 10)




# Aspas

y <- "olá, mundo!"

## O que acontece quando esquecemos de fechar as aspas?




# Dentro de um projeto, use apenas caminhos relativos, não absolutos

library(dados)

ggplot(diamante, aes(x = quilate, y = preco)) +
  geom_hex()

ggsave("diamantes.png", width = 6, height = 5)
ggsave("figuras/diamantes.png", width = 6, height = 5)

write_csv(diamante, "dados/diamantes.csv")




# Exercícios - Capítulo 3 -------------------------------------------------

# 1. Por que esse código não funciona?
minha_variavel <- 10
minha_varıavel



# 2. Altere cada um dos seguintes comandos R para que eles sejam executados corretamente:

library(tidyverse)
library(dados)


ggplot(data = milhas,
       mapping = aes(x = cilindrada, y = rodovia)) +
  geom_point() +
  geom_smooth(method = "lm")






# 3. Pressione Option + Shift + K / Alt + Shift + K. O que acontece?
# Como você pode chegar ao mesmo lugar usando os menus?

## Help >> Keyboard shortcuts help





# 4. Vamos revisitar um exercício da Seção 1.6. Rode as seguintes linhas de código.
# Qual dos dois gráficos é salvo como mpg-plot.png? Por quê?

meu_grafico_de_barras <- ggplot(milhas, aes(x = classe)) +
  geom_bar()
meu_grafico_de_dispersao <- ggplot(milhas, aes(x = cidade, y = rodovia)) +
  geom_point()

ggsave(filename = "milhas-plot.png", plot = meu_grafico_de_barras,
       width = 5, height = 4, dpi = 600)

ggsave(filename = "milhas-plot.png", width = 5, height = 4, dpi = 600)


