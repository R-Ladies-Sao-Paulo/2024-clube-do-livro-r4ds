# IMPORTACAO DE DADOS ####

# install.packages("tidyverse")
library(tidyverse) # readr

# read.csv (base), read_csv (tidyverse)

getwd() # verificar diretório
setwd("Documentos/rladies") # alterar diretório

estudantes <- read_csv(file = "estudantes.csv", na = c("N/A", "", "NA")) # especificar NAs
estudantes

estudantes |> # renomeando colunas com rename
  rename(
    id_estudante = `ID Estudante`,
    nome_completo = `Nome Completo`
  )


estudantes <- estudantes |> 
  janitor::clean_names() |> # renomeando colunas com janitor
  mutate(plano_alimentar = factor(plano_alimentar), # transformando colluna em fator
         idade = parse_number(if_else(idade == "cinco", "5", idade))) # alterando valor string

estudantes

# salvando como csv
write_csv(estudantes, "estudantes.csv") 
write_csv(estudantes, "estudantes-2.csv")
read_csv("estudantes-2.csv")

# salvando como rds
write_rds(estudantes, "estudantes.rds")
read_rds("estudantes.rds")



read_csv(
  "a,b,c
  1,2,3
  4,5,6"
)

read_csv(
  "A primeira linha de metadados
  A segunda linha de metadados
  x,y,z
  1,2,3",
  skip = 2 # pular linhas
)

read_csv(
  "# Um comentário
  x,y,z
  1,2,3",
  comment = "#" # ignorar comentários
)

read_csv(
  "1,2,3
  4,5,6",
  col_names = FALSE # quando não tem nomes de colunas
)

read_csv(
  "1,2,3
  4,5,6",
  col_names = c("x", "y", "z")
)

read_csv("
  logico,numerico,data,string
  TRUE,1,2021-01-15,abc
  false,4.5,2021-02-15,def
  T,Inf,2021-02-16,ghi
")

simple_csv <- "
  x
  10
  .
  20
  30"

read_csv(simple_csv)

df <- read_csv(
  simple_csv,
  col_types = list(x = col_double())
)

problems(df)

read_csv(simple_csv, na = ".")

outro_csv <-"
x,y,z
1,2,3"

read_csv(
  outro_csv,
  col_types = cols(.default = col_character())
)

read_csv(
  outro_csv,
  col_types = cols_only(x = col_character())
)

arquivos_vendas <- c("01-vendas.csv", "02-vendas.csv", "03-vendas.csv")
read_csv(arquivos_vendas, id = "arquivo")

arquivos_vendas <- list.files(".", pattern = "vendas\\.csv$", full.names = TRUE)
arquivos_vendas


tibble(
  x = c(1, 2, 5),
  y = c("h", "m", "g"),
  z = c(0.2, 0.3, 0.4)
)

tribble(
  ~x, ~y, ~z,
  1, "h", 0.2,
  2, "m", 0.3,
  5, "g", 0.4
)
