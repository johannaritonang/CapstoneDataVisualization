function(input, output){


# is canceled --------------------------------------------------------

# plot  
  output$iscanceledPlot <- renderPlotly({
    # data transformation
    iscanceledplotly <-  hotels %>% 
      filter(arrival_date_year %in% input$selectYear,
             country == input$selectCountry) %>%
      mutate(date = floor_date(date, unit = "month"),
             period = as.yearmon(date)) %>% 
      group_by(period, hotel,is_canceled) %>% 
      summarise(n = n()) %>% 
      ungroup() %>% 
      mutate(text = paste(period,":",n)) %>% 
      
    # visualization
      ggplot(aes(as.factor(period), group = is_canceled, n, text = text)) +
      geom_point(aes(color = is_canceled), color = "cyan") +
      geom_line(aes(color = is_canceled), linetype = "dashed", size = 0.5, color = "green") +
      geom_col(aes(fill=is_canceled), width = 0.5) +
      facet_grid(hotel ~ is_canceled, scales="free") +
      labs(x = NULL, y = NULL) +
      theme(legend.position = "none",  axis.text.x = element_blank()) +
      scale_fill_manual(values=c("purple4", "orangered")) +
      soft_blue_theme
    
    # interactive plot
    ggplotly(iscanceledplotly, tooltip = "text")%>% 
      config(displayModeBar = F)
  })

# data frame
  output$iscanceledDT <- renderDT({
    datatable(
      iscanceled_data <-  hotels %>% 
        filter(arrival_date_year %in% input$selectYear,
               country == input$selectCountry) %>%
        mutate(date = floor_date(date, unit = "month"),
               period = as.yearmon(date),
               period = as.factor(period)) %>% 
        group_by(period, hotel,is_canceled) %>% 
        summarise(n = n()) %>% 
        ungroup(),
      # to show only 8 entries of column and remove select input and search engine on top of the table
      options = list(pageLength = 8, dom = 'tip'),rownames = FALSE
    )
  })

# total night --------------------------------------------------------

# plot
  output$totalnightPlot <- renderPlotly({
    # data transformation
    totalnightplotly <- hotels %>% 
      filter(arrival_date_year %in% input$selectYear,
             country == input$selectCountry) %>%
      mutate(date = floor_date(date, unit = "month"),
             period = as.yearmon(date)) %>% 
      group_by(period, hotel) %>% 
      summarise(week_night = sum(stays_in_week_nights),
                weekend_night = sum(stays_in_weekend_nights)) %>% 
      ungroup() %>% 
      pivot_longer(cols = c(week_night, weekend_night)) %>% 
      mutate(text = paste(hotel,":",value)) %>% 
    
    # visualization
      ggplot(aes(x = period, y = value, col = hotel, group = name, text = text)) +
      geom_line() +
      geom_point() +
      facet_wrap( ~ name, scales="free") +
      labs(x = NULL, y = NULL) +
      theme(legend.position = "none",
            axis.text.x = element_text(angle = 30, hjust = 1)) +
      scale_color_manual(values=c("purple4", "orangered")) +
      soft_blue_theme
   
    # interactive plot 
    ggplotly(totalnightplotly,tooltip = "text")%>% 
      config(displayModeBar = F)
  })

# data frame
  output$totalnightDT <- renderDT({
    datatable(
      totalnightdata <- hotels %>% 
        filter(arrival_date_year %in% input$selectYear,
               country == input$selectCountry) %>%
        mutate(date = floor_date(date, unit = "month"),
               period = as.yearmon(date),
               period = as.factor(period)) %>% 
        group_by(period, hotel) %>% 
        summarise(week_night = sum(stays_in_week_nights),
                  weekend_night = sum(stays_in_weekend_nights)) %>% 
        ungroup() %>% 
        pivot_longer(cols = c(week_night, weekend_night)),
      # to show only 8 entries of column and remove select input and search engine on top of the table
      options = list(pageLength = 8, dom = 'tip'),rownames = FALSE
    )
  })


# world map ---------------------------------------------------------------

  output$leaflet <- renderLeaflet({
    m <- leaflet(worldmap) %>% 
      addProviderTiles("Esri.NatGeoWorldMap") %>% 
      setView( lat=10, lng=0 , zoom=2) %>%
      # for choropleth
      addPolygons( 
        color = "green",
        dashArray = "3", 
        fillOpacity = 0.6,
        weight=1,
        label = paste(worldmap@data$NAME),
        labelOptions = labelOptions( 
          style = list("font-weight" = "normal", padding = "3px 8px"), 
          textsize = "13px", 
          direction = "auto"),
        popup = worldmap@data$text
      )
    
    m
  })


# output hotels data ------------------------------------------------------

  output$hotelsDT <- renderDT({
    # to activate the scroll
    datatable(hotels, options = list(scrollX = T))
  })
}