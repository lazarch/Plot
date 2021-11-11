# тут вставлено рядок для виводу графіку в BASH скрипті в командному рядку
#!D:\PORTABLE\gnuplot\bin\wgnuplot
# тут вставлено рядок для виводу графіку в BASH скрипті в командному рядку

reset 
set encoding utf8

pa_ = 120  ## значення паузи в оновленні графіку
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
set title "today24Hour 2 min.plt"        #назва графіку
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
set xtics  norangelimit 
set xtics rotate by -90
set ytics auto
set xtics auto
set ytics add ("5" 5,"10" 10, "25" 25, "28" 28, "34" 34, "55" 55, "62" 62, "64" 64, "70" 70)
set autoscale keepfix
set ylabel "Градуси" 
#set yrange [0 : 100 ] noreverse nowriteback
#****************************************************************************
set datafile sep ','
set xlabel "Графік  ".strftime("%d.%m.%Y,%H:%M:%S",local_time)
LabelNameKP(String) = sprintf("{%s} кп", String)   #вставляю к п перед даними по температурі подачі котла
LabelNameDP(String) = sprintf("дп:{%s}", String)
LabelNameKO(String) = sprintf("{%s} ко", String)
LabelNameDO(String) = sprintf("дo:{%s}", String)
LabelNameTK(String) = sprintf("тк:{%s}", String)
LabelNamePK(String) = sprintf("пр:{%s}", String)
LabelNameWT(String) = sprintf("в:{%s}", String)
LabelNameDiffK(String, String1) = sprintf("кп-ко {%.1f} ", String - String1)
LabelNameDiffD(String, String1) = sprintf("дп-до {%.1f} ", String - String1)
LabelNameDiffKDP(String, String1) = sprintf("кп-дп {%.1f} ", String - String1)
LabelNameDiffKDO(String, String1) = sprintf("ко-до {%.1f} ", String - String1)
LabelNameDiffW(String, String1) = sprintf("до-в {%.1f} ", String - String1)
set xtics rotate by -90
set xdata time
set timefmt "%d.%m.%Y,%H:%M:%S"

local_time_start=local_time-(cycle-1)*24*60*60
timestart = strftime("%d.%m.%Y,00:00:00",local_time_start) ## початок доби
timeend =  strftime("%d.%m.%Y,%H:%M:%S",local_time)
etvmx = 75
etvmn = 50
set xrange [timestart:timeend]
set format x "%H:%M"

# важливі всі пропуски (пробіли), особливо у list та sprintf
#****************************************************************************
array local_name[cycle]
array local_full_name[cycle]

do for [i = 1:cycle:1]  {
local_name[i] = strftime("%Y%m%d",local_time-(cycle-i)*24*60*60)	# name віддаленого файлу, також name локального файлу
local_full_name[i] = 'd:\Libraries\Plot\Logs\'.local_name[i] .'.log '   #  повне name локального файлу

#дата модифікації  - супер!************************************************************
curl_file = sprintf('curl --user F6:1953 ftp://192.168.1.13/' .local_name[i] .'.log -R -s -o ' .local_full_name[i])
system(curl_file)
# запитали дату
stat_data = system('stat -c %y ' .local_full_name[i])
#pause mouse any "Any key or button will terminate " .stat_data
system('sed -i /Err/d ' .local_full_name[i])
system(sprintf('touch -d  "%s" %s ', stat_data, local_full_name[i]))

}

#****************************************************************************
set multiplot layout 1,1 columnsfirst
do for [i = cycle:1:-1]  {
plot local_full_name[i] using 1:4 ti "КотелПодача" ls 4,\
'' every etvmn:etvmn using 1:4:(LabelNameKP(substr(stringcolumn(4),1,4))) w labels tc ls 1 center offset 0,1,\
\
'' using 1:4:5 w filledcurves  fc "orange" fs solid 0.5 border lc "red",\
'' using 1:7:3 w filledcurves  fc "cyan" fs solid 0.5 border lc "blue", \
'' using 1:($4-$5)+45:($7-$3)+44 w filledcurves  fc "yellow" fs solid 0.5 border lc "blue",\
'' using 1:($3-$8)-20:($8) w filledcurves  fc "light-blue" fs solid 0.5 border lc "blue",\
'' using 1:((($4-$7))+20):(($5-$3)+20) w filledcurves  fc "green" fs solid 0.5 border lc "blue",\
\
'' using 1:($5) ti "КотелОбратка" ls 3,\
'' every etvmn:etvmn using 1:($5):(LabelNameKO(substr(stringcolumn(5),1,4))) w labels tc ls 3 center offset 0,-1,\
\
'' every 5:5 using 1:($4-$5)+45 ti "РізницяКотел" ls 2,\
'' every etvmn:etvmn using 1:($4-$5)+45:(LabelNameDiffK((substr(stringcolumn(4),1,4)),(substr(stringcolumn(5),1,4)))) w labels tc ls 6 center offset 0,1,\
\
'' every 5:5 using 1:($4-$7)+20 ti "РізницяКотелДімПодача" ls 2,\
'' every etvmn:etvmn using 1:($4-$7)+20:(LabelNameDiffKDP((substr(stringcolumn(4),1,4)),(substr(stringcolumn(7),1,4)))) w labels tc ls 6 center offset 0,1,\
\
'' every 5:5 using 1:($5-$3)+20 ti "РізницяКотелДімОбр" ls 2,\
'' every etvmn:etvmn using 1:($5-$3)+20:(LabelNameDiffKDO((substr(stringcolumn(5),1,4)),(substr(stringcolumn(3),1,4)))) w labels tc ls 6 center offset 0,-1,\
\
'' using 1:($7) ti "ДімПодача " ls 4,\
'' every etvmn:etvmn using 1:($7):(LabelNameDP(substr(stringcolumn(7),1,4))) w labels tc ls 5 center offset 0,1,\
\
'' using 1:($3) ti "ДімОбратка" ls 6,\
'' every etvmn:etvmn using 1:($3):(LabelNameDO(substr(stringcolumn(3),1,4))) w labels tc ls 6 center offset 0,-1,\
\
'' every 5:5 using 1:($7-$3)+44 ti "РізницяБудинок" ls 1,\
'' every etvmn:etvmn using 1:($7-$3)+44:(LabelNameDiffD((substr(stringcolumn(7),1,4)),(substr(stringcolumn(3),1,4)))) w labels tc ls 6 center offset 0,-1,\
\
'' using 1:($6) ti "Приміщення" ls 3,\
'' every etvmn:etvmn using 1:($6):(LabelNamePK(substr(stringcolumn(6),1,4))) w labels tc ls 2 center offset 0,1,\
\
'' using 1:($8) ti "Вулиця" ls 7,\
'' every etvmn:etvmn using 1:($8-1):(LabelNameWT(substr(stringcolumn(8),1,4))) w labels tc ls 5 ,\
\
'' every 5:5 using 1:($3-$8)-20 ti "РізницяБО-Вулиця" ls 1,\
'' every etvmn:etvmn using 1:($3-$8)-20:(LabelNameDiffW((substr(stringcolumn(3),1,4)),(substr(stringcolumn(8),1,4)))) w labels tc ls 4 center offset 0,-1,\
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