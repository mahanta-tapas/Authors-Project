use "/Users/axz051000/Dropbox/RA-Books/tapas_raw_oct28.dta", clear

drop if isbn==""
drop if isbn13==""
drop if title==""
drop if author==""
drop if title==""
drop if year==.

*duplicates

egen minyear=min(year), by(isbn)
gen a=1
egen aa=sum(a), by(author isbn)
egen bb=sum(a), by(author title)
*is the same book published in two years?
list if aa>1 & year~=minyear
list if bb>1 & year~=minyear

egen tag = tag(author isbn)
keep if tag==1
egen tag1 = tag(author title)
keep if tag1==1

gen eliminate1=strpos(lower(title),"preview")
list if eliminate1>0
drop if eliminate1>0
gen eliminate2=strpos(lower(title),"free")
list if eliminate2>0
gen eliminate3=strpos(lower(title),"digest")
list if eliminate3>0
drop if eliminate3>0

gen eliminate4=strpos(title ,"/")
list if eliminate4>0
drop if eliminate4>0
gen eliminate5=strpos(title ,"\")
list if eliminate5>0
drop if eliminate5>0
gen eliminate6=strpos(lower(title),"collect")
list title if eliminate6>0
drop if eliminate6>0
gen eliminate7=strpos(lower(title),"boxed set")
list if eliminate7>0
drop if eliminate7>0
gen eliminate8=strpos(lower(title),"book set")
list if eliminate8>0
drop if eliminate8>0
gen eliminate9=strpos(lower(title) ,"audio")
list if eliminate9>0
drop if eliminate9>0
gen eliminate10=strpos(lower(title) ,"review")
list if eliminate10>0
drop if eliminate10>0
gen eliminate11=strpos(lower(title) ,"pack")
list if eliminate11>0
drop if eliminate11>0
gen eliminate12=strpos(lower(title) ,"gift")
list if eliminate12>0
drop if eliminate12>0
gen eliminate13=strpos(lower(title) ,"bundle")
list if eliminate13>0
drop if eliminate13>0
gen eliminate14=strpos(lower(title) ,"condensed")
drop if eliminate14>0
gen eliminate15=strpos(lower(title) ,"series")
drop if eliminate15>0
gen eliminate16=strpos(lower(title) ,"ebook")
drop if eliminate16>0
gen eliminate17=strpos(title ,";")
* for i think we have to be more careful for example The Crystal Shard (Forgotten Realms: Icewind Dale, #1; Legend of Drizzt, #4)
*The above title is one book but part of different series as described in the explanation in braces
* I think we should keep track of the books we are missing this way. 
list if eliminate17>0
*drop if eliminate17>0

gen eliminate18=strpos(lower(title) ,"omnibus")
list if eliminate18>0
drop if eliminate18>0

gen eliminate19=strpos(lower(title) ,"vol.")
* Same issue with ';' i think
* For example The Legend of Drizzt Omnibus, Vol. 1 (Legend of Drizzt: The Graphic Novel, #1-3)
list if eliminate19>0
drop if eliminate19>0
*drop if language is not english?
* For language we can add phrases "Japanese Language" and "Japanese Edition" and similar phrases for French,Spanish etc.
* I mostly found Jpanese translations but we can do this for other popular languages just to be sure.
destring page_no, replace force

forvalues i=1940/2019 {
egen totalnumberofbooks`i'=sum(a) if year==`i', by(author)
}

forvalues i=1940/2019 {
egen numberofpages`i'=sum(page_no) if year==`i' & page_no~=., by(author)
}

collapse numberofpages1940-numberofpages2019 totalnumberofbooks1940-totalnumberofbooks2019 mistake (firstnm) authorold, by(author)

order author authorold
reshape long totalnumberofbooks numberofpages, i(author) j(year)
bysort author: gen cumulative_count = sum(totalnumberofbooks)

drop if cumulative_count==0

replace totalnumberofbooks=0 if totalnumberofbooks==.

replace numberofpages=0 if totalnumberofbooks==0

drop if author=="Steven Rimbauer"
drop if author=="Joyce Reardon"


gen post=0
replace post=1 if year>2002
*drop if year==2001  | year==2002
*keep if (year>1997 & year <2005)
gen interaction=mistake*post
encode author, gen(author_aux)

xtset author_aux year
xtreg totalnumberofbooks interaction i.year, fe cluster(author)
est store reg1

xtreg numberofpages interaction i.year, fe cluster(author)
est store reg2
esttab _all using table1.csv, se keep(interaction) replace
preserve
egen author_year=concat(authorold year)
gen author_goodreads=author
gen numberofbooks_goodreads=totalnumberofbooks
save "/Users/axz051000/Dropbox/RA-Books/compare_with_wikipedia.dta", replace
restore
drop if year <1990
drop if year >2015
tab year, gen(yr)


 gen int1=yr1*mistake
 gen int2=yr2*mistake
 gen int3=yr3*mistake 
 gen int4=yr4*mistake  
 gen int5=yr5*mistake
 
 gen int6=yr6*mistake
 gen int7=yr7*mistake
 gen int8=yr8*mistake 
 gen int9=yr9*mistake  
 gen int10=yr10*mistake
 
 gen int11=yr11*mistake
 gen int12=yr12*mistake
 gen int13=yr13*mistake 
 gen int14=yr14*mistake  
 gen int15=yr15*mistake
 
 gen int16=yr16*mistake
 gen int17=yr17*mistake
 gen int18=yr18*mistake 
 gen int19=yr19*mistake  
 gen int20=yr20*mistake
 
 gen int21=yr21*mistake
gen int22=yr22*mistake
gen int23=yr23*mistake 
gen int24=yr24*mistake  
gen int25=yr25*mistake 
 
gen int26=yr26*mistake
  
xtreg totalnumberofbooks  int1-int10 int12-int26   yr1-yr10 yr12-yr26,  fe cluster(author) coeflegend

coefplot, vertical keep(int1 int2 int4 int4 int5 int6 int7 int8 int9 int10 int11 int12 int13 int14 int15 int16 int17 int18 int19 int20 int21 int22 int23 int24 int25 int26) coeflabels(int1="1990" int2="1991" int3="1992" int4="1993" int5="1994" int6="1995" int7="1996" int8="1997" int9="1998" int10="1999" int11="2000" int12="2001" int13="2002" int14="2003" int15="2004" int16="2005" int17="2006" int18="2007" int19="2008" int20="2009" int21="2010" int22="2011" int23="2012" int24="2013" int25="2014" int26="2015") xlabel(, angle(90)) yline(0) xline(40) ysc(r(-2 2)) ylabel(-2(1)2)  omitted baselevels

xtreg numberofpages  int1-int10 int12-int26   yr1-yr10 yr12-yr26,  fe cluster(author) coeflegend
coefplot, vertical keep(int1 int2 int4 int4 int5 int6 int7 int8 int9 int10 int11 int12 int13 int14 int15 int16 int17 int18 int19 int20 int21 int22 int23 int24 int25 int26) coeflabels(int1="1990" int2="1991" int3="1992" int4="1993" int5="1994" int6="1995" int7="1996" int8="1997" int9="1998" int10="1999" int11="2000" int12="2001" int13="2002" int14="2003" int15="2004" int16="2005" int17="2006" int18="2007" int19="2008" int20="2009" int21="2010" int22="2011" int23="2012" int24="2013" int25="2014" int26="2015") xlabel(, angle(90)) yline(0) xline(40) ysc(r(-1000 1000)) ylabel(-1000(500)1000)  omitted baselevels




reghdfe totalnumberofbooks mistake ib2000.year#c.mistake, a(author year) cluster(author)

coefplot, drop(_cons mistake) vertical coeflabels(2004.year#c.mistake = "2004" 2007.year#c.mistake = "2007" 2000.year#c.mistake = "2000" 2001.year#c.mistake = "2001" 2002.year#c.mistake = "2002" 2003.year#c.mistake = "2003" 2005.year#c.mistake = "2005" 2006.year#c.mistake = "2006" 2007.year#c.mistake = "2007" 2008.year#c.mistake = "2008" 2009.year#c.mistake = "2009" 2010.year#c.mistake = "2010" 2011.year#c.mistake = "2011" 2012.year#c.mistake = "2012" 2013.year#c.mistake = "2013" 2014.year#c.mistake = "2014" 2015.year#c.mistake = "2015" 1990.year#c.mistake = "1990" 1991.year#c.mistake = "1991" 1992.year#c.mistake = "1992" 1993.year#c.mistake = "1993" 1994.year#c.mistake = "1994" 1995.year#c.mistake = "1995" 1996.year#c.mistake = "1996" 1997.year#c.mistake = "1997" 1998.year#c.mistake = "1998" 1999.year#c.mistake = "1999" _cons = "Constant") xlabel(, angle(90)) yline(0) xline(11) ysc(r(-2 2)) ylabel(-2(1)2) omitted baselevels


reghdfe numberofpages mistake ib2000.year#c.mistake, a(author year) cluster(author)

coefplot, drop(_cons mistake) vertical coeflabels(2004.year#c.mistake = "2004" 2007.year#c.mistake = "2007" 2000.year#c.mistake = "2000" 2001.year#c.mistake = "2001" 2002.year#c.mistake = "2002" 2003.year#c.mistake = "2003" 2005.year#c.mistake = "2005" 2006.year#c.mistake = "2006" 2007.year#c.mistake = "2007" 2008.year#c.mistake = "2008" 2009.year#c.mistake = "2009" 2010.year#c.mistake = "2010" 2011.year#c.mistake = "2011" 2012.year#c.mistake = "2012" 2013.year#c.mistake = "2013" 2014.year#c.mistake = "2014" 2015.year#c.mistake = "2015" 1990.year#c.mistake = "1990" 1991.year#c.mistake = "1991" 1992.year#c.mistake = "1992" 1993.year#c.mistake = "1993" 1994.year#c.mistake = "1994" 1995.year#c.mistake = "1995" 1996.year#c.mistake = "1996" 1997.year#c.mistake = "1997" 1998.year#c.mistake = "1998" 1999.year#c.mistake = "1999" _cons = "Constant") xlabel(, angle(90)) yline(0) xline(11) ysc(r(-1000 1000)) ylabel(-1000(500)1000) omitted baselevels


