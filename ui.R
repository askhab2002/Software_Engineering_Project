ui <- navbarPage(
  theme = bs_theme(bootswatch = "cyborg"),
  
  "Проект по С++",
  
  tabPanel(
    "Трейдинг", 
    tradingPageLayout),
  
  tabPanel(
    "Инвестиции",
    investPageLayout)
)