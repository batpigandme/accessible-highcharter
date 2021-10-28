# adapted from code for this chart by Silvia Canelón in repo for
# <https://silvia.rbind.io/blog/2021-curated-compilations/01-data-viz-a11y/>

library(highcharter)
library(palmerpenguins)

highchart() %>%
  hc_add_dependency(name = "modules/accessibility.js") %>%
  hc_add_dependency(name = "modules/annotations.js") %>%
  hc_add_series(penguins, "scatter", hcaes(x = flipper_length_mm,
                                           y = bill_length_mm,
                                           group = species)) %>%
  # n.b. by not adding color, you get "free" dual encoding of points
  # with the shape of the markers for each species
  hc_xAxis(
    title = list(text = "Flipper length (mm)"),
    accessibility = list(
      enabled = TRUE,
      description = "flipper length in milimeters"
    )
  ) %>%
  hc_yAxis(
    title = list(text = "Bill length (mm)"),
    accessibility = list(
      enabled = TRUE,
      description = "bill length in milimeters"
    )
  ) %>%
  hc_annotations(
    list(
      labels = list(
        list(
          point = list(x = 201, y = 54.2, xAxis = 0, yAxis = 0),
          text = "Chinstrap<br/>x: {x}<br/>y: {y}"
        )
      ),
      # below gives you screenreader descriptions of annotations
      labelOptions = list(
        accessibility = list(
          description = "A Chinstrap penguin observation mapping to a flipper length of 201mm and bill length of 54.2mm."
      )
    )
  )
  )%>%
  hc_caption(text = "Scatterplot of the palmerpenguins dataset showing data points clustered by species (Adelie, Chinstrap, and Gentoo) using the highcharter package making it possible to focus on one cluster and identify the x and y values of a specific data point. In this case the data point is a Chinstrap penguin observation mapping to a flipper length of 201mm and bill length of 54.2mm.") %>%
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
  )
