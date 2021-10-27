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
        connectorColor = "#777",
        format = "<b>{point.name}</b>: {point.percentage:.1f} %"
      ),
      cursor = "pointer",
      borderWidth = 3
    ),
    accessibility = list(
      enabled = TRUE,
      keyboardNavigation = list(enabled = TRUE)
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
# above works without patterns

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

# from demo JS
# var clrs = Highcharts.getOptions().colors;
# var pieColors = [clrs[2], clrs[0], clrs[3], clrs[1], clrs[4]];
#
# // Get a default pattern, but using the pieColors above.
# // The i-argument refers to which default pattern to use
# function getPattern(i) {
#   return {
#     pattern: Highcharts.merge(Highcharts.patterns[i], {
#       color: pieColors[i]
#     })
#   };
# }
#
# // Get 5 patterns
# var patterns = [0, 1, 2, 3, 4].map(getPattern);
#
#
# patterns returned from console
# getPattern(i)
#
# patterns[0]
# color: "#49a65e"
# height: 5
# path: "M 0 0 L 5 5 M 4.5 -0.5 L 5.5 0.5 M -0.5 4.5 L 0.5 5.5"
# patternTransform: "scale(1.4 1.4)"
# width: 5
# patterns[1]
# color: "#5f98cf"
# height: 5
# path: "M 0 5 L 5 0 M -0.5 0.5 L 0.5 -0.5 M 4.5 5.5 L 5.5 4.5"
# patternTransform: "scale(1.4 1.4)"
# width: 5
# patterns[2]
# color: "#f45b5b"
# height: 5
# path: "M 2 0 L 2 5 M 4 0 L 4 5"
# patternTransform: "scale(1.4 1.4)"
# width: 5
# patterns[3]
# color: "#434348"
# height: 5
# path: "M 0 2 L 5 2 M 0 4 L 5 4"
# patternTransform: "scale(1.4 1.4)"
# width: 5
# patterns[4]
# color: "#708090"
# height: 5
# path: "M 0 1.5 L 2.5 1.5 L 2.5 0 M 2.5 5 L 2.5 3.5 L 5 3.5"
# patternTransform: "scale(1.4 1.4)"
# width: 5

# pie chart attempt w/ data list ------------------------------------------
library(highcharter)

highchart() %>%
  # add dependencies
  hc_add_dependency(name = "modules/exporting.js") %>%
  hc_add_dependency(name = "modules/export-data.js") %>%
  hc_add_dependency(name = "modules/accessibility.js") %>%
  hc_add_dependency(name = "modules/pattern-fill.js") %>%
  hc_tooltip(
    valueSuffix = "%",
    borderColor = "#8ae"
  ) %>%
  hc_title(text = "Primary desktop/laptop screen readers") %>%
  hc_subtitle(text = "Source: WebAIM.") %>%
  hc_caption(text = "Pie chart demonstrating some accessibility features of Highcharts. The chart shows which screen reader is used as the primary screen reader by the respondents, with NVDA currently being the most popular one. The JAWS screen reader is following closely behind.") %>%
  hc_exporting(
    enabled = TRUE,
    accessibility = list(
      enabled = TRUE
    )
  ) %>%
  hc_add_series(
    type = "pie",
    name = "Screen reader usage",
    data = list(
      list(
        name = "NVDA",
        y = 40.6,
        color = list(
          pattern = list(
            path = "M 0 0 L 5 5 M 4.5 -0.5 L 5.5 0.5 M -0.5 4.5 L 0.5 5.5",
            color = "#49a65e",
            height = 5,
            width = 5,
            patternTransform = "scale(1.4 1.4)"
          )
        )
      ),
      list(
        name = "JAWS",
        y = 40.1,
        color = list(
          pattern = list(
            path = "M 0 5 L 5 0 M -0.5 0.5 L 0.5 -0.5 M 4.5 5.5 L 5.5 4.5",
            color = "#5f98cf",
            height = 5,
            width = 5,
            patternTransform = "scale(1.4 1.4)"
          )
        )
      ),
      list(
        name = "VoiceOver",
        y = 12.9,
        color = list(
          pattern = list(
            path = "M 2 0 L 2 5 M 4 0 L 4 5",
            color = "#f45b5b",
            height = 5,
            width = 5,
            patternTransform = "scale(1.4 1.4)"
          )
        )
      ),
      list(
        name = "ZoomText",
        y = 2,
        color = list(
          pattern = list(
            path = "M 0 2 L 5 2 M 0 4 L 5 4",
            color = "#434348",
            height = 5,
            width = 5,
            patternTransform = "scale(1.4 1.4)"
          )
        )
      ),
      list(
        name = "Other",
        y = 4.4,
        color = list(
          pattern = list(
            path = "M 0 1.5 L 2.5 1.5 L 2.5 0 M 2.5 5 L 2.5 3.5 L 5 3.5",
            color = "#708090",
            height = 5,
            width = 5,
            patternTransform = "scale(1.4 1.4)"
          )
        )
      )
    )
  ) %>%
  hc_plotOptions(
    series = list(
      dataLabels = list(
        enabled = TRUE,
        connectorColor = "#777",
        format = "<b>{point.name}</b>: {point.percentage:.1f} %"
      ),
      cursor = "pointer",
      borderWidth = 3
    ),
    accessibility = list(
      enabled = TRUE,
      keyboardNavigation = list(enabled = TRUE)
    )
  )
