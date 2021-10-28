# adapted from code for this chart by Silvia Canelón in repo for
# <https://silvia.rbind.io/blog/2021-curated-compilations/01-data-viz-a11y/>

library(highcharter)
library(palmerpenguins)

hchart(penguins, "scatter", hcaes(x = flipper_length_mm,
                                  y = bill_length_mm,
                                  group = species),
       color = c("darkorange", "purple", "#057276")) %>%
  hc_add_theme(
    hc_theme(chart = list(backgroundColor = "white"))) %>%
  hc_add_dependency(name = "modules/accessibility.js") %>%
  hc_exporting(
    enabled = TRUE,
    accessibility = list(
      enabled = TRUE
    )
  ) %>%
  hc_plotOptions(
    accessibility = list(
      enabled = TRUE,
      keyboardNavigation = list(enabled = TRUE)
    )
  ) %>%
  hc_caption(text = "Scatterplot of the palmerpenguins dataset showing data points clustered by species and the highcharter package making it possible to focus on one cluster and identify the x and y values of a specific data point. In this case the data point is a Chinstrap penguin observation mapping to a flipper length of 201mm and bill length of 54.2mm.")
