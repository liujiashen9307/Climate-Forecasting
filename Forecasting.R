library(MASS)
require(forecast)
source("GA forecasting.R")
climate<-read.csv("climate.csv")
RequiredData<-climate[1:136,1:6]
#######Reverse Forecasting in order to obtain more reliable NINO data####
NINO<-RequiredData$Nino
NINO<-NINO[136:1]
NINO_Test<-NINO[is.na(NINO)!=T]
NINO_TS<-ts(NINO_Test,frequency = 5)
fit<-hw(NINO_TS,"m",h=70)
plot(fit)
accuracy(fit$fitted,NINO_Test)
Fitted_Data<-fit$mean
Inte_NINO<-append(NINO_Test,as.numeric(Fitted_Data))
Inte_NINO<-Inte_NINO[136:1]
All_Data<-data.frame(RequiredData[,c(1,2,3,4,6)],NINO=Inte_NINO)
####Solar Complete###
Solar<-RequiredData$Solar
Solar_ts<-ts(Solar,frequency = 11)
Solar_4<-hw(Solar_ts,h=4)
Solar_Com<-append(Solar[1:132],Solar_4$mean)
All_Data$Solar<-Solar_Com
####Plot them together#####
rModel<-Temperature~LogCO2+AMO+NINO+Solar
reg<-lm(rModel,data = All_Data)
summary(reg)
####Find the final regression model####
rsltStep <- stepAIC(reg, direction="both")
rsltStep$anova 
####Solar is excluded######
####if missing values of nino is not reversely predicted####
rModel2<-Temperature~LogCO2+AMO+Nino+Solar
reg1<-lm(rModel2,data = RequiredData)
summary(reg1)
rsltStep1 <- stepAIC(reg1, direction="both")
rsltStep1$anova 
####Solar Activity has been involved if we do not deal with NINO'S missing values###
#De_Carbon_dioxided data###
Exp_CO2<-exp(All_Data$LogCO2)
plot(Exp_CO2,type="l")
plot(All_Data$LogCO2,type="l")
Co2_basis<-All_Data$LogCO2[1]
Doubling_basis<-Co2_basis*2
Interval<-1/(Doubling_basis-Co2_basis)
DeC_Temp<-rep(0,136)
DeC_Temp[1]<-All_Data$Temperature[1]
for(i in (2:136)){
  DeC_Temp[i]<-All_Data$Temperature[i]-(All_Data$LogCO2[i]-All_Data$LogCO2[i-1])*Interval
}
Dec<-data.frame(Year=All_Data$Year,De_Co2Temp=DeC_Temp)
plot(All_Data$Temperature,type="l",main="Comparison between real temp and De-co2 temp",ylab="Temperature")
lines(Dec[,2],col="red")
###No obvious difference, just use linear regression####
Energy<-read.csv("Energy.csv")
GDP<-read.csv("GDP.csv")[,c(1,4)]
names(GDP[,2])<-"GDP"
Population<-read.csv("Population.csv")[,1:2]
pop<-Population[31:63,]
pop[,2]<-pop[,2]/1000000000
gdp<-GDP[21:53,]
gdp[,2]<-gdp[,2]/100000000000000
Energy[,2]<-Energy[,2]/1000
####Take All Data from 1980 to 2012###
PartialData<-All_Data[101:133,]
RegreData<-data.frame(PartialData[1:3],Population=pop[,2],Energy=Energy[,2],GDP=gdp[,2])
Model3<-Temperature~Population+Energy+GDP
Model4<-LogCO2~Population+Energy+GDP
####Explore the relationship between GDP,Energy Consumptions, population and CO2 Emission###
reg3<-lm(Model3,data = RegreData)
reg4<-lm(Model4,data = RegreData)
summary(reg3)
summary(reg4)
rsltStep3 <- stepAIC(reg3, direction="both")
rsltStep3$anova 
rsltStep4 <- stepAIC(reg4, direction="both")
rsltStep4$anova 
#####Do forecasting for AMO ,NINO and Solar respectively#####
#####Do not put time into forecasting stuff because the frequency cannot be identified###
Ts_NINO<-ts(All_Data$NINO,frequency = 5)
length(Ts_NINO)
plot(Ts_NINO)
Nino_25<-forecast(Ts_NINO,h=25,level=0.95)
plot(Nino_25)
Nino_50<-forecast(Ts_NINO,h=50,level = 0.95)
plot(Nino_50)
Nino_100<-forecast(Ts_NINO,h=100,level = 0.95)
plot(Nino_100)
####AMO#######
AMO_updated<-rep(0,141)
for(i in (1:141)){
  if(i < 137){
    AMO_updated[i]<-All_Data$AMO[i]
  }else{
    AMO_updated[i]<-(AMO_updated[i-1]+AMO_updated[i-2]+AMO_updated[i-3]+AMO_updated[i-4])/4
  }
}
Ts_AMO<-ts(AMO_updated,frequency = 69)
plot(Ts_AMO)
AMO_25<-forecast(Ts_AMO,h=20,level=0.95)
plot(AMO_25)
AMO_50<-forecast(Ts_AMO,h=45,level = 0.95)
AMO_100<-forecast(Ts_AMO,h=95,level = 0.95)
plot(AMO_50)
plot(AMO_100)
accuracy(AMO_25$fitted,All_Data$AMO)
#####Amazingly Good Fit!!!!!!!!######
####Solar_ Wiki said 11 years is the frequency####
acf(All_Data$Solar,lag.max = 100)
####Whatever######
Ts_Solar<-ts(All_Data$Solar,frequency=11)
Solar_25<-hw(Ts_Solar,h=25,level = 0.95)
Solar_50<-hw(Ts_Solar,h=50,level = 0.95)
Solar_100<-hw(Ts_Solar,h=100,level = 0.95)
plot(Solar_25)
plot(Solar_50)
plot(Solar_100)
####Next, predict "log(CO2)" value####
####First, do forecasting for population, energy and gdp###
plot(Energy[,1],Energy[,2],type="l",xlab="Year",ylab="Energy Consumption")
y<-Energy[,2];x<-Energy[,1]
reg_ene<-lm(y~x)
Ene_25<-data.frame(x=c(2013:2041))
Ene_50<-data.frame(x=c(2013:2066))
Ene_100<-data.frame(x=c(2013:2116))
Pred_25<-predict(reg_ene,Ene_25,interval = "prediction",level = 0.95)
pred_50<-predict(reg_ene,Ene_50,interval = "prediction",level = 0.95)
pred_100<-predict(reg_ene,Ene_100,interval = "prediction",level = 0.95)
####Population####
plot(pop$Year,pop$Population,xlab="Year",ylab="Population",type="l")###OMG###
###Temp Forecasting###
yy<-pop[,2];xx<-pop[,1]
reg_pop<-lm(yy~xx)
Pop_25<-data.frame(xx=c(2013:2041))
Pop_50<-data.frame(xx=c(2013:2066))
Pop_100<-data.frame(xx=c(2013:2116))
pred_pop_25<-predict(reg_pop,Pop_25,Interval="prediction",level=0.95)
pred_pop_50<-predict(reg_pop,Pop_50,Interval="prediction",level=0.95)
pred_pop_100<-predict(reg_pop,Pop_100,Interval="prediction",level=0.95)
####CO2 25 Years####
ModelCo2<-LogCO2~Population+Energy
regCO2<-lm(ModelCo2,data = RegreData)
Co2_25<-data.frame(Population=pred_pop_25,Energy=Pred_25[,1])
Co2_50<-data.frame(Population=pred_pop_50,Energy=pred_50[,1])
Co2_100<-data.frame(Population=pred_pop_100,Energy=pred_100[,1])
Pre_CO2_25<-predict(regCO2,Co2_25,interval="prediction",n.ahead=25)
Pre_CO2_50<-predict(regCO2,Co2_50,interval="prediction",n.ahead=50)
Pre_CO2_100<-predict(regCO2,Co2_100,interval="prediction",n.ahead=100)
####Then, we put all variables required together for forecasting the climate in different hotizons##
AMO_New_25<-append(AMO_updated[137:141],AMO_25$mean)
AMO_New_50<-append(AMO_updated[137:141],AMO_50$mean)
AMO_New_100<-append(AMO_updated[137:141],AMO_100$mean)
Forecast_25<-data.frame(Year=seq(2017,2041),LogCO2=Pre_CO2_25[5:29,1],NINO=Nino_25$mean,Solar=Solar_25$mean,AMO=AMO_New_25)
Forecast_50<-data.frame(Year=seq(2017,2066),LogCO2=Pre_CO2_50[5:54,1],NINO=Nino_50$mean,Solar=Solar_50$mean,AMO=AMO_New_50)
Forecast_100<-data.frame(Year=seq(2017,2116),LogCO2=Pre_CO2_100[5:104,1],NINO=Nino_100$mean,Solar=Solar_100$mean,AMO=AMO_New_100)
Forecasting_25<-predict(reg,Forecast_25,interval = "prediction",n.ahead=25)
Forecasting_50<-predict(reg,Forecast_50,interval = "prediction",n.ahead=50)
Forecasting_100<-predict(reg,Forecast_100,interval="prediction",n.ahead=100)
####Ploting#####
####25 years###
plot(All_Data$Year,All_Data$Temperature,xlim=c(1880,2041),ylim=c(13,15.2),type="l",xlab="Year",ylab="Temperature")
lines(Forecast_25$Year,Forecasting_25[,1],col="red")
lines(Forecast_25$Year,Forecasting_25[,2],lty=2,col="red")
lines(Forecast_25$Year,Forecasting_25[,3],lty=2,col="red")
###100 years###
plot(All_Data$Year,All_Data$Temperature,xlim=c(1880,2116),ylim=c(13,18),type="l",xlab="Year",ylab="Temperature")
lines(Forecast_100$Year,Forecasting_100[,1],col="red")
lines(seq(2016,2099),climate$IPCC.B1[137:220],col="blue")
lines(Forecast_100$Year,Forecasting_100[,2],lty=2,col="red")
lines(Forecast_100$Year,Forecasting_100[,3],lty=2,col="red")
#####Accuracy of Natural Process Forecasting####
Accuracy_NINO<-accuracy(Nino_25$fitted[71:136],climate$Nino[71:136])
Accuracy_Solar<-accuracy(Solar_25$fitted[1:132],climate$Solar[1:132])
Accuracy_AMO<-accuracy(AMO_25$fitted,climate$AMO)
Acc_Table<-rbind(Accuracy_NINO,Accuracy_AMO,Accuracy_Solar)
#####From here, you can skip it####
write.csv(Acc_Table,"Accuracy.csv")
Nino_H<-append(Inte_NINO,rep(NA,100))
Nino_F1<-append(rep(NA,136),Nino_25$mean);Nino_F1<-append(Nino_F1,rep(NA,75))
Nino_F2<-append(rep(NA,136),Nino_50$mean);Nino_F2<-append(Nino_F2,rep(NA,50))
Nino_F3<-append(rep(NA,136),Nino_100$mean)
Nino_re<-append(Nino_H[1:70],rep(NA,166))
Fit_NINO<-append(rep(NA,70),hw(ts(climate$Nino,frequency=5))$fitted);Fit_NINO<-append(Fit_NINO,rep(NA,100))
NINO_out<-data.frame(Year=seq(1880,2115),Nino=Nino_H,ShortForecasting=Nino_F1,MediumForecasting=Nino_F2,Forecasting=Nino_F3,Nino_Reverse=Nino_re,Fit=Fit_NINO)
write.csv(NINO_out,"NINO.csv")
AMO_H<-append(All_Data$AMO,rep(NA,100))
AMO_F1<-append(rep(NA,136),AMO_New_25);AMO_F1<-append(AMO_F1,rep(NA,75))
AMO_F2<-append(rep(NA,136),AMO_New_50);AMO_F2<-append(AMO_F2,rep(NA,50))
AMO_F3<-append(rep(NA,136),AMO_New_100)
AMO_Out<-data.frame(Year=seq(1880,2115),AMO=AMO_H,ShortForecasting=AMO_F1,MediumForecasting=AMO_F2,LongForecasting=AMO_F3,Fit=append(AMO_25$fitted,rep(NA,95)))
write.csv(AMO_Out,"AMO.csv")
Solar_H<-append(All_Data[,5],rep(NA,100))
Solar_F1<-append(rep(NA,136),Solar_25$mean);Solar_F1<-append(Solar_F1,rep(NA,75))
Solar_F2<-append(rep(NA,136),Solar_50$mean);Solar_F2<-append(Solar_F2,rep(NA,50))
Solar_F3<-append(rep(NA,136),Solar_100$mean)
Solar_Out<-data.frame(Year=seq(1880,2115),Solar=Solar_H,ShortForecasting=Solar_F1,MediumForecasting=Solar_F2,LongForecasting=Solar_F3,Fit=append(Solar_25$fitted,rep(NA,100)))
write.csv(Solar_Out,"Solar.csv")
##########################################################
PCCO2<-read.csv("PCCO2.csv")
plot(PCCO2[,1],PCCO2[,2],type="l")
TS_PCCO2<-ts(PCCO2[,2],frequency =20 )
FFF<-hw(TS_PCCO2,h=4,level=0.0001)
Temp<-data.frame(Year=seq(2012,2015),CO2PC=FFF$mean)
PCCO2<-rbind(PCCO2,Temp)
TS_PCCO2<-ts(PCCO2[,2],frequency =20 )
FFF<-hw(TS_PCCO2,h=100)
MEAN<-FFF$mean
New_Data<-data.frame(Time=seq(2016,2115),Worst=NA,Medium=NA,Best=NA)
SG1<-MEAN[1:10]
SG2<-rep(SG1[10],20)+runif(20,0,0.2)
SG_temp<-append(SG1,SG2)
SG3<-MEAN[11:30]
SG4<-rep(SG3[20],10)+runif(20,0,0.2)
SG5<-MEAN[31:50]
SG6<-rep(SG5[20],10)+runif(10,0,0.2)
#####Medium#####
Medium_C<-rep(SG2[20],70)+runif(70,0,0.2);Medium_C<-append(SG_temp-runif(30,0.05,0.1),Medium_C)
Best_C<-rep(0,70)
for(i in 1:70){
  if(i==1){
    Best_C[i]<-SG2[20]-runif(1,-0.05,0.08)
  }else{
    Best_C[i]<-Best_C[i-1]-runif(1,-0.05,0.08)
  }
}
Best_C<-append(SG_temp-runif(30,0.1,0.2),Best_C)
SG<-append(SG_temp,SG3);SG<-append(SG,SG4);SG<-append(SG,SG5);SG<-append(SG,SG6)
New_Data$Worst<-SG;New_Data$Medium<-Medium_C;New_Data$Best<-Best_C
plot(New_Data$Worst,col="red",type="l",ylim=c(3,7))
lines(New_Data$Medium,col="green")
lines(New_Data$Best,col="orange")
CO2_Fit<-accuracy(FFF$fitted,PCCO2[,2])
CO2<-Export_Data<-data.frame(Year=seq(1960,2115),Original=append(PCCO2[,2],rep(NA,100)),Worst=append(rep(NA,56),SG),Best=append(rep(NA,56),Best_C),Medium=append(rep(NA,56),Medium_C),Fit=append(FFF$fitted,rep(NA,100)))
write.csv(Export_Data,"CO2.csv")
#####Population#####
Population_F<-popcomp 
Population_F<-Population_F[137:236]
temp_pop<-data.frame(Year=seq(2013,2015),Population=pred_pop_25[1:3])
Pop_Out<-rbind(pop,temp_pop)
Old_D<-append(Pop_Out[,2],rep(NA,100));Fore_P<-append(rep(NA,36),Population_F)
Pop_Out<-data.frame(Year=seq(1980,2115),Population=Old_D,Forecasting=Fore_P)
write.csv(Pop_Out,"PopulationF.csv")
#####CO2_Per_Capita###
Ex_CP<-data.frame(Year=seq(1960,2115),RawData=append(PCCO2[,2],rep(NA,100)),Worst=append(rep(NA,56),New_Data$Worst),Medium=append(rep(NA,56),New_Data$Medium),Best=append(rep(NA,56),New_Data$Best))
write.csv(Ex_CP,"CO2PC.csv")
####Model_Log(CO2)####
Model_LogCo2<-LogCO2~Population+Co2_Capita
Raw_Data<-data.frame(Year=seq(1980,2015),Population=Pop_Out$Population[1:36],Co2_Capita=Ex_CP[21:56,2],LogCO2=All_Data$LogCO2[101:136])
Reg_logCO2<-lm(Model_LogCo2,data=Raw_Data)
New_Worst<-data.frame(Population=Pop_Out[37:136,3],Co2_Capita=Ex_CP[57:156,3])
Pred_Worst<-predict(Reg_logCO2,New_Worst,interval="prediction")
New_Medium<-data.frame(Population=Pop_Out[37:136,3],Co2_Capita=Ex_CP[57:156,4])
Pred_Medium<-predict(Reg_logCO2,New_Medium,interval="prediction")
New_Best<-data.frame(Population=Pop_Out[37:136,3],Co2_Capita=Ex_CP[57:156,5])
Pred_Best<-predict(Reg_logCO2,New_Best,interval="prediction")
Combined_Forecasting<-data.frame(Worst=Pred_Worst[,1],Medium=Pred_Medium[,1],Best=Pred_Best[,1])
plot(Combined_Forecasting$Worst,type="l")
lines(Combined_Forecasting$Medium,col="red")
lines(Combined_Forecasting$Best,col="yellow")
Log_Fit<-predict(Reg_logCO2,Raw_Data[,c(2,3)],interval = "prediction")
Log_Co2_Out<-data.frame(Year=seq(1980,2115),Historical_Data=append(Raw_Data$LogCO2,rep(NA,100)),Worst=append(rep(NA,36),Pred_Worst[,1]),Medium=append(rep(NA,36),Pred_Medium[,1]),Best=append(rep(NA,36),Pred_Best[,1]),Fit=append(Log_Fit[,1],rep(NA,100)))
write.csv(Log_Co2_Out,"LogCO2.csv")
ACCU_LOG_CO2<-accuracy(Log_Fit[,1],Raw_Data[,3])
#####Final_Prediction#####
#####Recap####
rModel<-Temperature~LogCO2+AMO+NINO+Solar
reg<-lm(rModel,data = All_Data)
Worst<-data.frame(LogCO2=Pred_Worst[,1],AMO=AMO_Out[137:236,5],NINO=NINO_out[137:236,5],Solar=Solar_Out[137:236,5])
Medium<-data.frame(LogCO2=Pred_Medium[,1],AMO=AMO_Out[137:236,5],NINO=NINO_out[137:236,5],Solar=Solar_Out[137:236,5])
Best<-data.frame(LogCO2=Pred_Best[,1],AMO=AMO_Out[137:236,5],NINO=NINO_out[137:236,5],Solar=Solar_Out[137:236,5])
#####Prediction####
Temp_Data<-All_Data[,c(3,4,5,6)]
Forec_Fit<-predict(reg,Temp_Data,interval = "prediction")[,1]
Forec_Worst<-predict(reg,Worst,interval = "prediction")
Forec_Medium<-predict(reg,Medium,interval = "prediction")
Forec_Best<-predict(reg,Best,interval = "prediction")
Worst<-Best<-rep(0,100)
Rand<-runif(100,0.1,0.2)
Rand2<-runif(25,0.05,0.1)
for(i in (1:100)){
  if(i<=25){
    Worst[i]<-Forec_Worst[i,1]
    Best[i]<-Forec_Best[i,1]
  }else{
    if(i<=50){
    Worst[i]<-Forec_Worst[i,3]
    Best[i]<-Forec_Best[i,2]
    }else{
      Worst[i]<-Forec_Worst[i,3]
      Best[i]<-Forec_Best[i,2]
  }
  }
}
Comb_Forc<-data.frame(Worst=Worst,Medium=Forec_Medium[,1],Best=Best)
Fore_Out<-data.frame(Year=seq(1880,2115),Temperature=append(All_Data$Temperature,rep(NA,100)),Worst=append(rep(NA,136),Comb_Forc$Worst),Medium=append(rep(NA,136),Comb_Forc$Medium),Best=append(rep(NA,136),Comb_Forc$Best),Fit=append(Forec_Fit,rep(NA,100)))
plot(Fore_Out$Year,Fore_Out$Temperature,type="l",ylim=c(13.5,16))
lines(Fore_Out$Year,Fore_Out$Medium,col="blue")
lines(Fore_Out$Year,Fore_Out$Worst,col="red")
lines(Fore_Out$Year,Fore_Out$Best,col="green")
lines(Fore_Out$Year,Fore_Out$Fit,col="red",lty=2)
Acc_Final<-accuracy(Forec_Fit,All_Data$Temperature)
Acc_IPCC<-accuracy(climate$IPCC.model.fit[21:120],climate$Temperature[21:120])
write.csv(Fore_Out,"Forecast.csv")


ACCU_2<-rbind(CO2_Fit,ACCU_LOG_CO2,Acc_Final)
write.csv(ACCU_2,"ACCU2.csv")
