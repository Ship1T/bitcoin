vecm1<-read.csv("H:/Tesi/dataset R/newdata_pred1.csv")
vecm2<-read.csv("H:/Tesi/dataset R/newdata_pred2.csv")

library(tsDyn)
library(foreign)

#previsioni campione 1
stime_vecm1<-VECM(vecm1, lag=36, r = 2, include = "const", beta = NULL, estim =  "ML", LRinclude = "const")
prediction1<-predict_rolling(stime_vecm1, nroll =87840 ,n.ahead =60)

write.foreign(prediction1$true, "H:/Tesi/dataset R/valorireali1.txt", "H:/Tesi/dataset R/valorireali1.sas",   package="SAS")

write.foreign(prediction1$pred, "H:/Tesi/dataset R/valoripred1.txt", "H:/Tesi/dataset R/valoripred1.sas",   package="SAS")

stime_vecm1<-NULL

#previsioni campione 2
stime_vecm2<-VECM(vecm2, lag=36, r = 2, include = "const", beta = NULL, estim =  "ML", LRinclude = "const")
prediction2<-predict_rolling(stime_vecm2, nroll =87840 ,n.ahead =60)

write.foreign(prediction2$true, "H:/Tesi/dataset R/valorireali2.txt", "H:/Tesi/dataset R/valorireali1.sas",   package="SAS")

write.foreign(prediction2$pred, "H:/Tesi/dataset R/valoripred2.txt", "H:/Tesi/dataset R/valoripred2.sas",   package="SAS")

stime_vecm2<-NULL
