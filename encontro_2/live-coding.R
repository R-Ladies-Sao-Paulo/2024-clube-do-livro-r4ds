# Carregando os pacotes
library(dados)
library(tidyverse)

# Versão original
palmerpenguins::penguins

# Versão traduzida
pinguins

# Conhecendo as variáveis
glimpse(pinguins)


# Primeiro gráfico---------------------- ----
# Primeiro gráfico que vamos ver!
# Queremos criar um gráfico de dispersão
# (gráfico de pontos), apresentando
# dados dos pinguins.
# Na variável x queremos apresentar valores de
# comprimento da nadadeira, e na y queremos
# mostrar a massa corporal.

# Apenas os dados: um canva vazio!
ggplot(data = pinguins)


# Dados e variáveis dos eixos x e y
ggplot(data = pinguins,
       mapping = aes(x = comprimento_nadadeira, y = massa_corporal))

# Dados, variáveis mapeadas, e geometria de pontos
ggplot(data = pinguins,
       mapping = aes(x = comprimento_nadadeira, y = massa_corporal)) +
  geom_point()

# Exercício 8 ---------------------------

ggplot(data = pinguins,
       aes(x = comprimento_nadadeira, y = massa_corporal)) +
  geom_point()

# Queremos colorir os pontos 
# usando uma terceira variável: 
# profundidade do bico.

# Opção 1: aes() dentro da função ggplot
# configuramos de forma "global"
ggplot(data = pinguins,
       aes(x = comprimento_nadadeira,
           y = massa_corporal,
           color = profundidade_bico)) +
  geom_point()

# Opção 2: aes() fora!
# Gera o mesmo resultado da opção 1.
# Forma preferida da Bia pois deixa o código 
# mais simples:
ggplot(data = pinguins) +
  aes(x = comprimento_nadadeira, y = massa_corporal) +
  geom_point(aes(color = profundidade_bico))


# Opção 3: aes() dentro da geometria
# o aes() será usado apenas nessa geometria.
# como só usamos uma geometria nesse gráfico,
# dá na mesma.
ggplot(data = pinguins,
       aes(x = comprimento_nadadeira, y = massa_corporal)) +
  geom_point(aes(color = profundidade_bico))


# Importante:
# fill e o color geram confusão!
# fill = preenchimento.
# color = bordas! geom_point e geom_line usa só o color

# Importante 2:
# Sempre que formos usar uma variável para mapear algum
# atributo no gráfico, precisamos colocar dentro do aes()


# Exemplos de color e fill ------

# Gráfico de barras simples
ggplot(pinguins,
       aes(x = especie)) +
  geom_bar()



# Colorindo as bordas das barras: color
ggplot(pinguins,
       aes(x = especie)) +
  geom_bar(color = "red")


ggplot(pinguins,
       aes(x = especie)) +
  # podemos usar cores hex
  geom_bar(color = "#0000dd")


# Colorindo as barras: fill
ggplot(pinguins,
       aes(x = especie)) +
  geom_bar(fill = "#0000dd")


# Como podemos colorir segundo alguma
# variável?
# fill ou color DENTRO do aes()

ggplot(pinguins,
       aes(x = especie, fill = especie)) +
  geom_bar()

# outra forma de escrever:
ggplot(pinguins,
       aes(x = especie)) +
  geom_bar(aes(fill = especie))


# Escondendo a legenda que está redundante:
ggplot(pinguins,
       aes(x = especie)) +
  geom_bar(aes(fill = especie), show.legend = FALSE)


# E escalas de cores?
# viridis é uma opção, mas tem outras!
# as funções de escala seguem o padrão
# scale_fill_....() - para preenchimento
# scale_color_...() - para borda/ponto/linha
ggplot(pinguins,
       aes(x = especie)) +
  geom_bar(aes(fill = especie)) +
  scale_fill_viridis_d()
  

# definindo cores manualmente
ggplot(pinguins,
       aes(x = especie)) +
  geom_bar(aes(fill = especie)) +
  scale_fill_manual(values = c("blue", "red", "green"))

# Cuidados---------------------------

# Cuidado ao executar códigos que tem um
# + ao final, sem nada depois.
# Isso sinaliza o R que você ainda está escrevendo.
# A tecla ESC ajuda a sair dessa situação!

# Ex que gera erro!
# ggplot(pinguins) +


# Erro: o + não está no final da linha
ggplot(pinguins)
+ geom_bar(aes(x = especie))
# ℹ Did you accidentally put `+` on a new line?

# Funciona:
ggplot(pinguins) +
  geom_bar(aes(x = especie))
