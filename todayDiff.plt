reset 
set encoding utf8
local_time=time(0.0)+(2*3600) ## місцевий час, час на Який показуємо графік
unset term
set terminal win 2
set term windows font "Times,8" title strftime("Select 3 hour %d %m %Y",local_time) size 2200,800 enhanced

set boxwidth 0.3 absolute
set grid nopolar
set grid xtics nomxtics ytics nomytics noztics nomztics \
 nox2tics nomx2tics noy2tics nomy2tics nocbtics nomcbtics
set grid layerdefault   lt 0 linewidth 0.500,  lt 0 linewidth 0.500
#місцезнаходження легенди графіку - вгорі зліва
set key inside right top vertical Right noreverse enhanced autotitle columnhead box lt black linewidth 1.000 dashtype solid
set key opaque
set key outside above 
set pointsize 2
#назва графіку
#set title "plot10_10 etalon.plt" 
set style fill   solid 1.00 border lt -1
set style data linespoints
set style textbox opaque margins  1.0,  1.0 border
set style fill solid 1.0
set style line 1 lc rgb 'dark-green'  lt 2 lw 2 pt 0 ps 1        ## ДомПодача dark-green
set style line 2 lc rgb 'light-red'   lt 2 lw 2 pt 0 ps 1        ## ТрехходовыйКлапан green
set style line 3 lc rgb 'purple'      lt 2 lw 2 pt 0 ps 1        ## Термоклапан purple
set style line 4 lc rgb 'red'         lt 2 lw 2 pt 0 ps 1        ## КотелПодача red
set style line 5 lc rgb 'blue'        lt 2 lw 2 pt 0 ps 1        ## КотелОбратка blue
set style line 6 lc rgb 'dark-blue'   lt 2 lw 2 pt 0 ps 1        ## ДомОбратка dark-blue
set style line 7 lc rgb 'brown'       lt 1 lw 1 pt 0 ps 1        ## НаружнаяТемпература blue

set xtics  norangelimit
set xtics rotate by -90
set ytics auto
set ytics add ("25" 25, "28" 28, "32" 32, "55" 55, "62" 62, "64" 64, "70" 70)
set autoscale keepfix

set ylabel "Градуси" 
#set yrange [ : 75 ] noreverse nowriteback
set datafile sep ','

#комбіную імя файлу з сьогоднішньої дати, для зєднання використовується крапка

#today_date=strftime("%Y%m%d",local_time)
#today_date='\\F7\Logs\'.today_date
#today_date=today_date.'.log'

# далі константа, що додає до UTC дві години, для вірного відображення дати файлу
# t0=(2*3600) я просто додаю число до часу і формую імя файлу, інакше у мене після дванадцятої ночі
# відображався старий файл і лише після другої показувався новий, для літнього часу множник 3, для зимового 2

today_date='\\F7\Logs\'.strftime("%Y%m%d",local_time).'.log'

set xlabel "Графік  ".strftime("%d.%m.%Y,%H:%M:%S",local_time)
#вставляю к п перед даними по температурі подачі котла
LabelNameKP(String) = sprintf("{%s} кп", String)
LabelNameDP(String) = sprintf("будп :{%s}", String)
LabelNameKO(String) = sprintf("{%s} ко", String)
LabelNameDO(String) = sprintf("дo :{%s}", String)
LabelNameTK(String) = sprintf("ткл :{%s}", String)
LabelNamePK(String) = sprintf("пр :{%s}", String)
LabelNameWT(String) = sprintf("вул :{%s}", String)
LabelNameDiffB(String, String1) = sprintf("буд:{%.1f} ", String - String1)
LabelNameDiffK(String, String1) = sprintf("ктл:{%.1f} ", String - String1)
#**********************************************
set xtics rotate by -90
set xdata time
set timefmt "%d.%m.%Y,%H:%M:%S"
timestart = strftime("%d.%m.%Y,%H:%M:%S",local_time-(3*3600)) ## інтервал 3 (три) години
timeend =  strftime("%d.%m.%Y,%H:%M:%S",local_time)
set xrange [timestart:timeend]
# time range must be in same format as data file
# лише для довідки:    set xrange ["06.02.2016,06:00:00":"06.02.2016,08:00:00"]
set format x "%H:%M"
set timefmt "%d.%m.%Y,%H:%M"
#**********************************************
#	1			2		 3		  4		  5		   6		7		 8		 9
#05.10.2017,06:31:11, 30.0000, 53.5000, 22.5625, 32.6250, 69.8750, 78.1250, 07.3750
#11.10.2017,20:23:23, 26.4375, 47.5000, 22.6875, 27.5000, 68.4375, 72.0000, 10.7500
#22.12.2015,06:40:11,DS28_001,DS28_002,DS28_003,DS28_004,DS28_005,DS28_006,DS28_007
#               03    	ДомОбратка, LabelNameDO
#                 04   			ДомПодача,  LabelNameDP
#                   05                Приміщення,  LabelNamePK      
#                     06-------------------  ТрехходовыйКлапан, LabelNameTK
#                       07                              КотелОбратка, LabelNameKO
#                         08                                      КотелПодача, LabelNameKP
#                           09                                    		Вулиця, LabelNameWT
#set xrange ["18:00":"20:00"]
plot today_date\
 using 1:($3):xtic(substr(stringcolumn(3),0,5)) ti "ДомЗворотня" ls 1,\
'' every 15:15 using 1:($3):(LabelNameDO(substr(stringcolumn(3),1,4))) w labels tc ls 1 center offset 0,1,\
\
'' every 5:5 using 1:($4-$3) ti "РізницяБудинок" ls 6,\
'' every 15:15 using 1:($4-$3):(LabelNameDiffB((substr(stringcolumn(4),1,4)),(substr(stringcolumn(3),1,4)))) w labels tc ls 6 center offset 0,-1,\
\
'' every 5:5 using 1:($8-$7) ti "РізницяКотел" ls 4,\
'' every 15:15 using 1:($8-$7):(LabelNameDiffK((substr(stringcolumn(8),1,4)),(substr(stringcolumn(7),1,4)))) w labels tc ls 4 center offset 0,-1,\
\
'' every 5:5 using 1:($3-$6) ti "РізницяЗворотняТриходовий" ls 4,\
'' every 15:15 using 1:($3-$6):(LabelNameDiffK((substr(stringcolumn(3),1,4)),(substr(stringcolumn(6),1,4)))) w labels tc ls 4 center offset 0,-1,\
\
   32

   

# а можна робити і так
# '' every 5:5 using 1:($9+10) ti "КотелВходОбратка" ls 7,\	 
# тут я додаю 10 до значення у стовбчику і за рахунок цього зміщую показник, хоча ti вказую правильне
pause mouse any "Any key or button will terminate"
unset border
unset key
unset label
unset arrow
unset term