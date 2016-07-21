library(shiny)
library(googleVis)
shinyUI(navbarPage("Climate Forecasting",
                   tabPanel("Introduction",
                            sidebarLayout(
                            sidebarPanel(helpText(p(strong(h3("Team Member:"))),
                                                  p("Hanwen Gao"),
                                                  p("Jiashen Liu"),
                                                  p("Jiale Sun"),  
                                                  p("Rico Ngo"))
                                         
                                         
                                         ),
                            mainPanel(
                              h3(strong("Background")),
                              p("Due to the relatively rapid rise of global temperatures during 1980-1995, 
global warming is considered a potential threat to society. Man-made carbon-dioxide (CO2) emission is indicated as main culprit. To counter the potential threat, the Intergovernmental Panel on Climate
                                Change (IPCC) was installed by the United Nations to nd empirical evidence for man-made
                                global warming, assess the impacts of global warming on the Earth's eco-systems, formulate
                                policies to mitigate these impacts, and disseminate its nding in a four-annual report. The
                                latest installment of these reports is the Fifth Assessment Report, or AR5, accompanied by a
                                Summary for Policy-makers'. According to AR5 (IPCC, 2014, page 48):",align="Justify"),
                              p(em("'The evidence for human in
uence on the climate system has grown since AR4.
                                Human in
                                uence has been detected in warming of the atmosphere and the ocean,
                                in changes in the global water cycle, in reductions in snow and ice, and in global
                                mean sea-level rise; and it is extremely likely to have been the dominant cause of the
                                observed warming since the mid-20th century.'"),align="Justify"),
                              br(),
                              h3(strong("Historical Temperature Data")),
                              htmlOutput("plot1"))
                            )
                   ),
                   navbarMenu("Natural Process Forecasting",
                              tabPanel("El Nino",
                                       sidebarLayout(
                                         sidebarPanel(
                                           helpText(h3(strong("Choose the forecasting horizon"))),
                                           br(),
                                           radioButtons("yr1","Forecasting Horizon",choices = c("25 Years"=1,"50 Years"=2,"100 Years"=3),selected = 1)
                                             ),
                                         mainPanel(
                                           strong(h3("Forecasting Methodology")),
                                           br(),
                                           p("Although human being will have a huge impact on global climate, several natural factors may also influence the temperature. Therefore, there is no natural equilibrium state for the temperature. Based on numerous scientific literatures, the temperature will be partially judged by several factors such as El Nino effects, solar activity and Atlantic multidecadal oscillation. Those natural factors can be hardly influenced by human activities. Due to this reason, one can implement time-series forecasting method for predictive analytics.",align="Justify"),
                                           p("The El Nino effect is a periodical climate phenomenon that can exert profound influence on the global climate. The estimated cycle of it is from 2 to 7 years. The current data has an El Nino indicator that can be traced back to 1960. With a frequency of 5 years in the time series, we predict the El Nino indicators of the next 100 years by implementing additive Holt winter forecasting method. Meanwhile, in order to maintain a better data integrity for the predictive analytic on global temperature, we implement the same method reversely for the missing values of El Nino factors before 1960. Due to some reasons (i.e. Human activity), the general trend of El Nino effect is amplified with time. However, the cycle of El Nino effect has been observed, making the effect predictable.",align="Justify"),
                                           br(),
                                           strong(h3("Forecasting Result")),
                                           htmlOutput("plot2"),
                                           strong(h3("Fitness of Model")),
                                           tableOutput("Accuracy1")
                                           )
                                       )),
                              tabPanel("Atlantic Multidecadal Oscillation",
                                       sidebarLayout(
                                         sidebarPanel(
                                           helpText(h3(strong("Choose the forecasting horizon"))),
                                           br(),
                                           radioButtons("yr2","Forecasting Horizon",choices = list("25 Years"=1,"50 Years"=2,"100 Years"=3),selected = 1)
                                           ),
                                         mainPanel(
                                           strong(h3("Forecasting Methodology")),
                                           br(),
                                           p("Another identified climate phenomenon is Atlantic multidecadal oscillation, which is believed to have impact on global climate change. The AMO is identified in 1994 by Schlesinger and Ramankutty, and can be quantified as the form of numeric indicator. The scientist believe that the AMO has a relatively long cycle (70 years). Therefore, it is possible to implement time series forecasting technique to perform the predictive analytics. According to the data decomposition, we incline to implement STL forecasting method (applying a non-seasonal forecasting method to the seasonally adjusted data and re-seasonalizing using the last year of the seasonal component) together with simple exponential smoothing method. In other word, the forecasting method is a combination of two independent methods.",align="Justify"),
                                           strong(h3("Forecasting Result")),
                                           htmlOutput("plot3"),
                                           strong(h3("Fitness of Model")),
                                           tableOutput("Accuracy2")
                                           )
                                       )),
                              tabPanel("Solar Activity",
                                       sidebarLayout(
                                         sidebarPanel(
                                           helpText(h3(strong("Choose the forecasting horizon"))),
                                           br(),
                                           radioButtons("yr3","Forecasting Horizon",choices = list("25 Years"=1,"50 Years"=2,"100 Years"=3),selected = 1)
                                         ),
                                         mainPanel(
                                           strong(h3("Forecasting Methodology")),
                                           p("Our planet is powered by the Sun, and this inhabitable climate is also a gift from this great star. Therefore, it is normal that the climate can be influenced by solar activity. The solar activity is also periodical, which means human can foresee it happening and prepare for the potential climate change it may bring to the Earth. The sun is far away from us, which means the solar activity will not be influenced by human being. Also, although the Sun is aging, the intrinsic change of it will not manifest with hundreds of years. Knowing the cycle of solar activity is 4 years, we implement additive Holt winter method to predict its activity within a hundred years.",align="Justify"),
                                           br(),
                  
                                           strong(h3("Forecasting Result")),
                                           htmlOutput("plot4"),
                                           strong(h3("Fitness of Model")),
                                           tableOutput("Accuracy3")
                                         )
                                       ))
                              ),
                   navbarMenu("Forecasting CO2 Level",
                              tabPanel("Introduction",
                                       sidebarLayout(
                                         sidebarPanel(
                                           radioButtons("opy","Data Visulization Option",choices=list("2000"=1,"2011"=2))
                                         ),
                                         mainPanel(
                                           strong(h3("Introduction")),
                                           p("Carbon-dioxide is usually referred to as one of the so-called greenhouse gases. Therefore, the concentration of carbon-dioxide in the air is a key determinant of global warming. After the industrial revolution, human learns how to exploit the power in fossil fuels to improve the efficiency of the society. While the quality of our lives is improving, the burning of fossil fuels produces a huge amount of greenhouse gases, leading to an increase in global temperature. Therefore, when forecasting the global climate, the predictive analytics on the concentration of carbon-dioxide will be the key.",align="Justify"),
                                           p("Based on the current literature, scientists believe that the level of human-produced CO2 is largely dependent on two variables: the energy consumption and the population on this planet. A regression model incorporating these two variables can be applied. However, before start predicting the concentration of CO2, the forecasting should first be applied on two variables.",align="Justify"),
                                           br(),
                                           strong(h3("Co2 Emission by Country")),
                                           htmlOutput("geop")
                                         )
                                       )
                                   ),
                              tabPanel("Population",
                                       sidebarLayout(
                                         sidebarPanel(
                                           strong(h3("Choose the phase in forecasting method")),
                                           radioButtons("ph","Phase",choices=list("Phase 1 (Until 2050"=1,"All Time"=2),selected = 1)
                                         ),
                                       mainPanel(strong(h3("Forecasting Methodlogy ")),
                                       p("The population of the World keeps expanding since the industrial revolution. The positive effect of the enhanced production capability prolong life expectancy of human being, and the advancement in medical techniques hugely reduce the infant mortality rate globally. In the near further, the medical technology will continue to evolve. Correspondingly, the population will keep growing.",align="Justify"),
                                       p("However, it is impractical to have the population grow at a constant rate. The resources of this planet are limited, and most of them are not renewable. Furthermore, the ecosystem will also play a role on population growth, which means the growth rate will not always be kept on a high level. Based on the World Population Prospect (2015), we can develop a quantitative model for the forecasting of population. It is obvious that the population will keep growing, but the growth rate will be decreased periodically in the further. ",align="Justify"),
                                      strong(h3("Forecasting Result")),
                                      htmlOutput("plot5"))
                                      )),
                              tabPanel("Energy (CO2 per Capita)",
                                       sidebarLayout(
                                         sidebarPanel(
                                           helpText(h3(strong("Choose Scenario"))),
                                           radioButtons("sc1","Scenarios",choices = list("Worst"=1,"Medium"=2,"Best"=3),selected = 1),
                                           checkboxInput("all1","Display All Scenarios?",value = T)
                                           ),
                                         mainPanel(
                                           strong(h3("Forecasting Methodlogy")),
                                           p("Another variable that plays an important role in the forecasting of CO2 level is the energy consumption of human being. Before the clean energy being exploited, the energy consumption of human being is always positively correlated with the concentration of CO2 in atmosphere. However, in 21st century, the clean energy has been speedily developed, and more energy consumption is not equal to the CO2 emission any more. Therefore, we use another index, CO2 production per capita, to represent the consumption of fossil fuels. Since the development of clean energy cannot be quantitatively predicted, we qualitatively divide the prediction into three scenario.",align="Justify"),
                                           strong(h3("Debriefing Scenario")),
                                           h5(textOutput("text2"),align="Justify"),
                                           strong(h3("Forecasting Result")),
                                           htmlOutput("plot6"),
                                           strong(h3("Fitness of Model")),
                                           tableOutput("Accuracy8")
                              
                                         )
                                       ))
                              ,
                              tabPanel("Co2 Forecasting",
                                       sidebarLayout(
                                         sidebarPanel(
                                           radioButtons("sc2","Scenarios",choices = list("Worst"=1,"Medium"=2,"Best"=3),selected = 1),
                                           checkboxInput("All2","Display All Scenarios?",value = T)
                                         ),
                                         mainPanel(
                                           strong(h3("Forecasting Methodlogy")),
                                           p("With the forecasting values of population and CO2 emission per capita, we can further forecast the CO2 emission in the next 100 years. Since the amount of CO2 emission is dependent on these two variables, a regression model can be built to implement the predictive analytics.",align="Justify"),
                                           p(strong("CO2~ Population+CO2 per Capita"),align="Center"),
                                           p("Then the CO2 emission of next 100 years can be predicted based on three scenarios of global energy consumption.",align="Justify"),
                                           strong(h3("Debriefing Scenario")),
                                           h5("Then the CO2 emission of next 100 years can be predicted based on three scenarios of global energy consumption. Due to the inevitable growth in population, the emission of CO2 will increase in all three scenarios.. In the first 25 years, the differences in CO2 emission in three scenarios are not quite obvious.However, the difference will be amplified with time flowing. The gaps between scenarios will keep widening in the long term. Therefore, one can conclude that the effect of clean energy development and environmental initiatives of human being  will have a huge impact on the amount of greenhouse gases.",align="Justify"),
                                           strong(h3("Forecasting Result")),
                                           htmlOutput("plot7"),
                                           strong(h3("Fitness of Model")),
                                           tableOutput("Accuracy6")
                                         )
                                       ))),
                   tabPanel("Forecasting the Climate",sidebarLayout(
                     sidebarPanel(
                   radioButtons("sc3","Scenarios",choices = list("Worst"=1,"Medium"=2,"Best"=3),selected = 1),
                   checkboxInput("All3","Display All Scenarios?",value=T)
                     ),
                     mainPanel(
                       strong(h3("Intepretation")),
                       p("After predicting the variables that can influence the global temperature separately, a regression model can be built to perform the forecasting on the global temperature for the subsequent 100 years:",align="Justify"),
                       p(strong("Temperature~ LogCO2+AMO+NINO"),align="Center"),
                       p("The three hypothetical scenarios we mentioned for the CO2 level will directly influence the temperature in the near future. Specifically, in the worst scenario, the annual CO2 emission keep surging, making the global temperature increasing constantly. The temperature will also increase in the medium scenario, but the extent of increase is smaller. In case of the ideal situation, the rate of increasing will be not quite distinct, leading to a climate with relatively stable temperature. Another hypothesis we make about the global temperature is that the human impact on the temperature will show the power of accumulation. In the first 25 years, the predicted temperatures are almost the same in all three scenarios. However, the gaps between scenarios are widening over time, explaining the hypothesis that there is a 'lead time' between the actual temperature change and the emission of greenhouse gases. The hypothetical power of accumulation is realized by adding adjustment numbers in forecasting values.",align="Justify"),
                       strong(h3("Forecasting Result")),
                       htmlOutput("plot8"),
                       strong(h3("Fitness of Model")),
                       tableOutput("Accuracy7")
                     )
                   ))
                   ,
                   tabPanel("Final Conclusion",
                            strong(h3("Comparison with IPCC")),
                            p("The above section presented three different scenarios that predict the direct influence of CO2 on the temperature. This section will compare the results obtained in previous section with the IPCC results. ",align="Justify"),
                            h4("Worst Scenario (A2 in IPCC)"),
                            p("IPCC climate forecast predicted that CO2 concentration and temperature were expected to rise sharply in next 100 years due to the rapid economic growth and lack of environmental awareness from human side. The temperature will finally reach to 17.8 degrees. This prediction is similar to our predicted models that the CO2 emission and temperature will keep surging in next 100 years. However, the increase of CO2 emission and temperature in our model will not be as rapid as IPCC predicted. We predicted that the temperature would finally reach to 16.2 degrees. The possible reason was that not all the people would pursue their personal wealth rather than environmental quality. The rapid economic growth in the future will ultimately enable most of people to invest more money on developing more sustainable technology and therefore solve the environmental issue (even in the worst scenario). This can also explain that the CO2 emission and temperature will be decreased after 100 years.",align="Justify"),
                            h4("Medium Scenarios (B1 in IPCC)"),
                            p("IPCC climate forecast predicted that CO2 concentration and temperature were expected to rise but not as sharp as the worst scenario as the traditional economy will be shifted to the circular economy in the future. The temperature will finally reach to 16.1 degrees. The prediction from IPCC was similar to our prediction models. Through our prediction models, we also suggested that the traditional economy will be shifted to the green economy, it is an economy that will allow the business to pay more attention to the green business growth, which pursues the balanced goal of maximizing the economy growth of the company while enhancing the energy and resources efficiency. We predicted that the temperature would finally reach to 16.7 degrees.",align="Justify"),
                            h4("Best Scenario (Commit in IPCC)"),
                            p("IPCC climate forecast predicted that CO2 concentration and temperature were expected to be slightly increased in next 100 years due to fixed burdens of long-lived greenhouse gases. This is similar to our model that the temperature and CO2 emission will not have sharp increase trend as other two scenarios. However, we also predict that the temperature and CO2 emission will finally be decreased after 100 years. ",align="Justify"),
                            
                            strong(h3("Recommendations")),
                            p("From our model, it can be concluded that our model predicted three different scenarios about increase of the global temperature. In first 25 years, the predicted temperature is almost same in three scenarios. Afterwards, the temperature gap will be widening overtimes but all three scenarios predicted that the CO2 emission and temperature would ultimately increase over time. We also made comparison between our model and IPCC forecast and found that the temperature results obtained from model are lower than IPCC predicted. The possible reason is that the people will ultimately realize the importance of environment in all three scenarios and they will spend huge amount of money on solving environmental issues. This can also explain the temperature will be decreased after 100 years in three scenarios. ",align="Justify"),
                            br(),
                            p("In addition, the model shows different CO2 emission levels can bring significant difference to the temperature, and also that the CO2 emission is mainly caused by human beings. Therefore, we recommend the Dutch ministries to develop more affordable and sustainable civilian energy. Besides, although not shown in our prediction model, it is also useful if government tries to control population growth in an appropriate way. For natural phenomena, we still have little information on whether factors such as Nino effect can be affected by human beings. Therefore, we recommend to first study whether human beings can influence these phenomena. If the influence exists, it is important to study the real linkage between human beings and natural phenomena. Only after this, further recommendations related to natural phenomena can be made. ",align="Justify"),
                            br(),
                            p("Based on the report, it is recommended that the Dutch ministries take into account the three possible forecasted scenarios. Each scenario requires a different approach, which makes it important for the Dutch ministries to determine which scenario is more likely to happen.  Therefore, the Dutch ministries should follow the main trends and events that are likely to influence the outcomes of the forecasted scenario. For example, if human green initiatives are increasing and becoming more successful, then the Dutch ministries should depends its current decision making process and approach for the future on a scenario that the global average temperature will decrease. ",align="Justify")),
                   navbarMenu("Appendix",
                              tabPanel("Raw Data",
                           dataTableOutput("table")
                                       ),
                              tabPanel("Forecasting By IPCC",
                                       strong(h2("IPCC Forecasting Result")),
                                       p(h3(em("Below presents the forecasting of climate provided by IPCC. One can observe that IPCC hypothetically create three scenarios for the forecasting. The climate change is somewhat up to human's environmental initiative.")),align="Justify"),
                                       htmlOutput("IPCC")))
        
))