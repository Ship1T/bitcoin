#Stata Do file with regression corrected for autocorrelation for yields and volatility of bitcoin in 3 different markets

*btcncny

newey btcncny_yield macro1 macro2 sup_dem4 sup_dem5 sup_dem6 attr1 attr2 attivita_btcn, lag(20) force
est sto e1

newey btcncny_r2 macro1 macro2 sup_dem4 sup_dem5 sup_dem6 attr1 attr2 attivita_btcn, lag(20) force
est sto e2

reg btcncny_arch2 macro1 macro2 sup_dem4 sup_dem5 sup_dem6 attr1 attr2 attivita_btcn
est sto e3

newey btcncny_rv macro1 macro2 sup_dem4 sup_dem5 sup_dem6 attr1 attr2 attivita_btcn, lag(20) force
est sto e4

**************************************************

*btceeur

arima btceeur_yield macro1 macro2 sup_dem4 sup_dem5 sup_dem6 attr1 attr2 attivita_btce, ar(2/5)
est sto d1

newey btceeur_r2 macro1 macro2 sup_dem4 sup_dem5 sup_dem6 attr1 attr2 attivita_btce, lag(20) force
est sto d2

newey btceeur_arch2 macro1 macro2 sup_dem4 sup_dem5 sup_dem6 attr1 attr2 attivita_btce, lag(20) force
est sto d3

reg btceeur_rv macro1 macro2 sup_dem4 sup_dem5 sup_dem6 attr1 attr2 attivita_btce
est sto d4

*************************************************

*bsusd*
arima bsusd_yield macro1 macro2 sup_dem4 sup_dem5 sup_dem6 attr1 attr2 attivita_bs, ar(5)
est sto c1

newey bsusd_r2 macro1 macro2 sup_dem4 sup_dem5 sup_dem6 attr1 attr2 attivita_bs, lag(20) force
est sto c2

newey bsusd_arch2 macro1 macro2 sup_dem4 sup_dem5 sup_dem6 attr1 attr2 attivita_bs, lag(20) force
est sto c3

newey bsusd_rv macro1 macro2 sup_dem4 sup_dem5 sup_dem6 attr1 attr2 attivita_bs, lag(20) force
est sto c4
