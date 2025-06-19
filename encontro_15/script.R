#### Introdução ####

##### Pré-requisitos ####
library(tidyverse)
library(scales)
library(ggrepel)
library(patchwork)
library(dados)

#### Transformar um gráfico exploratório em um gráfico expositivo

#### 1. Rótulos #### 

##### labs() #####
#### Rotular os principais componentes do gráfico

# Base de dados
milhas |> View()

# Gráfico exploratório
ggplot(milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point(aes(color = classe)) +
  geom_smooth(se = FALSE) 

# Gráfico expositivo
ggplot(milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point(aes(color = classe)) +
  geom_smooth(se = FALSE) +
  labs(
    x = "Cilindrada do Motor (L)",
    y = "Economia de combustível na rodovia (mpg)",
    color = "Tipo de veículo",
    title = "Eficiência de combustível geralmente diminui com o tamanho do motor",
    subtitle = "Dois lugares (carros esportivos) são uma exceção devido ao seu peso leve",
    caption = "Dados de fueleconomy.gov"
  )

#### 2. Anotações ####

#### Rotular observações individuais ou grupos de observações

##### geom_text() #####

# Segregação por tração
ggplot(milhas, aes(x = cilindrada, y = rodovia, color = tracao)) +
  geom_point(alpha = 0.3) +
  geom_smooth(se = FALSE)

# Cria tabela com os rótulos de tração
rotulos_info <- milhas |>
  group_by(tracao) |>
  arrange(desc(cilindrada)) |>
  slice_head(n = 1) |>
  mutate(
    tipo_tracao = case_when(
      tracao == "d" ~ "tração dianteira",
      tracao == "t" ~ "tração traseira",
      tracao == "4" ~ "4x4"
    )
  ) |>
  select(cilindrada, rodovia, cilindrada, tipo_tracao)

rotulos_info |> View()

# Insere rótulos de tração
ggplot(milhas, aes(x = cilindrada, y = rodovia, color = tracao)) +
  geom_point(alpha = 0.3) +
  geom_smooth(se = FALSE) +
  geom_text(
    data = rotulos_info, 
    aes(x = cilindrada, y = rodovia, label = tipo_tracao),
    fontface = "bold", size = 5, hjust = "right", vjust = "bottom"
  ) +
  theme(legend.position = "none")

##### ggrepel::geom_label_repel() #####

# Insere rótulos de tração (ggrepel)
ggplot(milhas, aes(x = cilindrada, y = rodovia, color = tracao)) +
  geom_point(alpha = 0.3) +
  geom_smooth(se = FALSE) +
  geom_label_repel(
    data = rotulos_info, 
    aes(x = cilindrada, y = rodovia, label = tipo_tracao),
    fontface = "bold", size = 5, nudge_y = 2
  ) +
  theme(legend.position = "none")

##### geom_point() #####

# Cria tabela com os rótulos dos potenciais pontos discrepantes
potenciais_discrepantes <- milhas |>
  filter(rodovia > 40 | (rodovia > 20 & cilindrada > 5))

potenciais_discrepantes |> View()

# Gráfico expositivo
ggplot(milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point() +
  geom_text_repel(data = potenciais_discrepantes, aes(label = modelo)) +
  geom_point(data = potenciais_discrepantes, color = "red") +
  geom_point(
    data = potenciais_discrepantes,
    color = "red", size = 3, shape = "circle open"
  )

##### annotate() #####

tendencia_texto <- "Motores com maiores cilindradas tendem a ter menor eficiência de combustível." |>
  str_wrap(width = 30)
tendencia_texto

ggplot(milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point() +
  annotate(
    geom = "label", x = 3.5, y = 38,
    label = tendencia_texto,
    hjust = "left", color = "red"
  ) +
  annotate(
    geom = "segment",
    x = 3, y = 35, xend = 5, yend = 25, color = "red",
    arrow = arrow(type = "closed")
  ) +
  # Extra
  annotate(
    geom = "rect", xmin = 5.5, xmax = 7.2, ymin = 22, ymax = 28,
    alpha = 0.2, color = "blue"
  ) +
  annotate(
    geom = "text", x = 5.8, y = 29,
    label = "corvette", color = "blue"
  )

#### 3. Escalas ####

#### As escalas controlam como os mapeamentos estéticos se manifestam visualmente.
#### Especificam a forma de interpretação dos valores (ex: variáveis categóricas podem ser representadas por cores, desenhos, etc)

##### Escalas padrão #####

# Todos os argumentos dentro de aes() possuem uma escala por default

# Variável categórica: cores discretas por default
ggplot(milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point(aes(color = classe))

ggplot(milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point(aes(color = classe)) +
  scale_x_continuous() +
  scale_y_continuous() +
  scale_color_discrete()

##### Marcações de eixo e chaves da legenda #####

###### breaks e labels ######

# Eixo Y - Quebras
ggplot(milhas, aes(x = cilindrada, y = rodovia, color = tracao)) +
  geom_point() +
  scale_y_continuous(breaks = seq(15, 40, by = 5)) 

# Eixos e legenda
ggplot(milhas, aes(x = cilindrada, y = rodovia, color = tracao)) +
  geom_point() +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = NULL) +
  scale_color_discrete(labels = c("4" = "4x4", "d" = "dianteira", "t" = "traseira")) ###

# Formatação do número
ggplot(diamante, aes(x = preco, y = corte)) +
  geom_boxplot(alpha = 0.05) +
  scale_x_continuous(labels = label_dollar())

# Eixo X - Valor em 1000
ggplot(diamante, aes(x = preco, y = corte)) +
  geom_boxplot(alpha = 0.05) +
  scale_x_continuous(
    labels = label_dollar(scale = 1/1000, suffix = "K"), 
    breaks = seq(1000, 19000, by = 6000)
  )

# Eixo Y - Porcentagem
ggplot(diamante, aes(x = corte, fill = transparencia)) +
  geom_bar(position = "fill") +
  scale_y_continuous(name = "Porcentagem", labels = label_percent())

# Eixo X - Data
presidentes_eua |> View()

presidentes_eua |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(x = inicio, y = id, color = partido)) +
  geom_point() +
  geom_segment(aes(xend = fim, yend = id)) +
  scale_x_date(name = NULL, breaks = presidentes_eua$inicio, date_labels = "'%y") 

##### Layout da legenda #####

###### guide_legend() ######
# Para controlar a exibição de legendas individuais

base <- ggplot(milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point(aes(color = classe))

base + theme(legend.position = "none") 
base + theme(legend.position = "right") 
base + theme(legend.position = "left")
base + 
  theme(legend.position = "top") +
  guides(color = guide_legend(nrow = 3))
base + 
  theme(legend.position = "bottom") +
  guides(color = guide_legend(nrow = 2))

##### Substituindo uma escala #####

###### scale_*_log10() ######

ggplot(diamante, aes(x = quilate, y = preco)) +
  geom_bin2d()

# Eixos são rotulados na escala ajustada
ggplot(diamante, aes(x = log10(quilate), y = log10(preco))) +
  geom_bin2d()

# Eixos são rotulados na escala de dados original
ggplot(diamante, aes(x = quilate, y = preco)) +
  geom_bin2d() + 
  scale_x_log10() + 
  scale_y_log10()

###### scale_color_brewer() ######

ggplot(milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point(aes(color = tracao))

ggplot(milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point(aes(color = tracao)) +
  scale_color_brewer(palette = "Set1")

# https://colorbrewer2.org/

library(RColorBrewer)
display.brewer.all()

###### scale_color_manual() ######
presidentes_eua |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(x = inicio, y = id, color = partido)) +
  geom_point() +
  geom_segment(aes(xend = fim, yend = id)) +
  # scale_color_manual(values = c("#E81B23", "#00AEF3"))
  scale_color_manual(values = c(Republicano = "#E81B23", Democrata = "#00AEF3"))

###### scale_fill_viridis_*() ######

df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000)
)

# geom_hex - Divide o plano em hexágonos regulares
ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed() +
  labs(title = "Padrão, contínua", x = NULL, y = NULL)

# Escala contínua
ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed() +
  scale_fill_viridis_c(end = 0.8) +
  labs(title = "Viridis, contínua", x = NULL, y = NULL)

# Escala agrupada
ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed() +
  scale_fill_viridis_b() +
  labs(title = "Viridis, agrupada", x = NULL, y = NULL)

##### Zoom #####

###### Ajustando quais dados são plotados ######

ggplot(milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point(aes(color = tracao)) +
  geom_smooth()

milhas |>
  filter(cilindrada >= 5 & cilindrada <= 6 & rodovia >= 10 & rodovia <= 25) |>
  ggplot(aes(x = cilindrada, y = rodovia)) +
  geom_point(aes(color = tracao)) +
  geom_smooth()

###### Definir os limites em cada escala ######
# Define os limites em escalas individuais 
# Dados fora desses limites são removidos antes da plotagem
ggplot(milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point(aes(color = tracao)) +
  geom_smooth() +
  scale_x_continuous(limits = c(5, 6)) +
  scale_y_continuous(limits = c(10, 25))

###### Configurando xlim e ylim em coord_cartesian(). ######
# Os pontos fora dos limites continuam existindo no gráfico, mas não são exibidos
ggplot(milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point(aes(color = tracao)) +
  geom_smooth() +
  coord_cartesian(xlim = c(5, 6), ylim = c(10, 25))

#### 4. Temas ####

#### Personalizar os elementos que não são dados de seu gráfico 

# Temas default
# https://ggplot2.tidyverse.org/reference/ggtheme.html
ggplot(milhas, aes(x = cilindrada, y = rodovia)) +
  geom_point(aes(color = classe)) +
  geom_smooth(se = FALSE) +
  theme_bw() #+
  # theme_light #+
  # theme_classic() #+
  # theme_linedraw() #+
  # theme_dark() #+
  # theme_minimal() #+
  # theme_gray() #+ 
  # theme_void()

# É possível controlar componentes individuais de cada tema
# https://ggplot2.tidyverse.org/reference/theme.html
ggplot(milhas, aes(x = cilindrada, y = rodovia, color = tracao)) +
  geom_point() +
  labs(
    title = "Maior número de cilindradas tendem a ter menor economia de combustível",
    caption = "Source: https://fueleconomy.gov."
  ) +
  theme(
    legend.position = c(0.6, 0.7),
    legend.direction = "horizontal",
    legend.box.background = element_rect(color = "black"),
    plot.title = element_text(face = "bold"),
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 0)
  )

#### 5. Layout ####

# Combinar gráficos separados no mesmo gráfico
p1 <- ggplot(milhas, aes(x = cilindrada, y = rodovia)) + 
  geom_point() + 
  labs(title = "Gráfico 1")
p2 <- ggplot(milhas, aes(x = tracao, y = rodovia)) + 
  geom_boxplot() + 
  labs(title = "Gráfico 2")
p1 + p2

# Layouts de gráficos complexos 
p3 <- ggplot(milhas, aes(x = cidade, y = rodovia)) + 
  geom_point() + 
  labs(title = "Gráfico 3")
(p1 | p3) / p2

# Coletar legendas de vários gráficos em uma legenda comum
p1 <- ggplot(milhas, aes(x = tracao, y = cidade, color = tracao)) + 
  geom_boxplot(show.legend = FALSE) + 
  labs(title = "Gráfico 1")

p2 <- ggplot(milhas,aes(x = tracao, y = rodovia, color = tracao)) + ###
  geom_boxplot(show.legend = FALSE) + 
  labs(title = "Gráfico 2")

p3 <- ggplot(milhas, aes(x = cidade, color = tracao, fill = tracao)) + 
  geom_density(alpha = 0.5) + ###
  labs(title = "Gráfico 3")

p4 <- ggplot(milhas, aes(x = rodovia, color = tracao, fill = tracao)) + 
  geom_density(alpha = 0.5) + 
  labs(title = "Gráfico 4")

p5 <- ggplot(milhas, aes(x = cidade, y = rodovia, color = tracao)) + 
  geom_point(show.legend = FALSE) + 
  facet_wrap(~tracao) +
  labs(title = "Gráfico 5")

(guide_area() / (p1 + p2) / (p3 + p4) / p5) +
  plot_annotation(
    title = "Eficiência nas cidades e rodovias com diferentes trações",
    caption = "Fonte: https://fueleconomy.gov."
  ) +
  plot_layout(
    guides = "collect",
    heights = c(1, 3, 2, 4)
  ) &
  theme(legend.position = "top")




