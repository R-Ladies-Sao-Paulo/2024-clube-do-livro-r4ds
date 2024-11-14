
# Instalação e carregamento dos pacotes -----------------------------------

# install.packages("tidyverse")
library(tidyverse)

# install.packages("dados")
library(dados)




# A base de dados ---------------------------------------------------------

milhas |> View()

# cilindrada: tamanho do motor (litros)
# rodovia: eficiência de combustível
# classe: tipo de carro




# Atributos color, shape, size e alpha ------------------------------------


ggplot(data = milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point()


## Mapeando a categórica em color
ggplot(data = milhas, aes(x = cilindrada, y = rodovia, color = classe)) +
  geom_point()


## Mapeando a categórica em shape
ggplot(data = milhas, aes(x = cilindrada, y = rodovia, shape = classe)) +
  geom_point()
# Por que dá esse warning?


## Mapeando a categórica em size
ggplot(data = milhas, aes(x = cilindrada, y = rodovia, size = classe)) +
  geom_point()
# Por que dá esse warning? (nominal x ordinal)


## Mapeando a categórica em alpha
ggplot(data = milhas, aes(x = cilindrada, y = rodovia, alpha = classe)) +
  geom_point()
# Por que dá esse warning? (nominal x ordinal)


# Quando selecionamos o atributo estético, o ggplot2 cuida do resto
# Escalas dos eixos, tamanhos, legendas, etc.


# A diferença entre mexer nesses atributos dentro ou fora do aes

ggplot(data = milhas, aes(x = cilindrada, y = rodovia, color = classe)) +
  geom_point()


# ggplot(data = milhas, aes(x = cilindrada, y = rodovia, color = classe)) +
#   geom_point() +
#   scale_color_manual(values = c("red", "blue", "orange", "pink", "darkgreen",
#                                 "cadetblue", "darkred"))


ggplot(data = milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point(color = "blue")


ggplot(data = milhas) +
  geom_point(aes(x = cilindrada, y = rodovia), color = "blue")




ggplot(data = milhas, aes(x = cilindrada, y = rodovia, shape = classe)) +
  geom_point()


ggplot(data = milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point(shape = 2)
# Ver slide


ggplot(data = milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point(size = 2)


ggplot(data = milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point(alpha = 0.2)



# Exercícios (color, shape, size, alpha) ----------------------------------

# 2. Por que o código abaixo não resultou em um gráfico com pontos em azul?
ggplot(milhas) + 
  geom_point(aes(x = cilindrada, y = rodovia, color = "blue"))

# 4. O que acontece se você mapear um atributo estético para algo que não seja
# o nome de uma variável, como aes(color = cilindrada < 5)? Observe que
# você também precisará definir os atributos estéticos x e y.

ggplot(milhas) + 
  geom_point(aes(x = cilindrada, y = rodovia, color = cilindrada < 5))




# Entendendo as geometrias ------------------------------------------------

ggplot(data = milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point()

ggplot(data = milhas, aes(x = cilindrada, y = rodovia)) +
  geom_smooth()



# Cada geometria tem os atributos que funcionam para ela

ggplot(data = milhas, aes(x = cilindrada, y = rodovia, shape = tracao)) +
  geom_smooth()

ggplot(data = milhas, aes(x = cilindrada, y = rodovia, linetype = tracao)) +
  geom_smooth()

ggplot(data = milhas, aes(x = cilindrada, y = rodovia, color = tracao)) +
  geom_smooth()


ggplot(data = milhas, aes(x = cilindrada, y = rodovia, color = tracao)) +
  geom_smooth() +
  geom_point()


ggplot(data = milhas, aes(x = cilindrada, y = rodovia, color = tracao)) +
  geom_smooth() +
  geom_point()


# Diferença entre group e um atributo estético (como linetype)

ggplot(data = milhas, aes(x = cilindrada, y = rodovia)) +
  geom_smooth()

ggplot(data = milhas, aes(x = cilindrada, y = rodovia, group = tracao)) +
  geom_smooth()

ggplot(data = milhas, aes(x = cilindrada, y = rodovia, color = tracao)) +
  geom_smooth()

ggplot(data = milhas, aes(x = cilindrada, y = rodovia, color = tracao)) +
  geom_smooth(show.legend = F)


ggplot(data = milhas, aes(x = tracao, fill = tracao)) +
  geom_bar(show.legend = F)
# Storytelling com dados


# Mapeamento na camada global x local

ggplot(data = milhas, aes(x = cilindrada, y = rodovia, color = tracao)) +
  geom_smooth() +
  geom_point()


ggplot(data = milhas, aes(x = cilindrada, y = rodovia)) +
  geom_smooth() +
  geom_point(aes(color = tracao))


ggplot(data = milhas, aes(x = cilindrada, y = rodovia)) +
  geom_smooth(aes(color = tracao)) +
  geom_point()


ggplot(data = milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point() +
  geom_smooth(aes(color = tracao))


# Podemos usar bases (datasets) diferentes em cada camada

milhas |> filter(classe == "2 assentos") |> View()


ggplot(data = milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point() +
  geom_point(data = milhas |> filter(classe == "2 assentos"),
             color = "red") +
  geom_point(data = milhas |> filter(classe == "2 assentos"),
             color = "red", shape = 1, size = 3)



# Algumas possibilidades de geometria

ggplot(data = milhas, aes(x = rodovia)) +
  geom_histogram(fill = "white", color = "grey50")

ggplot(data = milhas, aes(x = rodovia)) +
  geom_density()

ggplot(data = milhas, aes(x = rodovia)) +
  geom_boxplot(outlier.shape = 1)



# Há geometrias em pacotes que expandem as funcionalidades do ggplot2

# install.packages("ggridges")
library(ggridges)

ggplot(milhas, aes(x = rodovia, y = tracao,
                   fill = tracao, color = tracao)) +
  geom_density_ridges(alpha = 0.5, show.legend = FALSE)




# Exercícios (geometrias) -------------------------------------------------

# 2. Anteriormente nesse capítulo nós utilizamos o argumento show.legend sem explicá-lo:
  
ggplot(milhas, aes(x = cilindrada, y = rodovia)) +
  geom_smooth(aes(color = tracao), show.legend = FALSE)

# O que o argumento `show.legend = FALSE` faz nesse gráfico?
# O que acontece se você o remove?
# Por que você acha que o utilizamos anteriomente?

# 3. O que o argumento se da geometria geom_smooth() faz?

ggplot(milhas, aes(x = cilindrada, y = rodovia)) +
  geom_smooth(aes(color = tracao, fill = tracao), se = T, alpha = 0.2)

  
# 4. Recrie o código em R necessário para gerar os gráficos abaixo.
# Observe que sempre que uma variável categórica é utilizada no gráfico,
# trata-se da variável tracao.
# Ver slide.

ggplot(data = milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point() +
  geom_smooth(se = F)


ggplot(data = milhas, aes(x = cilindrada, y = rodovia, group = tracao)) +
  geom_smooth(se = F) +
  geom_point()


ggplot(data = milhas, aes(x = cilindrada, y = rodovia, color = tracao)) +
  geom_smooth(se = F) +
  geom_point()


ggplot(data = milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point(aes(color = tracao)) +
  geom_smooth(se = F)


ggplot(data = milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point(aes(color = tracao)) +
  geom_smooth(se = F, aes(linetype = tracao))


ggplot(data = milhas, aes(x = cilindrada, y = rodovia, linetype = tracao)) +
  geom_point(aes(color = tracao)) +
  geom_smooth(se = F)


ggplot(data = milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point(aes(fill = tracao), shape = 21, color = "white",
             size = 2, stroke = 2)


ggplot(data = milhas, aes(x = cilindrada, y = rodovia, linetype = tracao)) +
  geom_point(size = 4, color = "white") +
  geom_point(aes(color = tracao))

