tradingPageLayout <- sidebarLayout(
  sidebarPanel = sidebarPanel(
    #style = "position:fixed;width:inherit;",
    
    #tags$h3("Sidebar"), 
    
    
    
    width = 1
  ),
  
  mainPanel = mainPanel(
    
    h2("Краткосрочная торговля"),
    tags$text("Привет!", fontsize = 20),
    tags$br(),
    tags$text("Эта страница приложения поможет определиться с выбором портфеля для
            краткосрочной торговли.", fontsize = 20),
    tags$br(),
    tags$text("Для демонстрации выбран нефтегазовый сектор и 5 
            крупнейших по капитализации компаний.", fontsize = 20),
    tags$br(),
    tags$text("Ниже можно посмотреть динамику цены за разные промежутки времени, выбрать те
            из пяти активов, которые наиболее интересны, стратегию торгов и начальный 
            бюджет портфеля.", fontsize = 20),
    tags$br(),
    tags$br(),
    
    #textOutput("trading_intro"),
    
    h5("Акции топ-5 по капитализации компаний нефтегазового сектора в России"), 
    tags$br(),
    fluidRow(
      column(4, plotOutput(outputId = "plot1")), 
      column(4, plotOutput(outputId = "plot2")), 
      column(4, plotOutput(outputId = "plot3"))
    ), 
    fixedRow(
      column(2),
      column(2, "Показать с: ", align = "center"),
      column(2, dateInput(inputId = "startDate",
                          label = NULL,
                          value = '2022-01-01',
                          min = '2018-01-01',
                          format = "yyyy-mm-dd",
                          weekstart = 1)), 
      column(1, "по: ", align = "center"),
      column(2, dateInput(inputId = "endDate",
                          label = NULL,
                          value = '2023-12-31',
                          min = '2018-01-01',
                          format = "yyyy-mm-dd",
                          weekstart = 1))
    ),
    fluidRow(
      column(6, plotOutput(outputId = "plot4")), 
      column(6, plotOutput(outputId = "plot5"))
    ),
    h5("Подход к оптимизации"),
    tags$text("В этом разделе представлена оптимизация долей (весов) активов в рамках инвестиционного 
              портфеля ограниченного топом нефтегазового сектора. Оптимизация осуществляется 
              при помощи модификации модели в рамках портфельной теории Марковица.", fontsize = 20),
    tags$br(),
    tags$text("Доступно два режима - только покупка (Long) и покупка с продажей (Short & long).", fontsize = 20),
    tags$br(),
    tags$text("Для long стратегии вычисляем эффективный портфель среднего-дисперсионного (mean-variance) соотношения 
              с наименьшим риском для заданной доходности. Она определена как оптимальный минимум
              границы эффективных портфелей, т.е. для работы алгоритма это минимальное значение targetReturn. 
              По умолчанию он равен 50", fontsize = 20),
    tags$br(),
    tags$text("Для смешанной стратегии можно провести аналитическую оптимизацию, 
              установив \"box constraints\" с расширенными нижними и верхними пределами.", fontsize = 20),
    
    tags$br(),
    tags$br(),
    h5("Оптимальные веса:"),
    checkboxGroupInput(inputId = "portfolio", 
                       label = "Выбери свой портфель:",
                       choices = portfolioSelector,
                       selected = c(5, 6),
                       inline = TRUE),
    fixedRow(
      column(4, textInput(inputId = "budget", 
                            label = "Начальный капитал портфеля:", 
                          value = "100")),
      column(4, selectInput(inputId = "strategy", 
                            label = "Стратегия:",
                            choices = choicesForStrategy)),
      # column(4, selectInput(inputId = "solver", 
      #                       label = "Choose the solver:", 
      #                       choices = choicesForSolver))
    ),
    
    tags$text("Оптимальные веса:"),
    fixedRow(
      column(2, textOutput("tiker_1")),
      column(2, textOutput("tiker_2")),
      column(2, textOutput("tiker_3")),
      column(2, textOutput("tiker_4")),
      column(2, textOutput("tiker_5")),
    ),
    fixedRow(
      column(2, textOutput("value_1")),
      column(2, textOutput("value_2")),
      column(2, textOutput("value_3")),
      column(2, textOutput("value_4")),
      column(2, textOutput("value_5")),
    ),
    textOutput(outputId = "names"),
    textOutput(outputId = "optimal_weights"),
    # dataTableOutput(outputId = "fancytable")
    tags$br(),
    tags$br(),
    tags$br(),
    tags$br(),
    width = 10
    
  )
  
) 
