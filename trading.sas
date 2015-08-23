data wallet_bs1;
set tf.previsioni1;
keep int1m log_bs log_bs_pred usd_balance btc_balance fee;
usd_balance=.;
btc_balance=.;
fee=.;
run;

data wallet_bs1;
set wallet_bs1;
if int1m="10OCT2014:00:00:00"dt then do; 
	usd_balance=5000;
 	btc_balance=5000/log_bs;
	fee=0;
 	end;
rename 
	log_bs=bitstamp_close
	log_bs_pred=bitstamp_pred60;
if minute(int1m) NE 0 then delete;
run;

data wallet_bs1;
set wallet_bs1;
rename 
	usd_balance=usd_balance1
	btc_balance=btc_balance1
	fee=fee1;
run;



data b1 (drop=usd_balance1 btc_balance1 fee1) ;
set wallet_bs1;
format action $4.;
retain usd_balance btc_balance fee;

/*buying (tassa bs = 0.4%)*/
 if 1.004*bitstamp_close<bitstamp_pred60 then
	if usd_balance>=100 then do;
		fee=fee+100*0.004;
		btc_balance=btc_balance+100/bitstamp_close*0.996;
		usd_balance=usd_balance-100;
		action="buy"; 
		end;
	else if 0<usd_balance<100 then do;
	fee=fee+usd_balance*0.002;
	btc_balance=btc_balance+0.996*usd_balance/bitstamp_close;
	usd_balance=usd_balance-usd_balance; 
	action="buy"; 
	end;
else 
if usd_balance1>. and btc_balance1>. and fee1>. then do;
usd_balance=usd_balance1;
btc_balance=btc_balance1;
fee=fee1;
end;


/*selling (tassa bs = 0.4%)*/
 if 0.996*bitstamp_close>bitstamp_pred60 then
	if btc_balance>=100/bitstamp_close then do;
		fee=fee+100*0.004;
		btc_balance=btc_balance-100/bitstamp_close;
		usd_balance=usd_balance+0.996*100;
		action="sell"; 
		end;
	else if 0<btc_balance<100/bitstamp_close then do;
	fee=fee+0.004*bitstamp_close*btc_balance;
	usd_balance=usd_balance+0.996*bitstamp_close*btc_balance;
	btc_balance=btc_balance-btc_balance;
	action="sell";
	end;
else 
if usd_balance1>. and btc_balance1>. and fee1>. then do;
usd_balance=usd_balance1;
btc_balance=btc_balance1;
fee=fee1;
end;
 bal_bs1=usd_balance+btc_balance*bitstamp_close;
notax_bs1=bal_bs1+fee;
run;
