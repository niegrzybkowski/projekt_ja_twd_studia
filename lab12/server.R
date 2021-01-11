
library(shiny)
library(ggplot2)
function(input, output, session){
    observeEvent(input[["max_slider"]],{
        updateSliderInput(session, "slider1",
                          max = input[["max_slider"]])
                 })


    output[["text_value"]] <- renderText({
        paste0("Title is ", input[["text1"]])
    })
    output[["long_text_box"]] <- renderUI({
        if(nchar(input[["text1"]]) > 10){
            textOutput("long_text")
        }else{
            NULL
        }
    })
    output[["long_text"]] <- renderText({"Congrats you've written a long text
                                        "})

    df <- reactive({data.frame(x = input[["slider1"]][1]:input[["slider1"]][2],
                          y = 4)})

    output[["plot1"]] <- renderPlot({
        plot_df <- df()
        plot_df[["selected_"]] <- FALSE
        plot_df[rv[["clicked_id"]],"selected_"] <- TRUE

        ggplot(plot_df, aes(x = x, y = y, color = selected_)) +
            geom_point(size = 6) +
            ggtitle(input[["text1"]])

    })

    output[["click_value"]] <- renderPrint({
        points_df()
    })

    points_df <- reactive({
        nearPoints(df(),
                   coordinfo = input[["plot1_click"]],
                   allRows = TRUE,
                   maxpoints = 1,
                   threshold = 10)
        #threshold- dozwolony błąd (odległość) kliknięcia

    })

        #Informacja o kliknięciu musi być przechowywana osobno, bo inaczej zmienia się wraz z każdym
        #rysowaniem wykresu
        #[[]] działa tak samo jak $
        rv <- reactiveValues(
            clicked = NULL,
            clicked_id = c()
        )
        observeEvent(input[["plot1_click"]],{
            rv[["clicked"]] <- nearPoints(df(),
                                          coordinfo = input[["plot1_click"]],
                                          allRows = TRUE,
                                          maxpoints = 1,
                                          threshold = 10)
            rv[["clicked_id"]] <- which(rv[["clicked"]][["selected_"]])
            print(which(rv[["clicked"]][["selected_"]]))
        })





}
