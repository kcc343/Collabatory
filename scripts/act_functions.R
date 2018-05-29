library(tools)
act_analysis <- function(name, type) {
  data <- read.csv(
    paste0("../files/", tolower(name), "_df.csv"),
    stringsAsFactors = FALSE
  )

  data <- data %>%
    filter(budget != 0 & revenue != 0)

  p <- plot_ly(data,
    y = data[, type],
    name = toTitleCase(name),
    type = "box",
    boxpoints = "all",
    hoverinfo = "text",
    text = paste0(
      "title: ", data[, "title"], "<br />",
      type, ": ", data[, type]
    )
  ) %>%
    layout(
      title = paste0(toTitleCase(name), "'s movie ", type, " boxplot")
    )
  p
}
