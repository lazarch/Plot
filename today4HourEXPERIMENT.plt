# тут вставлено рядок для виводу графіку в BASH скрипті в командному рядку
#!D:\PORTABLE\gnuplot\bin\wgnuplot
# тут вставлено рядок для виводу графіку в BASH скрипті в командному рядку

reset 
set encoding utf8
pa_ = 30  ## значення паузи в оновленні графіку
cycle = 1
do for [c_p = 0 : 10: 1]{

#місцевий час файлу зменшую на одну секунду для виключення випадків затримки запису у файл, коли у лог-файлі дата і час слідуючого дня
local_time=time(0.0)+(2*60*60)-1          ## місцевий час, час на Який показуємо графік для літнього часу множник 3, для зимового 2
local_time_file=local_time-24*60*60              #для показу вчорашнього графіку
# константа, що додає до UTC 2 чи 3 години, для вірного відображення дати файлу (2*3600), для літнього часу множник 3, для зимового 2 !!!
unset term
set terminal win 1
wtitle = strftime("Today %d %m %Y %H:%M:%S",local_time) .' pause = ' .pa_. 'c. cycle N '.c_p
set term windows font "Times,8" title wtitle size 2200,800 enhanced
set boxwidth 0.3 absolute
set grid nopolar
set grid xtics nomxtics ytics nomytics noztics nomztics \
 nox2tics nomx2tics noy2tics nomy2tics nocbtics nomcbtics
set grid layerdefault lt 0 linewidth 0.500,  lt 0 linewidth 0.500
#місцезнаходження легенди графіку - вгорі зліва
set key inside left top vertical  noreverse enhanced autotitle columnhead box lt black linewidth 1.000 dashtype solid maxrows 7
set pointsize 2
set title "today4Hour 0_5 min.plt"   #назва графіку
set style fill   solid 1.00 border lt -1
set style data linespoints
set style textbox opaque margins  1.0,  1.0 border
set style fill solid 1.0
set linetype 1 lc rgb "dark-violet" lw 2 pt 0
set linetype 2 lc rgb "sea-green" lw 2 pt 7
set linetype 3 lc rgb "cyan" lw 2 pt 6 pi -1
set linetype 4 lc rgb "dark-red" lw 2 pt 5 pi -1
set linetype 5 lc rgb "blue" lw 2 pt 8
set linetype 6 lc rgb "dark-orange" lw 2 pt 3
set linetype 7 lc rgb "black" lw 2 pt 11
set linetype 8 lc rgb "goldenrod" lw 2
set linetype cycle 8
set style line 1 lc rgb 'dark-green'  lt 2 lw 1 pt 0 ps 1        ## ДомПодача dark-green
set style line 2 lc rgb 'light-red'   lt 2 lw 1 pt 0 ps 1        ## ТрехходовыйКлапан green
set style line 3 lc rgb 'dark-red'    lt 2 lw 1 pt 0 ps 1        ## ДомОбратка blue
set style line 4 lc rgb 'red'         lt 2 lw 1 pt 0 ps 1        ## КотелПодача red
set style line 5 lc rgb 'dark-violet'        lt 2 lw 2 pt 0 ps 1        ## КотелОбратка blue
set style line 6 lc rgb 'sea-green'   lt 2 lw 1 pt 0 ps 1        ## ДомОбратка dark-blue
set style line 7 lc rgb 'dark-blue'   lt 1 lw 4 pt 0 ps 1        ## НаружнаяТемпература blue
set style line 8 lc rgb 'blue'        lt 1 lw 1 pt 0 ps 1        ## НаружнаяТемпература blue
LabelNameKP_name(String) = sprintf("котел подача ", String) #вставляю к п перед даними по температурі подачі котла
LabelNameKP(String) = sprintf("{%s}", String)   
LabelNameDP_name(String) = sprintf("дім подача", String)
LabelNameDP(String) = sprintf("{%s}", String)
LabelNameKO(String) = sprintf("{%s} ко", String)
LabelNameDO(String) = sprintf("дo:{%s}", String)
LabelNameTK(String) = sprintf("тк:{%s}", String)
LabelNamePK_name(String) = sprintf("приміщення", String)
LabelNamePK(String) = sprintf("{%s}", String)
LabelNameWT_name(String) = sprintf("вулиця", String)
LabelNameWT(String) = sprintf("{%s}", String)
LabelNameDiffK_name(String) = sprintf("кп-ко", String)
LabelNameDiffK(String, String1) = sprintf("{%.1f} ", String - String1)
LabelNameDiffD_name(String) = sprintf("дп-до", String)
LabelNameDiffD(String, String1) = sprintf("{%.1f} ", String - String1)
LabelNameDiffKDP_name(String) = sprintf("кп-дп", String)
LabelNameDiffKDP(String, String1) = sprintf("{%.1f} ", String - String1)
LabelNameDiffKDO_name(String) = sprintf("ко-до", String)
LabelNameDiffKDO(String, String1) = sprintf("{%.1f} ", String - String1)
LabelNameDiffW(String, String1) = sprintf("до-в {%.1f} ", String - String1)

#******************** далі усе в секундах для розрахунку періодів графіка
timeend =  local_time  ## тут час в секундах з 1970 року
timestart = local_time-(4 * 3600)  ## показуємо 4 години, тут час в секундах з 1970 року
dt = timeend-timestart   ## тут різниця в секундах      
dt=floor(dt/60)*60   
dt = dt/48   
# '14400/24  = 600 sec =10 min це крок осі х коли вибірка інша
# '14400/48  = 300 sec = 5 min це крок осі х коли вибірка 4 години
# '14400/60  = 240 sec = 4 min це крок осі х коли вибірка інша
# 'тому при dt = 300 sec вісь х розмічається з кроком у 5 хвилин '
# 'таких міток, з кроком у 5 хвилин, 48 '
# 'довідково: інтервал датчиків і файлу даних 30 секунд'                
etvmn = dt/30 # вибираємо дані з кожного десятого рядка і ставимо числову мітку температури
etvmn4 = dt/6 # вибираємо дані з кожного пятдесятого рядка, насправді тут заголовок на лінії даних

#set timefmt "%d.%m.%Y,%H:%M:%S"
set datafile sep ','
array local_name[cycle]
array local_full_name[cycle]
array max_time_sec_logfile[cycle]
array min_time_sec_logfile[cycle]
array Bmax_i[cycle]
array Bmin_i[cycle]
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 
max_t = 21.0
min_t = 20.0

do for [i = 1:cycle:1]  {
local_name[i] = strftime("%Y%m%d",local_time-(cycle-i)*24*60*60) .'.log '	# name віддаленого файлу, також name локального файлу
local_full_name[i] = 'd:\Libraries\Plot\Logs\'.local_name[i]   #  повне name локального файлу

#дата модифікації  - супер!************************************************************
curl_file = sprintf('curl --user F6:1953 ftp://192.168.1.13/' .local_name[i] .' -R -s -o ' .local_full_name[i])
system(curl_file)
# запитали дату file
stat_data = system('stat -c %y ' .local_full_name[i])
#pause mouse any "Any key or button will terminate " .stat_data
system('sed -i /Err/d ' .local_full_name[i]) #видаляю рядки з помилкою Err, це відбувається, коли датчик збоїть, міняється дата
#додаю час у секундах у дев'ятий стовбчик лога
system('sed -i /Err/d ' .local_full_name[i]) #видаляю рядки з помилкою Err, це відбувається, коли датчик збоїть, міняється дата
#*******************************************************************************************************************************

set print 'fill.log'
print '****aas     ---   000'
aas=strptime("%d.%m.%Y,%H:%M:%S", "09.12.2021,00:00:03") 
print '****aas     ---   111  ', aas 
#pause mouse any "Any key or button will terminate " ,aas
print '****aas     ---   222  '
set print
f(x,a) = exp(-(x-a)*(x-a)/(1+a*0.5))+0.05*rand(0)
title(n) = sprintf("column %d", n)
set table 'iter.log'
plot [0:20] '+' using (f($1,1)):(f($1,2)):(f($1,3)):(f($1,4)):(f($1,5)):(f($1,6)) w xyerror
set xdata time
set timefmt "%d.%m.%Y,%H:%M:%S"
plot local_full_name[i] using 1:4
unset table

#set table 'iter.log'
#plot local_full_name[i] using 4:8 name columnheader
#plot local_full_name[i] using 1:4 w xyerror
#:strptime("%d.%m.%Y,%H:%M:%S", "09.12.2021,00:00:03")
#plot [0:20] '+' using (f($1,1)):(f($1,2)):(f($1,3)):(f($1,4)):(f($1,5)):(f($1,6)) w xyerror
#unset table
set print 'fill.log' append
print '****aas     ---   333 append '
#           !cat 20211123.log
#system('sed -i.bak s#\([0-9][0-9]\).\([0-9][0-9]\).\([0-9][0-9][0-9][0-9]\),\([0-9][0-9]\):\([0-9][0-9]\):\([0-9][0-9]\)#\3 \1 \2 \4 \5 \6 #g' .local_full_name[i])


#*******************************************************************************************************************************
system('awk -f script.awk ' .local_full_name[i])
print '****script.awk    444 ---   ', 'awk -f script.awk ' .local_full_name[i]
#      ****script.awk     ---   awk -f script.awk d:\Libraries\Plot\Logs\20211207.log 
#-------------------------------------------------------------------------------
#додаю час у секундах у дев'ятий стовбчик лога
#повертаємо збережену дату файлу
system(sprintf('touch -d  "%s" %s ', stat_data, local_full_name[i]))
#************************************************


#stats local_full_name[i] using  1:func name columnheader
#min_time_sec_logfile[i] = STATS_min
#max_time_sec_logfile[i] = STATS_max
print '****script.awk    5 00---   '
stats local_full_name[i] using 4:8 name columnheader
print '****script.awk    5 0---   '
Bmax_i[i] = STATS_max_x
max_t = (STATS_max_x > max_t)?(STATS_max_x):(max_t)
Bmin_i[i] = STATS_min_y
min_t = (STATS_min_y < min_t)?(STATS_min_y):(min_t)
}
set yrange [min_t-2:max_t+2] noreverse nowriteback
print '****script.awk    5 01---   '
#*************************************************************
print '****script.awk    5 --- 1  '
a0000= ' timecolumn(N,"timeformat")\
One trick is to use the ternary ?: operator to filter data:\
plot ’file’ using 1:($3>10 ? $2 : 1/0)\
23.11.2021,00:00:17\
можливо тут додавати потрібно різні значення стовбців і секунди подивитись \
strptime("%d.%b.%Y,%H:%M:%S",column($1$2)) \
тут отримаю час, потім у тернарному оператор і зроблю фільтр і сформую виборку \
which plots the datum in column two against that in column one provided the datum in column three exceeds \
ten. 1/0 is undefined; gnuplot quietly ignores undefined points, so unsuitable points are suppressed. Or \
you can use the pre-defined variable NaN to achieve the same result.'

print '****script.awk    5 ---   '
set xdata time
set timefmt "%d.%m.%Y,%H:%M:%S"
set xrange [ timestart:timeend ]
set x2range [ timestart:timeend ] noreverse nowriteback
set xtics  norangelimit
set xtics format "%b %d" time
set xtics timestart, dt, timeend font ",8"     # інтервал для four_day2, приблизно 26 хвилин о 21 годині для today24Hour
#set format x "%H\n%M" timedate
set x2tics timestart, dt*2, timeend font ",8"
set x2tics border in scale 1,0.5 nomirror norotate  autojustify
#set link x2   #уточнити, чи працює, ніби синхронізує осі
set format x2 "%d/%m\n%R" timedate
set cbtics  norangelimit autofreq 
set mxtics  
set xzeroaxis linetype 3 linewidth 4.5
set x2zeroaxis linetype 1 linewidth 6.5 # тут якась дивна горизонтальна полоса на 40 градусах
#set yzeroaxis linetype 3 linewidth 6.5
unset ytics
#fulltime(col) = strftime("%d %b %Y\n%H:%M:%.3S",column(col))
#parttime(col) = strftime("%H:%M:%.3S",column(col))
#----------------------------------------------------------------set yrange [-5:90] noreverse nowriteback

set ytics add ("25" 25, "28" 28, "34" 34, "62" 62, "70" 70)
set ylabel sprintf("Температура від    %3.3g",min_t) .sprintf("  до   %2.3g",max_t)
TITLE = sprintf("Температура від    %3.3g",min_t) .sprintf("  до   %2.3g",max_t)
set title TITLE tc rgbcolor "blue"  font "Times,18" offset char -140, char 0.5
# важливі всі пропуски (пробіли), особливо у list та sprintf
#****************************************************************************
print '****script.awk    6 ---   '
#****************************************************************************
set multiplot layout 1,1 columnsfirst
do for [i = cycle:1:-1]  {

TITLEI = sprintf("Температура від    %3.3g",Bmin_i[i]) .sprintf("  до   %2.3g ",Bmax_i[i]).' ' .substr(local_name[i],7,8).'/' .substr(local_name[i],5,6) .sprintf("  sec   %2.3g ", max_time_sec_logfile[i]) .sprintf("  secmin   %2.3g ", min_time_sec_logfile[i])
set xlabel TITLEI tc rgbcolor "blue"  font "Times,18" offset char 100*(i-1)-140, char -0.5
#set label ’xlabel’
plot local_full_name[i] using 1:4 ti "КотелПодача" ls 4,\
'' every etvmn4:etvmn4 using 1:4:(LabelNameKP_name(substr(stringcolumn(4),1,4))) w labels tc ls 1 center offset 0,2 ti '',\
'' every etvmn:etvmn using 1:4:(LabelNameKP(substr(stringcolumn(4),1,4))) w labels tc ls 1 center offset 0,1 ti '',\
\
'' using 1:4:5 w filledcurves fc "orange" fs solid 0.5 border lc "red" ti '',\
'' using 1:7:3 w filledcurves  fc "cyan" fs solid 0.5 border lc "blue" ti '', \
'' using 1:($4-$5)+45:($7-$3)+44 w filledcurves  fc "yellow" fs solid 0.5 border lc "blue" ti '',\
'' using 1:($3-$8)-20:($8) w filledcurves  fc "light-blue" fs solid 0.5 border lc "blue" ti '',\
'' using 1:((($4-$7))+20):(($5-$3)+20) w filledcurves  fc "green" fs solid 0.5 border lc "blue" ti '',\
\
'' using 1:($5) ti "КотелОбратка" ls 3,\
'' every etvmn:etvmn using 1:($5):(LabelNameKO(substr(stringcolumn(5),1,4))) w labels tc ls 3 center offset 0,-1 ti '',\
\
'' using 1:($4-$5)+45 ti "РізницяКотел" ls 2,\
'' every etvmn4:etvmn4 using 1:($4-$5)+45:(LabelNameDiffK_name(substr(stringcolumn(4),1,4))) w labels tc ls 6 center offset 0,2 ti '',\
'' every etvmn:etvmn using 1:($4-$5)+45:(LabelNameDiffK((substr(stringcolumn(4),1,4)),(substr(stringcolumn(5),1,4)))) w labels tc ls 6 center offset 0,1 ti '',\
\
'' using 1:($4-$7)+20 ti "РізницяКотелДімПодача" ls 2,\
'' every etvmn4:etvmn4 using 1:($4-$7)+20:(LabelNameDiffKDP_name(substr(stringcolumn(4),1,4))) w labels tc ls 6 center offset 0,2 ti '',\
'' every etvmn:etvmn using 1:($4-$7)+20:(LabelNameDiffKDP((substr(stringcolumn(4),1,4)),(substr(stringcolumn(7),1,4)))) w labels tc ls 6 center offset 0,1 ti '',\
\
'' using 1:($5-$3)+20 ti "РізницяКотелДімОбр" ls 2,\
'' every etvmn4:etvmn4 using 1:($5-$3)+20:(LabelNameDiffKDO_name(substr(stringcolumn(5),1,4))) w labels tc ls 6 center offset 0,-2 ti '',\
'' every etvmn:etvmn using 1:($5-$3)+20:(LabelNameDiffKDO((substr(stringcolumn(5),1,4)),(substr(stringcolumn(3),1,4)))) w labels tc ls 6 center offset 0,-1 ti '',\
\
'' using 1:($7) ti "ДімПодача " ls 4,\
'' every etvmn4:etvmn4 using 1:($7):(LabelNameDP_name(substr(stringcolumn(7),1,4))) w labels tc ls 5 center offset 0,2 ti '',\
'' every etvmn:etvmn using 1:($7):(LabelNameDP(substr(stringcolumn(7),1,4))) w labels tc ls 5 center offset 0,1 ti '',\
\
'' using 1:($3) ti "ДімОбратка" ls 6,\
'' every etvmn:etvmn using 1:($3):(LabelNameDO(substr(stringcolumn(3),1,4))) w labels tc ls 6 center offset 0,-1 ti '',\
\
'' using 1:($7-$3)+44 ti "РізницяБудинок" ls 1,\
'' every etvmn4:etvmn4 using 1:($7-$3)+44:(LabelNameDiffD_name((substr(stringcolumn(7),1,4)))) w labels tc ls 6 center offset 0,-2 ti '',\
'' every etvmn:etvmn using 1:($7-$3)+44:(LabelNameDiffD((substr(stringcolumn(7),1,4)),(substr(stringcolumn(3),1,4)))) w labels tc ls 6 center offset 0,-1 ti '',\
\
'' using 1:($6) ti "Приміщення" ls 3,\
'' every etvmn4:etvmn4 using 1:($6):(LabelNamePK_name(substr(stringcolumn(6),1,4))) w labels tc ls 5 center offset 0,2 ti '',\
'' every etvmn:etvmn using 1:($6):(LabelNamePK(substr(stringcolumn(6),1,4))) w labels tc ls 5 center offset 0,1 ti '',\
'' every etvmn:etvmn using 1:($6):xtic(substr(stringcolumn(2),0,5)) ti '',\
\
'' using 1:($8) ti "Вулиця" ls 7,\
'' every etvmn4:etvmn4 using 1:($8-1):(LabelNameWT_name(substr(stringcolumn(8),1,4))) w labels tc ls 5 center offset 0,-1 ti '',\
'' every etvmn/1.5:etvmn/1.5 using 1:($8-1):(LabelNameWT(substr(stringcolumn(8),1,4))) w labels tc ls 5 center offset 0,0 ti '',\
\
'' using 1:($3-$8)-20 ti "РізницяБО-Вулиця" ls 1,\
'' every etvmn4:etvmn4 using 1:($3-$8)-20:(LabelNameDiffW((substr(stringcolumn(3),1,4)),(substr(stringcolumn(8),1,4)))) w labels tc ls 4 center offset 0,1 ti '',\
\
   5 ls 8, 10 ls 8, 55 ls 8, 64 ls 8
   
   unset key
   #set ytics 0,100 
   #set format y ""
}
unset multiplot

pause pa_
unset border
unset key
unset label
unset arrow
unset term
}