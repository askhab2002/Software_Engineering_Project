server <- function(input, output){
  thematic::thematic_shiny()
  # Загрузка данных по акциям с помощью пакета rusquant
  #----
  begin_data <- '2018-01-01'
  gazprom <- getSymbols.Moex("GAZP", market = "stock", engine = "stock", from = begin_data)
  rosn <- getSymbols.Moex("ROSN", market = "stock", engine = "stock", from = begin_data)
  lukoyl <- getSymbols.Moex("LKOH", market = "stock", engine = "stock", from = begin_data)
  gazprom_oil <- getSymbols.Moex("SIBN", market = "stock", engine = "stock", from = begin_data)
  surgut <- getSymbols.Moex("SNGS", market = "shares", engine = "stock", from = begin_data)
  
  output$plot1 <- renderPlot({
    #print("aaa")
    start_date <- toString((input$startDate))
    end_date <- toString((input$endDate))
    plot(gazprom$timestamp[gazprom$timestamp >= start_date & gazprom$timestamp <= end_date], 
         gazprom$close[gazprom$timestamp >= start_date & gazprom$timestamp <= end_date], 
         type = 'l', main = "Газпром, GAZP", 
         xlab = "timestamp", ylab = "price", col = 'cyan')
  })
  output$plot2 <- renderPlot({
    start_date <- toString((input$startDate))
    end_date <- toString((input$endDate))
    plot(rosn$timestamp[rosn$timestamp >= start_date & rosn$timestamp <= end_date], 
         rosn$close[rosn$timestamp >= start_date & rosn$timestamp <= end_date], 
         type = 'l', main = "Роснефть, ROSN", 
         xlab = "timestamp", ylab = "price", col = 'cyan')
  })
  output$plot3 <- renderPlot({
    start_date <- toString((input$startDate))
    end_date <- toString((input$endDate))
    plot(lukoyl$timestamp[lukoyl$timestamp >= start_date & lukoyl$timestamp <= end_date], 
         lukoyl$close[lukoyl$timestamp >= start_date & lukoyl$timestamp <= end_date], 
         type = 'l', main = "Лукойл, LKOH", 
         xlab = "timestamp", ylab = "price", col = 'cyan')
  })
  output$plot4 <- renderPlot({
    start_date <- toString((input$startDate))
    end_date <- toString((input$endDate))
    plot(gazprom_oil$timestamp[gazprom_oil$timestamp >= start_date & gazprom_oil$timestamp <= end_date], 
         gazprom_oil$close[gazprom_oil$timestamp >= start_date & gazprom_oil$timestamp <= end_date], 
         type = 'l', main = "Газпромнефть, SIBN", 
         xlab = "timestamp", ylab = "price", col = 'cyan')
  })
  output$plot5 <- renderPlot({
    start_date <- toString((input$startDate))
    end_date <- toString((input$endDate))
    plot(surgut$timestamp[surgut$timestamp >= start_date & surgut$timestamp <= end_date], 
         surgut$close[surgut$timestamp >= start_date & surgut$timestamp <= end_date], 
         type = 'l', main = "Сургутнефтегаз, SNGS", 
         xlab = "timestamp", ylab = "price", col = 'cyan')
  })
  #----  
  # Preparing data fo portfolio optimization:  
  #----
  d_g <- data.frame(timestamp = gazprom$timestamp, GAZP = gazprom$close)
  d_r <- data.frame(timestamp = rosn$timestamp, ROSN = rosn$close)
  d_l <- data.frame(timestamp = lukoyl$timestamp, LKOH = lukoyl$close)
  d_go <- data.frame(timestamp = gazprom_oil$timestamp, SIBN = gazprom_oil$close)
  d_s <- data.frame(timestamp = surgut$timestamp, SNGS = surgut$close)
  
  data <- d_g
  for(i in list(d_r, d_l, d_go, d_s)){
    data <- merge(data, i, by = "timestamp")
  }
  names_list <- c("timestamp", "GAZP", "ROSN", "LKOH", "SIBN", "SNGS")
  #----
  #Результаты оптимизации:
  #----
  
  output$tiker_1 <- renderText({
    portfolio <- as.numeric(c(input$portfolio))
    if(length(portfolio) < 1){
      return("")
    } else {
      return(names_list[portfolio[1]])
    }
  })
  output$tiker_2 <- renderText({
    portfolio <- as.numeric(c(input$portfolio))
    if(length(portfolio) < 2){
      return("")
    }
    else {
      return(names_list[portfolio[2]])
    }
  })
  
  output$tiker_3 <- renderText({
    portfolio <- as.numeric(c(input$portfolio))
    if(length(portfolio) < 3){
      return("")
    }
    else {
      return(names_list[portfolio[3]])
    }
  })
  output$tiker_4 <- renderText({
    portfolio <- as.numeric(c(input$portfolio))
    if(length(portfolio) < 4){
      return("")
    }
    else {
      return(names_list[portfolio[4]])
    }
  })
  output$tiker_5 <- renderText({
    portfolio <- as.numeric(c(input$portfolio))
    if(length(portfolio) < 5){
      return("")
    }
    else {
      return(names_list[as.numeric(portfolio)[5]])
    }
  })
  
  optimal_strategy <- reactive({
    portfolio <- as.numeric(c(input$portfolio))
    flag <- as.numeric(input$strategy)
    if(flag == 1) #Only long 
    {
      minriskSpec <- portfolioSpec()
      targetReturn <- 50
      setTargetReturn(minriskSpec) <- targetReturn
      minriskPortfolio <- efficientPortfolio(data = as.timeSeries(data[portfolio]),
                                             spec = minriskSpec,
                                             constraints = "LongOnly")
      
      weights = getWeights(minriskPortfolio)
      print(weights)
    }
    else if(flag == 2)#short
    {
      shortSpec <- portfolioSpec()
      setNFrontierPoints(shortSpec) <- 1
      setSolver(shortSpec) <- "solveRshortExact"  #
      shortFrontier <- portfolioFrontier(data = as.timeSeries(data[portfolio]), 
                                         spec = shortSpec,
                                         constraints = "Short")
      weights = getWeights( shortFrontier)
    }
    
    
    return(weights)
  })
  
  output$value_1 <- renderText({
    portfolio <- as.numeric(c(input$portfolio))
    if(length(portfolio) < 1){
      return(" ")
    } else {
      return(as.numeric(input$budget) * optimal_strategy()[1])
    }
  })
  output$value_2 <- renderText({
    portfolio <- as.numeric(c(input$portfolio))
    if(length(portfolio) < 2){
      return(" ")
    } else {
      return(as.numeric(input$budget) * optimal_strategy()[2])
    }
  })
  output$value_3 <- renderText({
    portfolio <- as.numeric(c(input$portfolio))
    if(length(portfolio) < 3){
      return(" ")
    } else {
      return(as.numeric(input$budget) * optimal_strategy()[3])
    }
  })
  output$value_4 <- renderText({
    portfolio <- as.numeric(c(input$portfolio))
    if(length(portfolio) < 4){
      return(" ")
    } else {
      return(as.numeric(input$budget) * optimal_strategy()[4])
    }
  })
  output$value_5 <- renderText({
    portfolio <- as.numeric(c(input$portfolio))
    if(length(portfolio) >= 5){
      return(as.numeric(input$budget) * optimal_strategy()[5])
    } else {
      return(" ")
    }
  })
  
  
  #----
  
  
  
  
  #Обучение BVAR
  #----
  #Ctrl + Shift + C - commenting
  output$progress <- renderText({
    "Модель не обучена"
  })
  
  test<-read.csv("C:/Users/user/Desktop/Универ/Прога/Наше приложение/data.csv")
  
  bvarm <- data.frame(brent = exp(diff(log(test$brent))) - 1,
                      sp500 = exp(diff(log(test$sp500))) - 1,
                      stoxx600 = exp(diff(log(test$stoxx600))) - 1,
                      sse = exp(diff(log(test$sse))) - 1,
                      kase = exp(diff(log(test$kase))) - 1,
                      usd_r = exp(diff(log(test$usd_r))) - 1,
                      eu_r = exp(diff(log(test$eu_r))) - 1,
                      c_r = exp(diff(log(test$c_r))) - 1,
                      r_kz = exp(diff(log(test$r_kz))) - 1,
                      pmi = exp(diff(log(test$pmi))) - 1,
                      U10b = exp(diff(log(test$U10b))) - 1,
                      R10b = exp(diff(log(test$R10b))) - 1,
                      R5b = exp(diff(log(test$R5b))) - 1,
                      R1b = exp(diff(log(test$R1b))) - 1,
                      moex_oil_gas = exp(diff(log(test$moex_oil_gas))) - 1,
                      moex = exp(diff(log(test$moex))) - 1,
                      rts = exp(diff(log(test$rts))) - 1)
  mn <- bv_minnesota(
        lambda = bv_lambda(mode = 0.2, sd = 0.4, min = 0.0001, max = 5), # Overall tightness
        alpha = bv_alpha(mode = 2, sd = 0.25, min = 1, max = 3), # Decay with increasing lag order
        psi = bv_psi(mode = rep(0.5, ncol(bvarm))), # Lags of other variables
        var = 1e07)
  
  prior <- bv_priors(hyper = "auto", mn = mn)
  mh <- bv_metropolis()
  N = 1000
  
  model <- bvar(bvarm, lags = 3, n_draw = N, n_burn = N / 3, n_thin = 1, # было 25000 и 10000
                priors = prior, mh = mh, verbose = TRUE)
  
  output$forecast_plot <- renderPlot({
    h <<- as.numeric(input$forecast)
    prObj <- predict(model,horizon = h)
    fcst <- apply(prObj$fcast, 2:3, median)
    rtsF <- fcst[,1]
    lastrts<-test$rts[1983]
    rts_forcast<-c()
    rts_forcast[1] <- lastrts * (1 + rtsF[1])
    for (k in 2:length(rtsF)){
      rts_forcast[k] <- rts_forcast[k-1] * (1 + rtsF[k])
    }
    #plot(ts(rts_forcast))
    #rts_real
    #rts_real<- tail(test$rts,20)
    
    test$Date <- as.Date(test$Date)
    q <- append(test$Date[as.integer(length(test$Date) - 200): as.integer(length(test$Date))],
                test$Date[as.integer(length(test$Date))]+1)
    r <- (test$rts[as.integer(length(test$Date)-200):as.integer(length(test$Date))])
    r  <-append(r,NA)
    for (k in 2:length(rts_forcast)){
      q <- append(q,test$Date[1983]+k)
      r <- append(r,NA)
    }
    plot(xts(r,order.by = q), ylim = c(min(min(rts_forcast),
                                           min(na.omit(r))),
                                       max(max(rts_forcast), 
                                           max(na.omit(r)))), 
         xlab = "Время", ylab = "Прогнозные значения", main="Прогноз Bvar", 
         col = "cyan", fontsize = 15)
    
    lines(xts(rts_forcast, order.by = test$Date[length(test$Date)]+1:(as.integer(length(rts_forcast)))),
          col = "darkviolet", lwd = 2, pips = NULL)
    
  })
  observeEvent(
    input$learning,
    {
        output$progress <- renderText({
          "Обучение..."
        })
        
        N = as.numeric(isolate(input$iterations))
        
        model <- bvar(bvarm, lags = 3, n_draw = N, n_burn = N / 3, n_thin = 1, # было 25000 и 10000
                      priors = prior, mh = mh, verbose = TRUE)
        
        output$forecast_plot <- renderPlot({
          h <<- as.numeric(input$forecast)
          prObj <- predict(model,horizon = h)
          fcst <- apply(prObj$fcast, 2:3, median)
          rtsF <- fcst[,1]
          lastrts<-test$rts[1983]
          rts_forcast<-c()
          rts_forcast[1] <- lastrts * (1 + rtsF[1])
          for (k in 2:length(rtsF)){
            rts_forcast[k] <- rts_forcast[k-1] * (1 + rtsF[k])
          }
          
          test$Date <- as.Date(test$Date)
          q <- append(test$Date[as.integer(length(test$Date) - 200): as.integer(length(test$Date))],
                      test$Date[as.integer(length(test$Date))]+1)
          r <- (test$rts[as.integer(length(test$Date)-200):as.integer(length(test$Date))])
          r  <-append(r,NA)
          for (k in 2:length(rts_forcast)){
            q <- append(q,test$Date[1983]+k)
            r <- append(r,NA)
          }
          plot(xts(r,order.by = q), ylim = c(min(min(rts_forcast),
                                                 min(na.omit(r))),
                                             max(max(rts_forcast), 
                                                 max(na.omit(r)))), 
               xlab = "Время", ylab = "Прогнозные значения", main="Прогноз Bvar", 
               col = "cyan", fontsize = 15)
          
          lines(xts(rts_forcast, order.by = test$Date[length(test$Date)]+1:(as.integer(length(rts_forcast)))),
                col = "darkviolet", lwd = 2, pips = NULL)
          #plot(ts(rts_forcast),col = "red",xlab="Время",ylab="Прогнозные значения",main="Прогноз Bvar")
          
          
        })
        output$progress <- renderText({
          "Обучение завершено"
        })
        
    }
  )
      
  observeEvent(input$show_text, {
    output$hidden_text_1 <- renderText({
      paste("Индексы:",
        "ММВБ (moex) - рублевый аналог РТС",
        "Moex Oil-Gas Index (moex_oil_gas) - индекс нефтегазовой отрасли",
        "PMI (pmi) - индекс деловой активности",
        "S&P500 (sp500) - 500 крупнейших в США",
        "Euro Stoxx 600 (stoxx600) - крупнейшие в ЕС", 
        "KASE (kase) - индекс биржи Казахстана",
        "Shanghai Composite (sse) - индекс Шанхайской биржи", sep = "\n")
        
    })
    output$hidden_text_2 <- renderText({
      paste(
        "Курсы валют:",
        "USD, EUR и CNY к RUB и RUB/KZT",
        "Облигации:",
        "ОФЗ РФ сроком 1, 5 и 10 лет",
        "ОФЗ США сроком 10 лет",
        "Самое главное:",
        "Нефть марки Brent",
        sep = "\n"
      )
    })
  })    
  
  
  
  #----
  #Отображение графиков IRF
  #-----
  
  observeEvent(
    input$update,
    {
      birf <- irf(model)
      output$bvar_plot <- renderPlot({
        impulses = c(isolate(input$irf_from_1),isolate(input$irf_from_2), 
                     isolate(input$irf_from_3))
        responses = c(isolate(input$irf_to_1),isolate(input$irf_to_2), 
                      isolate(input$irf_to_3))
        impulses = as.numeric(impulses)
        responses = as.numeric(responses)
        plot(birf, vars_impulse = impulses,
             vars_response = responses, col = 'cyan', area = TRUE, fill = "cyan")
      })
    }
  )
  
  
  observeEvent(
    input$server_download,
    {
      impulses <<- c(isolate(input$irf_from_1),isolate(input$irf_from_2),
                     isolate(input$irf_from_3))
      responses <<- c(isolate(input$irf_to_1),isolate(input$irf_to_2),
                      isolate(input$irf_to_3))
      #Собираем имя файла
      s_i <<- impulses[1]
      if(length(impulses) > 1){
        for(i in 2:length(impulses)){
          s_i <<- paste(s_i, impulses[i], sep = ".")
        }
      }
      s_r <<- responses[1]
      if(length(responses) > 1)
      {
        for(i in 2:length(responses)){
          s_r <<- paste(s_r, responses[i], sep = ".")
        }
      }
      
      # JPEG device
      jpeg(paste("impulse_", s_i, "_response_", s_r, ".jpeg", sep = ""), 
           width = 700 * length(impulses),
           height = 600 * length(responses))
      #Code
      impulses = as.numeric(impulses)
      responses = as.numeric(responses)
      plot(birf, vars_impulse = impulses,
           vars_response = responses, col = 'cyan', area = TRUE, fill = "cyan")
      # Close device
      dev.off()
    }
  )
  
  output$download <- downloadHandler(
    filename = "impulse_responses.jpeg",
    content = function(file){
      file.copy(paste("impulse_", s_i, "_response_", s_r, ".jpeg", sep = ""), file)
    },
    contentType = "jpeg"
  )
  #----
  
}

