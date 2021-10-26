# Various attempts to recreate the first example from the Highcharts
# accessibility module documentation
# <https://www.highcharts.com/docs/accessibility/accessibility-module>

# screen-readery edition --------------------------------------------------
library(tidyverse)
library(highcharter)

url <- "https://gist.githubusercontent.com/batpigandme/aeb30566f899cdcdeb6024c0344d1ae1/raw/9cbafbbc99311c04b1a675e0ebb3953692fd51b8/pop-screenreaders.csv"
raw_dat <- read_csv(url)

# replace July with proper abbreviation
raw_dat[4,1] <- "Jul 2015"

# turn into "tidy" data format for categories
sr_dat <- raw_dat %>%
  separate(Category, into = c("month", "year")) %>%
  select(-month) %>%
  pivot_longer(!year, names_to = "screen_reader", values_to = "pct_usage") %>%
  mutate(year = parse_number(year)) %>%
  drop_na()

hchart(
  sr_dat,
  "spline",
  hcaes(x = year, y = pct_usage, group = screen_reader),
  accessibility = list(
    enabled = TRUE,
    keyboardNavigation = list(enabled = TRUE),
    linkedDescription = "Line chart demonstrating some accessibility features of Highcharts. The chart displays the most commonly used screen readers in surveys taken by WebAIM from December 2010 to September 2019. JAWS was the most used screen reader until 2019, when NVDA took over. VoiceOver is the third most used screen reader, followed by Narrator. ZoomText/Fusion had a surge in 2015, but usage is otherwise low. The overall use of other screen readers has declined drastically the past few years."
  ),
  exporting = list(
    enabled = TRUE,
    accessibility = list(enabled = TRUE)
  )
) %>%
  hc_title(
    text = "Most common desktop screen readers"
  ) %>%
  hc_subtitle(
    text = "Source: WebAIM."
  ) %>%
  hc_xAxis(
    title = list(text = "Time"),
    accesibility = list(
      enabled = TRUE,
      description = list(text = "Time from December 2010 to September 2019"),
      rangeDescription = "2010 to 2019"
    )
  ) %>%
  hc_yAxis(
    title = list(text = "Percentage usage"),
    accessibility = list(description = "Percentage usage")
  ) %>%
  hc_exporting(
    enabled = TRUE,
    accessibility = list(
      enabled = TRUE
    )
  ) %>%
  hc_colors(c('#49a65e', '#f45b5b', '#b381b3', '#5f98cf', '#434348', '#b68c51')) %>%
  hc_add_dependency(name = "modules/accessibility.js") %>%
  hc_add_dependency(name = "modules/exporting.js") %>%
  hc_add_dependency(name = "modules/export-data.js")

# above gives you range in the screenreader description because it's
# parsed as numeric

# below doesn't work, but might if you added the theme js to highcharter?
# see https://github.com/jbkunst/highcharter/issues/734
# hc_add_dependency(name = "themes/high-contrast-light.js")

# using raw_data with individual series
# turn Category into ordered factor and remove inconsistent period
sr_dat2 <- raw_dat %>%
  mutate(Category = str_replace_all(Category, "\\.", "")) %>%
  mutate(Category = as_factor(Category))

# check to make sure that did what I wanted
sr_dat2$Category

