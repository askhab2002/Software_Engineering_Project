investPageLayout <- sidebarLayout(
  sidebarPanel = sidebarPanel(
    #style = "position:fixed;width:inherit;",
    
    #tags$h1("Header for sidebar panel"), 
    
    width = 1
  ),
  
  mainPanel = mainPanel(
    h2("Информация про экономику России"), 
    tags$text("Привет!", fontsize = 20),
    tags$br(),
    tags$text("Эта страница - наше исследование структуры экономики России. 
              Оно может помочь в выборе долгосрочных стратегий", fontsize = 20),
    tags$br(),
    tags$text("На основе десятилетних данных с 31.10.2013 по 31.10.2023 можно обучить модель 
              байесовской векторной авторегрессии (BVAR) на 17 макроэкономических переменных.", fontsize = 20),
    tags$br(),
    tags$text("Для обучения выберите количество итераций алгоритма. Чем болььше интераций, тем точнее результат и тем дольше его придется ждать.", fontsize = 20),
    tags$br(),
    tags$br(),
    fixedRow(
      column(3, "Число итераций:"),
      column(3, textInput(inputId = "iterations",
                          label = NULL,
                          value = "1000")),
      column(3, actionButton(inputId = "learning",
                             label = "Начать обучение",
                             text = "Начать обучение"
                             )),
      column(3, textOutput(outputId = "progress")),
    ),
    
    h6("Первым результатом обучения является прогноз. Двигай ползунок, чтобы увидеть прогноз на большее или меньшее число дней:"),
    tags$br(),
    fixedRow(
      column(2, noUiSliderInput("forecast", label = "Горизонт прогноза:", 
                    min = 1, max = 100, value = 30, 
                    step = 1, orientation = "vertical",
                    direction =  "rtl", height = "280px",
                    color = "cyan"),),
      column(10, plotOutput(outputId = "forecast_plot"))
    ),
    
    # sliderInput("forecast", label = "Выбирай, на сколько дней веперед показать прогноз", 
    #             min = 1, max = 100, value = 30, step = 1),
    h6("Аналитика"),
    tags$text("В этом разделе ты можешь посмотреть оценку влияния кратковременного шока 
              на одно стандартное отклонение в одной переменной на другие.", fontsize = 20),
    tags$br(),
    tags$text("Технически это реализовано с помощью подсчета импульсного отклика 
              по обученной модели", fontsize = 20),
    tags$br(),
    tags$text("Для получения графиков выбери переменные, влияние которых ты хочешь учесть, 
              и одну или несколько целевых переменных.", fontsize = 20),
    tags$br(),
    tags$text("Если будет выбрано слишком много переменных, то график не получится отобразить. 
              Но в любом случае его можно скачать. Сначала на сервер, затем - себе на компьютер.", fontsize = 20),
    tags$br(),
    tags$br(),
    actionButton("show_text", "Показать список переменных"),
    
    fixedRow(
      column(7, verbatimTextOutput("hidden_text_1")),
      column(5, verbatimTextOutput("hidden_text_2"))
    ),
    tags$br(),
    
    fixedRow(
      column(4, checkboxGroupInput(inputId = "irf_from_1", 
                                   label = "Выбери переменные шока:", 
                                   choices = bvar_variables_1,
                                   selected = c(1, 2, 3))), 
      column(4, checkboxGroupInput(inputId = "irf_from_2", 
                                   label = " ", 
                                   choices = bvar_variables_2,
                                   selected = c())), 
      column(4, checkboxGroupInput(inputId = "irf_from_3",  
                                   label = " ",
                                   choices = bvar_variables_3,
                                   selected = c())),
    ), 
    fixedRow(
      column(4, checkboxGroupInput(inputId = "irf_to_1", 
                                   label = "Выбери принимающие переменные:", 
                                   choices = bvar_variables_1,
                                   selected = c())), 
      column(4, checkboxGroupInput(inputId = "irf_to_2", 
                                   label = " ", 
                                   choices = bvar_variables_2,
                                   selected = c())), 
      column(4, checkboxGroupInput(inputId = "irf_to_3",  
                                   label = " ",
                                   choices = bvar_variables_3,
                                   selected = c(17))),
    ), 
    actionButton("update", "Show IRF Plot"),
    plotOutput(outputId = "bvar_plot"),
    # downloadablePlotUI("bvar_plot", 
    #                    downloadtypes = c("png"), 
    #                    download_hovertext = "Download the plot here!",
    #                    height = "500px", 
    #                    btn_halign = "left"),
    actionButton("server_download", "Save IRF Plot to server"),
    downloadButton("download", class = "btn-block"),
    #dataTableOutput(outputId = "fancytable")
    tags$br(),
    tags$br(),
    tags$br()
  )

)