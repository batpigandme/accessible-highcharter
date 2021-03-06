# adapted from Highcharts advanced annotations demo
# <https://jsfiddle.net/gh/get/library/pure/highcharts/highcharts/tree/master/samples/highcharts/demo/annotations/>

# read in data ------------------------------------------------------------
suppressPackageStartupMessages(library(tidyverse))
url <- "https://gist.githubusercontent.com/batpigandme/1916d95323ddb29274bddf3316041fd3/raw/a8f394cb85b4ae995798c2596ffe912491d2fb7c/2017-tour-de-france-stage-8.csv"
tdf_data <- read_csv(url) %>%
  drop_na() # have some from data export


# load highcharter and set options ----------------------------------------

library(highcharter)

options(
  highcharter.lang = list(
    accessibility = list(
      screenReaderSection = list(
        annotations = list(
          descriptionNoPoints = '{annotationText}, at distance {annotation.options.point.x}km, elevation {annotation.options.point.y} meters.'
        )
      )
    )
  )
)

# build chart with {highcharter} ------------------------------------------

highchart() %>%
  hc_add_dependency(name = "modules/accessibility.js") %>%
  hc_add_dependency(name = "modules/annotations.js") %>%
  hc_add_dependency(name = "modules/exporting.js") %>%
  hc_add_dependency(name = "modules/export-data.js") %>%
  hc_add_series(tdf_data, "area", hcaes(x = Distance, y = Elevation),
                lineColor = "#434348",
                color = "#90ed7d",
                fillOpacity = 0.5,
                marker = list(enabled = FALSE)) %>%
  hc_xAxis(
    title = list(text = "Distance"),
    labels = list(format = "{value} km"),
    minRange = 5,
    accessibility = list(
      rangeDescription = "Range: 0 to 187.8 km."
    )
  ) %>%
  hc_yAxis(
    title = list(text = ""),
    labels = list(format = "{value} m"),
    startOnTick = TRUE,
    endOnTick = FALSE,
    maxPadding = 0.35,
    accessibility = list(
      description = "Elevation",
      rangeDescription = "Range: 0 to 1,553 meters"
    )
  ) %>%
  hc_title(text = "2017 Tour de France Stage 8: Dole - Station des Rousses") %>%
  hc_caption(text = "This chart uses the Highcharts Annotations feature to place labels at various points of interest. The labels are responsive and will be hidden to avoid overlap on small screens.") %>%
  # begin annotations
  # note that the points are grouped into separate lists
  # so that they can be styled in those groups
  hc_annotations(
    list(
      labelOptions = list(
        backgroundColor = 'rgba(255,255,255,0.6)',
        verticalAlign = 'top',
        y = 15
      ),
      labels = list(
        list(
          point = list(xAxis = 0, yAxis = 0, x = 27.98, y = 255),
          text = "Arbois"
        ),
        list(
          point = list(xAxis = 0, yAxis = 0, x = 45.5, y = 611),
          text = "Montrond"
        ),
        list(
          point = list(xAxis = 0, yAxis = 0, x = 63, y = 651),
          text = "Mont-sur-Monnet"
        ),
        list(
          point = list(xAxis = 0, yAxis = 0, x = 84, y = 789),
          x = -10,
          text = "Bonlieu"
        ),
        list(
          point = list(xAxis = 0, yAxis = 0, x = 129.5, y = 382),
          text = "Chassal"
        ),
        list(
          point = list(xAxis = 0, yAxis = 0, x = 159, y = 443),
          text = "Saint-Claude"
        )
      )
    ),
    list(
      labels = list(
        list(
          point = list(xAxis = 0, yAxis = 0, x = 101.44, y = 1026),
          x = -30,
          text = "Col de la Joux"
        ),
        list(
          point = list(xAxis = 0, yAxis = 0, x = 138.5, y = 748),
          text = "Côte de Viry"
        ),
        list(
          point = list(xAxis = 0, yAxis = 0, x = 176.4, y = 1202),
          text = "Montée de la Combe <br>de Laisia Les Molunes"
        )
      )
    ),
    list(
      labelOptions = list(
        shape = "connector",
        align = "right",
        justify = FALSE,
        crop = TRUE,
        style = list(
          fontSize = "0.8em",
          textOutline = "1px white"
        )
      ),
      labels = list(
        list(
          point = list(xAxis = 0, yAxis = 0, x = 96.2, y = 783),
          text = "6.1 km climb <br>4.6% on avg."
        ),
        list(
          point = list(xAxis = 0, yAxis = 0, x = 134.5, y = 540),
          text = "7.6 km climb <br>5.2% on avg."
        ),
        list(
          point = list(xAxis = 0, yAxis = 0, x = 172.2, y = 925),
          text = "11.7 km climb <br>6.4% on avg."
        )
      )
    )
  ) %>%
  hc_tooltip(
    headerFormat = "Distance: {point.x:.1f} km<br>",
    pointFormat = "{point.y} m a. s. l.",
    shared = TRUE
  ) %>%
  hc_legend(enabled = FALSE) %>%
  hc_exporting(
    enabled = TRUE,
    accessibility = list(
      enabled = TRUE
    )
  ) %>%
  hc_plotOptions(
    accessibility = list(
      enabled = TRUE,
      keyboardNavigation = list(enabled = TRUE),
      linkedDescription = 'This line chart uses the Highcharts Annotations feature to place labels at various points of interest. The labels are responsive and will be hidden to avoid overlap on small screens. Image description: An annotated line chart illustrates the 8th stage of the 2017 Tour de France cycling race from the start point in Dole to the finish line at Station des Rousses. Altitude is plotted on the Y-axis, and distance is plotted on the X-axis. The line graph is interactive, and the user can trace the altitude level along the stage. The graph is shaded below the data line to visualize the mountainous altitudes encountered on the 187.5-kilometre stage. The three largest climbs are highlighted at Col de la Joux, Côte de Viry and the final 11.7-kilometer, 6.4% gradient climb to Montée de la Combe de Laisia Les Molunes which peaks at 1200 meters above sea level. The stage passes through the villages of Arbois, Montrond, Bonlieu, Chassal and Saint-Claude along the route.',
      landmarkVerbosity = "one"
    ),
    area = list(
      accessibility = list(
        description = "This line chart uses the Highcharts Annotations feature to place labels at various points of interest. The labels are responsive and will be hidden to avoid overlap on small screens. Image description: An annotated line chart illustrates the 8th stage of the 2017 Tour de France cycling race from the start point in Dole to the finish line at Station des Rousses. Altitude is plotted on the Y-axis, and distance is plotted on the X-axis. The line graph is interactive, and the user can trace the altitude level along the stage. The graph is shaded below the data line to visualize the mountainous altitudes encountered on the 187.5-kilometre stage. The three largest climbs are highlighted at Col de la Joux, Côte de Viry and the final 11.7-kilometer, 6.4% gradient climb to Montée de la Combe de Laisia Les Molunes which peaks at 1200 meters above sea level. The stage passes through the villages of Arbois, Montrond, Bonlieu, Chassal and Saint-Claude along the route."
      )
    )
  )



# notes for next time -----------------------------------------------------

# n.b. the options below are chart-level (as opposed to plotOptions)
# for some reason, when I pass them in, the chart doesn't render
# hc_opts = list(
#   chart = list(
#     type = "area",
#     zoomType = "x",
#     panning = TRUE,
#     panKey = "shift",
#     scrollablePlotArea = list(
#       minWidth = 600
#     )
#   )
# )

# lang options are global and can't be set on each chart,
# this is the only place to access the accessibility template for
# the screenreader section for the annotated points
# <https://api.highcharts.com/highcharts/lang.accessibility.screenReaderSection.annotations>
# descriptions that are set in the labelOptions cannot use variables
# <https://api.highcharts.com/highcharts/annotations.labelOptions.accessibility.description>
