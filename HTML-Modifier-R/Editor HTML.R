
# Check and install 'readxl' library if not present
# Verificar e instalar a biblioteca 'readxl' se não estiver presente
if (!requireNamespace("readxl", quietly = TRUE)) {
  install.packages("readxl")
}
library(readxl)

# Read the Excel file
# Ler o arquivo Excel
flashcards <- read_excel("spreadsheet template.xlsx")

# Prepare the data for incorporation into HTML
# Assuming there is only one title in the Content column
# Substituir caracteres de nova linha por tags de quebra HTML para formatação apropriada
title <- flashcards$Content[1] 
questions <- flashcards$Question
answers <- flashcards$Answer

# Replace newline characters with HTML break tags for proper formatting
questions <- gsub("\r\n","<br>", questions)
answers <- gsub("\r\n", "<br>", answers)

# Replace double quotes with single quotes to avoid HTML conflicts
# Substituir aspas duplas por aspas simples para evitar conflitos no HTML
questions <- gsub("\"","'", questions)
answers <- gsub("\"", "'", answers)

# Convert the questions and answers to a JSON list structure
# Converter as perguntas e respostas para uma estrutura de lista JSON
json_cards <- sprintf('[%s]', paste0('{question:"', questions, '",answer:"', answers, '"}', collapse=",\n     "))

# Read the HTML template and identify the markers for insertion
# Ler o template HTML e identificar os marcadores para inserção
html_content <- readLines("Template 03 FlashCard.html", warn = FALSE)
marker_index <- grep("<!--INSERT_CARDS_HERE-->", html_content)
title_index  <- grep("<!--INSERT_TITLE_HERE-->", html_content)

# Insert the JSON cards and title into the HTML content
# Inserir os cartões JSON e o título no conteúdo HTML
html_content[marker_index] <- sprintf("   var cards = %s; \n    ", json_cards)
html_content[title_index] <- paste0("    <h1>", title , "</h1>")

# Save the modified HTML content as a new file
# Salvar o conteúdo HTML modificado como um novo arquivo
writeLines(html_content, paste0(title,".html"))

