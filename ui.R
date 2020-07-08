header <- dashboardHeader(
  title = "Hotel Bookings",
  titleWidth = 200
)

sidebar <- dashboardSidebar(
  width = 100,
  sidebarMenu(
    menuItem(
      text = "Plot",
      tabName = "plot",
      icon = icon("bar-chart-o")
    ),
    menuItem(
      text = "Map",
      tabName = "map",
      icon = icon("globe-asia")
    ),
    menuItem(
      text = "Data",
      tabName = "data",
      icon = icon("table")
    )
  )
)

body <- dashboardBody(
  tags$head(tags$style(HTML('
                                  /* logo */
                                  .skin-blue .main-header .logo {
                                  background-color: black;
                                  font-family: "Bahnschrift";
                                  }
    
                                  /* logo when hovered */
                                  .skin-blue .main-header .logo:hover {
                                  background-color: black;
                                  font-family: "Bahnschrift";
                                  }
    
                                  /* navbar (rest of the header) */
                                  .skin-blue .main-header .navbar {
                                  background-color: black;
                                  }
    
                                  /* main sidebar */
                                  .skin-blue .main-sidebar {
                                  background-color: black;
                                  font-family: "Bahnschrift";
                                  }
    
                                  /* active selected tab in the sidebarmenu */
                                  .skin-blue .main-sidebar .sidebar .sidebar-menu .active a{
                                  background-color: darkgrey;
                                  color:  white;
                                  font-family: "Bahnschrift";
                                  }
    
                                  /* other links in the sidebarmenu */
                                  .skin-blue .main-sidebar .sidebar .sidebar-menu a{
                                  background-color: black;
                                  color:  white;
                                  font-family: "Bahnschrift";
                                  }
    
                                  /* other links in the sidebarmenu when hovered */
                                  .skin-blue .main-sidebar .sidebar .sidebar-menu a:hover{
                                  background-color: darkgrey;
                                  color:  white;
                                  font-family: "Bahnschrift";
                                  }
                                  /* toggle button when hovered  */
                                  .skin-blue .main-header .navbar .sidebar-toggle:hover{
                                  background-color: darkgrey;
                                  }
    
                                  /* body */
                                  .content-wrapper, .right-side {
                                  background-color:  honeydew1;
                                  font-family: "Bahnschrift";
                                  
                                  }
    
                                  ')
                       )
            ),
  tabItems(
    tabItem(
      tabName = "plot",
      fluidRow(
        box(
          solidHeader = T,
          width = 12,
          background = "black",
          column(
            width = 3,
            checkboxGroupInput(inputId = "selectYear",
                               label = "Select Year :", 
                               choices = unique(hotels$arrival_date_year),
                               selected = 2015,
                               inline = TRUE
            )
          ),
          column(
            width = 2,
            selectInput(
              inputId = "selectCountry",
              label = "Select Country :",
              selected = "PRT",
              choices = unique(hotels$country)
            )
          )
        )
      ),
      div(style = "text-align:center",
          h2(tags$b("Canceled and Not Canceled Bookings"))),
      fluidRow(
        column(
          width = 8,
          plotlyOutput("iscanceledPlot")
        ),
        column(
          width = 4,
          DTOutput("iscanceledDT")
        )
      ),
      hr(),
      div(style = "text-align:center",
          h2(tags$b("Total of Nights Stay"))),
      fluidRow(
        column(
          width = 8,
          plotlyOutput("totalnightPlot")
        ),column(
          width = 4,
          DTOutput("totalnightDT")
        )
      )
    ),
    tabItem(
      tabName = "map",
      fluidPage(
        div(style = "text-align:center",
            h2(tags$b("Hotel Type per Country 2017"))),
        leafletOutput("leaflet", height = 500)
      )
    ),
    tabItem(
      tabName = "data",
      DTOutput("hotelsDT")
    )
  )
)

dashboardPage(
  header = header,
  sidebar = sidebar,
  body = body
)
