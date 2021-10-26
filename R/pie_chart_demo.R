# trying to recreate highcharts accessible pie chart demo
# here: <https://www.highcharts.com/demo/accessible-pie>
# using {highcharter} package and modules examples from docs
# here: <https://jkunst.com/highcharter/articles/modules.html>

suppressPackageStartupMessages(library(tidyverse))
library(highcharter)

# csv export from original pie chart
url <- "https://gist.githubusercontent.com/batpigandme/478afb21e83284ea28d9a580e4f45a55/raw/3a83d7664339157c715366282590a8a1671add39/primary-desktoplaptop-sc.csv"
raw_dat <- read_csv(url)

mod_dat <- janitor::clean_names(raw_dat)

# do setup for chart
hc_pie_setup <- highchart() %>%
  # add dependencies
  hc_add_dependency(name = "modules/exporting.js") %>%
  hc_add_dependency(name = "modules/export-data.js") %>%
  hc_add_dependency(name = "modules/accessibility.js") %>%
  hc_add_dependency(name = "modules/pattern-fill.js") %>%
  hc_chart(
    type = "pie",
    accessibility = list(
      enabled = TRUE,
      keyboardNavigation = list(enabled = TRUE)
    )
  ) %>%
  hc_title(text = "Primary desktop/laptop screen readers") %>%
  hc_subtitle(text = "Source: WebAIM.") %>%
  hc_caption(text = "Pie chart demonstrating some accessibility features of Highcharts. The chart shows which screen reader is used as the primary screen reader by the respondents, with NVDA currently being the most popular one. The JAWS screen reader is following closely behind.") %>%
  hc_plotOptions(
    series = list(
      name = "Screen reader usage",
      dataLabels = list(
        enabled = TRUE,
        connectorColor = "#777"
      ),
      cursor = "pointer",
      borderWidth = 3
    ),
    pie = list(
      fillColor = list(
        pattern = list(
          path = list(
            d = "M 0 0 L 10 10 M 9 -1 L 11 1 M -1 9 L 1 11",
            strokeWidth = 2
          ),
          width = 10,
          height = 10,
          opacity = 0.4
        )
      )
    )
  ) %>%
  hc_tooltip(
    valueSuffix = "%",
    borderColor = "#8ae"
  ) %>%
  hc_exporting(
    enabled = TRUE,
    accessibility = list(
      enabled = TRUE
    )
  )

hc_pie_setup %>%
  hc_add_series(
    mod_dat,
    "pie",
    hcaes(
      name = category,
      y = screen_reader_usage
    ),
    name = "Screen reader usage",
    fillColor = list(
      pattern = list(
        color= 'white'
      )
    )
  ) %>%
  hc_colors(c("#49a65e", "#5f98cf", "#f45b5b", "#434348", "#708090"))


highcontrast_light_colors <- list('#5f98cf', '#434348', '#49a65e', '#f45b5b', '#708090', '#b68c51', '#397550', '#c0493d', '#4f4a7a', '#b381b3')
# predefined highcharts patterns
hc_patterns <- c('M 0 0 L 10 10 M 9 -1 L 11 1 M -1 9 L 1 11',
                 'M 0 10 L 10 0 M -1 1 L 1 -1 M 9 11 L 11 9',
                 'M 3 0 L 3 10 M 8 0 L 8 10',
                 'M 0 3 L 10 3 M 0 8 L 10 8',
                 'M 0 3 L 5 3 L 5 0 M 5 10 L 5 7 L 10 7',
                 'M 3 3 L 8 3 L 8 8 L 3 8 Z',
                 'M 5 5 m -4 0 a 4 4 0 1 1 8 0 a 4 4 0 1 1 -8 0',
                 'M 10 3 L 5 3 L 5 0 M 5 10 L 5 7 L 0 7',
                 'M 2 5 L 5 2 L 8 5 L 5 8 Z',
                 'M 0 0 L 5 10 L 10 0')