hchart(
  sr_dat2,
  "spline",
  name = "screenreaders",
  hcaes(x = Category),
  accessibility = list(
    enabled = TRUE,
    keyboardNavigation = list(enabled = TRUE),
    linkedDescription = list(text = "A line chart of most common desktop screen readers")
  )
) %>%
  hc_title(
    text = "Most common desktop screen readers"
  ) %>%
  hc_subtitle(
    text = "Source: WebAIM."
  ) %>%
  hc_caption(text = "Line chart demonstrating some accessibility features of Highcharts. The chart displays the most commonly used screen readers in surveys taken by WebAIM from December 2010 to September 2019. JAWS was the most used screen reader until 2019, when NVDA took over. VoiceOver is the third most used screen reader, followed by Narrator. ZoomText/Fusion had a surge in 2015, but usage is otherwise low. The overall use of other screen readers has declined drastically the past few years.") %>%
  hc_yAxis(
    title = list(text = "Percentage usage"),
    accessibility = list(description = "Percentage usage")
  ) %>%
  hc_xAxis(
    title = list(text = "Time"),
    accesibility = list(
      enabled = TRUE,
      description = "Time from December 2010 to September 2019"
    )
  ) %>%
  hc_add_series(sr_dat2, "spline", hcaes(x = Category, y = NVDA), name = "NVDA", color = "#49a65e", label = list(enabled = TRUE)) %>%
  hc_add_series(sr_dat2, "spline", hcaes(x = Category, y = JAWS), name = "JAWS", color = "#5f98cf", dashStyle = "ShortDashDot", label = list(enabled = TRUE)) %>%
  hc_add_series(sr_dat2, "spline", hcaes(x = Category, y = VoiceOver), name = "VoiceOver", color = "#434348", dashStyle = "ShortDot", label = list(enabled = TRUE)) %>%
  hc_add_series(sr_dat2, "spline", hcaes(x = Category, y = Narrator), name = "Narrator", color = "#b381b3", dashStyle = "Dash", label = list(enabled = TRUE)) %>%
  hc_add_series(sr_dat2, "spline", hcaes(x = Category, y = `ZoomText/Fusion`), name = "ZoomText/Fusion", color = "#b68c51", dashStyle = "ShortDot", label = list(enabled = TRUE)) %>%
  hc_add_series(sr_dat2, "spline", hcaes(x = Category, y = Other), name = "Other", color = "#f45b5b", dashStyle = "ShortDash", label = list(enabled = TRUE)) %>%
  hc_exporting(
    enabled = TRUE,
    accessibility = list(
      enabled = TRUE
    )
  ) %>%
  hc_tooltip(valueSuffix = "%") %>%
  hc_add_dependency(name = "modules/series-label.js") %>%
  hc_add_dependency(name = "modules/accessibility.js") %>%
  hc_add_dependency(name = "modules/exporting.js") %>%
  hc_add_dependency(name = "modules/export-data.js")

# need to add as individual series to set dashStyle?
# can't get the accessibility description to actually appear in screenReader
# section when rendered…
# should use xAxisDescription https://api.highcharts.com/highcharts/accessibility.screenReaderSection.beforeChartFormat

# Colors from HighContrastLight palette
colors <- list('#5f98cf',
               '#434348',
               '#49a65e',
               '#f45b5b',
               '#708090',
               '#b68c51',
               '#397550',
               '#c0493d',
               '#4f4a7a',
               '#b381b3')


# if wanted to use actual values...I don't think this would actually work
dash_styles <- c("Solid", "ShortDashDot", "ShortDot", "Dash", "ShortDot", "ShortDash")
line_colors <- c("#49a65e", "#5f98cf", "#434348", "#b381b3", "#b68c51", "#f45b5b")


# Indiv data series in different style ------------------------------------
# recreating first example here: https://www.highcharts.com/docs/accessibility/accessibility-module
# using Joshua Kunst's pattern fill examples as a model
# see them here: https://jkunst.com/highcharter/articles/modules.html#pattern-fills-1

library(tidyverse)
library(highcharter)

url <- "https://gist.githubusercontent.com/batpigandme/aeb30566f899cdcdeb6024c0344d1ae1/raw/9cbafbbc99311c04b1a675e0ebb3953692fd51b8/pop-screenreaders.csv"
raw_dat <- read_csv(url)

# turn Category into ordered factor and remove inconsistent period
sr_dat3 <- raw_dat %>%
  mutate(Category = str_replace_all(Category, "\\.", "")) %>%
  mutate(Category = as_factor(Category))

