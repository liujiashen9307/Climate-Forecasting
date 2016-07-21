library(shiny)
library(googleVis)
climate<-read.csv("climate.csv")
NINO<-read.csv("NINO.csv")
AMO<-read.csv("AMO.csv")
Solar<-read.csv("Solar.csv")
ACCU<-read.csv("Accuracy.csv")
Popu<-read.csv("PopulationF.csv")
CO2PC<-read.csv("CO2.csv")
LogCO2<-read.csv("LogCO2.csv")
TempF<-read.csv("Forecast.csv")
CO2HS<-read.csv("CO2HS.csv")
ACCU2<-read.csv("ACCU2.csv")
shinyServer(function(input,output,session){
  output$plot1<-renderGvis({
    gvisLineChart(climate[seq(1,136),c(1,2)],xvar="Year",yvar="Temperature",options=list(width=900, height=450, size='large', allowCollapse=TRUE))
  })
  
  output$Accuracy1<-renderTable({
    ACCU[1,c(2,3,4,5,6)]
  })
  output$plot2<-renderGvis({
    if(input$yr1==1){
      DT<-NINO[1:161,c(2,3,4,7,8)]
      colnames(DT)<-c("Year","NINO Historical","Forecasting","Reverse Forecasting","Fit")
    }
    if(input$yr1==2){
      DT<-NINO[1:186,c(2,3,5,7,8)]
      colnames(DT)<-c("Year","NINO Historical","Forecasting","Reverse Forecasting","Fit")
    }
    if(input$yr1==3){
      DT<-NINO[,c(2,3,6,7,8)]
      colnames(DT)<-c("Year","NINO Historical","Forecasting","Reverse Forecasting","Fit")
    }
    gvisLineChart(DT,xvar="Year",yvar=c("NINO Historical","Forecasting","Reverse Forecasting","Fit"),options=list(width=900, height=450, size='large', allowCollapse=TRUE))
  })
  
  output$plot3<-renderGvis({
    
    if(input$yr2==1){
      DT1<-AMO[1:161,c(2,3,4,7)]
      colnames(DT1)<-c("Year","AMO Historical","Forecasting","Fit")
    }
    if(input$yr2==2){
      DT1<-AMO[1:186,c(2,3,5,7)]
      colnames(DT1)<-c("Year","AMO Historical","Forecasting","Fit")
    }
    if(input$yr2==3){
      DT1<-AMO[,c(2,3,6,7)]
      colnames(DT1)<-c("Year","AMO Historical","Forecasting","Fit")
    }
    gvisLineChart(DT1,xvar="Year",yvar=c("AMO Historical","Forecasting","Fit"),options=list(width=900, height=450, size='large', allowCollapse=TRUE))
  })
  output$Accuracy2<-renderTable({
    ACCU[2,c(2,3,4,5,6)]
  })
  output$Accuracy3<-renderTable({
    ACCU[3,c(2,3,4,5,6)]
  })
  output$plot4<-renderGvis({
    if(input$yr3==1){
      DT2<-Solar[1:161,c(2,3,4,7)]
      colnames(DT2)<-c("Year","Solar Historical","Forecasting","Fit")
    }
    if(input$yr3==2){
      DT2<-Solar[1:186,c(2,3,5,7)]
      colnames(DT2)<-c("Year","Solar Historical","Forecasting","Fit")
    }
    if(input$yr3==3){
      DT2<-Solar[,c(2,3,6,7)]
      colnames(DT2)<-c("Year","Solar Historical","Forecasting","Fit")
    }
    gvisLineChart(DT2,xvar="Year",yvar=c("Solar Historical","Forecasting","Fit"),options=list(width=900, height=450, size='large', allowCollapse=TRUE))
    
  })
  output$table<-renderDataTable({
    climate
  })
  output$IPCC<-renderGvis({
    IPCC<-climate[,c(1,2,7,8,9,10)]
    names(IPCC)<-c("Year","Temperature","Fit","Commit","B1","A2")
    gvisLineChart(IPCC,xvar="Year",yvar=c("Temperature","Fit","Commit","B1","A2"),options=list(width=1400, height=700, size='large', allowCollapse=TRUE))
  })
  output$plot5<-renderGvis({
    if(input$ph==1){
      DT<-Popu[1:71,c(2,3,4)]
    }else{
      DT<-Popu[,c(2,3,4)]
    }
    gvisLineChart(DT,xvar="Year",yvar=c("Population","Forecasting"),options=list(width=900, height=450, size='large', allowCollapse=TRUE))
  })  
  output$plot6<-renderGvis({
    if(input$all1!=T){
      if(input$sc1==1){
        DT<-CO2PC[,c(2,3,4,7)]
        colnames(DT)<-c("Year","Historical","Forecasting","Fit")
      }
      if(input$sc1==2){
        DT<-CO2PC[,c(2,3,6,7)]
        colnames(DT)<-c("Year","Historical","Forecasting","Fit")
      }
      if(input$sc1==3){
        DT<-CO2PC[,c(2,3,5,7)]
        colnames(DT)<-c("Year","Historical","Forecasting","Fit")
      }
      gvisLineChart(DT,xvar="Year",yvar=c("Historical","Forecasting","Fit"),options=list(width=900, height=450, size='large', allowCollapse=TRUE))
    }else{
      gvisLineChart(CO2PC,xvar="Year",yvar=c("Original","Worst","Medium","Best","Fit"),options=list(width=900, height=450, size='large', allowCollapse=TRUE))
    }
  })
  output$plot7<-renderGvis({
    if(input$All2==F){
      if(input$sc2==1){
        DT<-LogCO2[,c(2,3,4,7)]
        colnames(DT)<-c("Year","Historical","Forecasting","Fit")
      }
      if(input$sc2==2){
        DT<-LogCO2[,c(2,3,5,7)]
        colnames(DT)<-c("Year","Historical","Forecasting","Fit")
      }
      if(input$sc2==3){
        DT<-LogCO2[,c(2,3,6,7)]
        colnames(DT)<-c("Year","Historical","Forecasting","Fit")
      }
      gvisLineChart(DT,xvar="Year",yvar=c("Historical","Forecasting","Fit"),options=list(width=900, height=450, size='large', allowCollapse=TRUE))
    }else{
      gvisLineChart(LogCO2,xvar="Year",yvar=c("Historical_Data","Worst","Medium","Best","Fit"),options=list(width=900, height=450, size='large', allowCollapse=TRUE))
    }
  })
  output$plot8<-renderGvis({
    if(input$All3==F){
      if(input$sc3==1){
        DT<-TempF[,c(2,3,4,7)]
        colnames(DT)<-c("Year","Temperature","Forecasting","Fit")
      }
      if(input$sc3==2){
        DT<-TempF[,c(2,3,5,7)]
        colnames(DT)<-c("Year","Temperature","Forecasting","Fit")
      }
      if(input$sc3==3){
        DT<-TempF[,c(2,3,6,7)]
        colnames(DT)<-c("Year","Temperature","Forecasting","Fit")
      }
      gvisLineChart(DT,xvar="Year",yvar=c("Temperature","Forecasting","Fit"),options=list(width=900, height=450, size='large', allowCollapse=TRUE))
    }else{
      gvisLineChart(TempF,xvar="Year",yvar=c("Temperature","Worst","Medium","Best","Fit"),options=list(width=900, height=450, size='large', allowCollapse=TRUE))
    }
  })
output$geop<-renderGvis({
  if(input$opy==1){
    DT<-CO2HS[,c(1,3)]
    colnames(DT)<-c("Country","CO2 Emission")
  }
  if(input$opy==2){
    DT<-CO2HS[,c(1,2)]
    colnames(DT)<-c("Country","CO2 Emission")
  }
  gvisGeoMap(DT, locationvar = "Country", numvar = "CO2 Emission",options=list(width=900, height=450, size='large', allowCollapse=TRUE))
})



output$text2<-renderText({
  if(input$sc1==1){
    text<-"Observing the historical data of CO2 emission per capita, one can find that the increase in the value is somehow periodical. From 1960s to 1980s, the consumption of CO2 per capita increased. Reviewing the history of that period, we can assume that the surge of economy in Europe and North America leads to the increase in the energy consumption. Then the CO2 consumption per capita was stable for 20 years, then another surge happened. The possible reason was the development in Asia, especially for the BRICs countries in the first decade of 21st century. Although the data may not be sufficient to judge the cycle of human development, one can assume that every 40 years some countries in the world will develop speedily for 20 years, and subsequently the energy consumption will be stable for another 20 years until the other countries find a path to a booming economy. In the worst scenario, we hypothetically believe that the development of human society follows the same pattern as we observe while the people neither invest in clean energy nor have enough environmental initiatives. As a result, we simple implement additive Holt winter method (which fits well with the historical data) to obtain the predicted CO2 emission per capita values."
  }
  if(input$sc1==2){
    text<-"However, the real situation probably will not be that pessimistic. Although the development of some countries will still accelerate the consumption of energy, the advancement in the clean energy will mitigate the negative impact of development on the environment. In the near further, the energy consumption per capita will keep increasing, but the proportion of fossil fuels in the energy will be lower, which makes the CO2 emission per capita level off at a certain level. The less dependency on the fossil fuels will slow down the increase of greenhouse gases in the atmosphere. However, due to the growth in population, the total amount of CO2 emission probably will increase with a relatively smaller growth rate. In this case, we cut the part of increasing trend in the forecasting values from the Holt winter method so that the level of CO2 emission per capita will be stable at a certain level."
  }
  if(input$sc1==3){
    text<-"Previously, we probably underestimate the environmental initiative of human being. In the near further, the threaten of global warming may alarmingly raise the awareness of people. Therefore, people will deliberately control the usage of fossil fuels. The life of human being will be increasingly driven by the clean energy, which reduce the emission of CO2. Meanwhile, from the industrial level, scientists may be able to develop the technology of harnessing renewable energy. Therefore, the reliance on fossil fuels will be weakened, lowering the amount of CO2 emission to a great extent. In order to quantify the best scenario, we hypothetically generate a decreasing trend on the CO2 per capital based on the forecasting values from Holt winter method. In comparison with the other two scenarios, this scenario can represent the ideal situation of the further."
  }
  text
})
output$Accuracy8<-renderTable({
  ACCU2[2,c(2,3,4,5,6)]
})
output$Accuracy6<-renderTable({
  ACCU2[1,c(2,3,4,5,6)]
})
output$Accuracy7<-renderTable({
  ACCU2[3,c(2,3,4,5,6)]
})
})

#########Remind:Use renderPrint is OK,directly add the text in ""##############