# OK, this one works — gives legend and double encoding
# But, I can't get the range in the xAxis screen reader description
hc_sr_setup <- highchart() %>%
  # add dependencies
  hc_add_dependency(name = "modules/series-label.js") %>%
  hc_add_dependency(name = "modules/accessibility.js") %>%
  hc_add_dependency(name = "modules/exporting.js") %>%
  hc_add_dependency(name = "modules/export-data.js") %>%
  hc_chart(
    type = "spline",
    accessibility = list(
      enabled = TRUE,
      keyboardNavigation = list(enabled = TRUE),
      linkedDescription = "Line chart demonstrating some accessibility features of Highcharts. The chart displays the most commonly used screen readers in surveys taken by WebAIM from December 2010 to September 2019. JAWS was the most used screen reader until 2019, when NVDA took over. VoiceOver is the third most used screen reader, followed by Narrator. ZoomText/Fusion had a surge in 2015, but usage is otherwise low. The overall use of other screen readers has declined drastically the past few years."
    ),
    dateTimeLabelFormats = list(
      month = list(main = "%b %Y")
    )
  ) %>%
  hc_title(text = "Most common desktop screen readers") %>%
  hc_subtitle(text = "Source: WebAIM.") %>%
  hc_caption(text = "Line chart demonstrating some accessibility features of Highcharts. The chart displays the most commonly used screen readers in surveys taken by WebAIM from December 2010 to September 2019. JAWS was the most used screen reader until 2019, when NVDA took over. VoiceOver is the third most used screen reader, followed by Narrator. ZoomText/Fusion had a surge in 2015, but usage is otherwise low. The overall use of other screen readers has declined drastically the past few years.") %>%
  hc_xAxis(categories = sr_dat3$Category,
           title = list(text = "Time"),
           accesibility = list(
             enabled = TRUE,
             description = "Time from December 2010 to September 2019",
             range = "December 2010 to September 2019"
           )
  ) %>%
  hc_yAxis(
    title = list(text = "Percentage usage"),
    accessibility = list(description = "Percentage usage")
  ) %>%
  hc_plotOptions(
    spline = list(
      accessibility = list(
        enabled = TRUE,
        keyboardNavigation = list(enabled = TRUE)
      )
    )
  )

# try adding the series
hc_sr_setup %>%
  hc_xAxis(categories = sr_dat3$Category,
           title = list(text = "Time"),
           accesibility = list(
             enabled = TRUE,
             description = "Time from December 2010 to September 2019",
             range = "December 2010 to September 2019"
           ),
           dateTimeLabelFormats = list(
             month = list(main = "%b %Y")
           )
  ) %>%
  hc_add_series(
    data = sr_dat3$NVDA,
    name = "NVDA",
    color = "#49a65e",
    label = list(enabled = TRUE)
  ) %>%
  hc_add_series(
    data = sr_dat3$JAWS,
    name = "JAWS",
    color = "#5f98cf",
    dashStyle = "ShortDashDot",
    label = list(enabled = TRUE)
  ) %>%
  hc_add_series(
    data = sr_dat3$VoiceOver,
    name = "VoiceOver",
    color = "#434348",
    dashStyle = "ShortDot",
    label = list(enabled = TRUE)
  ) %>%
  hc_add_series(
    data = sr_dat3$Narrator,
    name = "Narrator",
    color = "#b381b3",
    dashStyle = "Dash",
    label = list(enabled = TRUE)
  ) %>%
  hc_add_series(
    data = sr_dat3$`ZoomText/Fusion`,
    name = "ZoomText/Fusion",
    color = "#b68c51",
    dashStyle = "ShortDot",
    label = list(enabled = TRUE)
  ) %>%
  hc_add_series(
    data = sr_dat3$Other,
    name = "Other", color = "#f45b5b",
    dashStyle = "ShortDash",
    label = list(enabled = TRUE)
  ) %>%
  hc_exporting(
    enabled = TRUE,
    accessibility = list(
      enabled = TRUE
    )
  ) %>%
  hc_tooltip(valueSuffix = "%")


# attempt to have x-axis as actual DateTime -------------------------------

sr_dat4 <- raw_dat %>%
  mutate(Category = str_replace_all(Category, "\\.", "")) %>%
  mutate(Category = parse_date(as.character(Category), format = "%b %Y"))

# But, I can't get the range in the xAxis screen reader description
hc_sr_setup <- highchart() %>%
  # add dependencies
  hc_add_dependency(name = "modules/series-label.js") %>%
  hc_add_dependency(name = "modules/accessibility.js") %>%
  hc_add_dependency(name = "modules/exporting.js") %>%
  hc_add_dependency(name = "modules/export-data.js") %>%
  hc_chart(
    type = "spline",
    accessibility = list(
      enabled = TRUE,
      keyboardNavigation = list(enabled = TRUE),
      linkedDescription = "Line chart demonstrating some accessibility features of Highcharts. The chart displays the most commonly used screen readers in surveys taken by WebAIM from December 2010 to September 2019. JAWS was the most used screen reader until 2019, when NVDA took over. VoiceOver is the third most used screen reader, followed by Narrator. ZoomText/Fusion had a surge in 2015, but usage is otherwise low. The overall use of other screen readers has declined drastically the past few years."
    )
  ) %>%
  hc_title(text = "Most common desktop screen readers") %>%
  hc_subtitle(text = "Source: WebAIM.") %>%
  hc_caption(text = "Line chart demonstrating some accessibility features of Highcharts. The chart displays the most commonly used screen readers in surveys taken by WebAIM from December 2010 to September 2019. JAWS was the most used screen reader until 2019, when NVDA took over. VoiceOver is the third most used screen reader, followed by Narrator. ZoomText/Fusion had a surge in 2015, but usage is otherwise low. The overall use of other screen readers has declined drastically the past few years.") %>%
  hc_xAxis(categories = sr_dat4$Category,
           title = list(text = "Time"),
           accesibility = list(
             enabled = TRUE,
             description = "Time from December 2010 to September 2019",
             range = "December 2010 to September 2019"
           )
  ) %>%
  hc_yAxis(
    title = list(text = "Percentage usage"),
    accessibility = list(description = "Percentage usage")
  ) %>%
  hc_plotOptions(
    spline = list(
      accessibility = list(
        enabled = TRUE,
        keyboardNavigation = list(enabled = TRUE)
      )
    )
  )

# try adding the series
hc_sr_setup %>%
  hc_xAxis(categories = sr_dat4$Category,
           title = list(text = "Time"),
           accesibility = list(
             enabled = TRUE,
             description = "Time from December 2010 to September 2019",
             range = "December 2010 to September 2019"
           )
  ) %>%
  hc_add_series(
    data = sr_dat4$NVDA,
    name = "NVDA",
    color = "#49a65e",
    label = list(enabled = TRUE)
  ) %>%
  hc_add_series(
    data = sr_dat4$JAWS,
    name = "JAWS",
    color = "#5f98cf",
    dashStyle = "ShortDashDot",
    label = list(enabled = TRUE)
  ) %>%
  hc_add_series(
    data = sr_dat4$VoiceOver,
    name = "VoiceOver",
    color = "#434348",
    dashStyle = "ShortDot",
    label = list(enabled = TRUE)
  ) %>%
  hc_add_series(
    data = sr_dat4$Narrator,
    name = "Narrator",
    color = "#b381b3",
    dashStyle = "Dash",
    label = list(enabled = TRUE)
  ) %>%
  hc_add_series(
    data = sr_dat4$`ZoomText/Fusion`,
    name = "ZoomText/Fusion",
    color = "#b68c51",
    dashStyle = "ShortDot",
    label = list(enabled = TRUE)
  ) %>%
  hc_add_series(
    data = sr_dat4$Other,
    name = "Other", color = "#f45b5b",
    dashStyle = "ShortDash",
    label = list(enabled = TRUE)
  ) %>%
  hc_exporting(
    enabled = TRUE,
    accessibility = list(
      enabled = TRUE
    )
  ) %>%
  hc_tooltip(valueSuffix = "%")
