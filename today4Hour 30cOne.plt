# тут вставлено рядок для виводу графіку в BASH скрипті в командному рядку
#!D:\PORTABLE\gnuplot\bin\wgnuplot
# тут вставлено рядок для виводу графіку в BASH скрипті в командному рядку
reset 
set encoding utf8

pa_ = 30  ## значення паузи в оновленні графіку
c_p = 0
do for [c_p = 0 : 1: 1]{
local_time=time(0.0)+(3*3600) ## місцевий час, час на Який показуємо графік
cycle = 1
# константа, що додає до UTC 2 чи 3 години, для вірного відображення дати файлу
# (2*3600), для літнього часу множник 3, для зимового 2, і ще у 85 рядку потрібно міняти ! ! !unset term
set terminal win 2

wtitle = strftime("Select 4 hour 30 c %d %m %Y",local_time).' time '.strftime("%H:%M:%S",local_time).' pause = ' .pa_. 'c. cycle N '.c_p

system(sprintf("d:\\PORTABLE\\TCPU69\\Programm\\Winscp\\winscp.com /ini=nul /script=Kotel.txt"))

set term windows font "Times,8" title wtitle size 2200,800 enhanced
set boxwidth 0.3 absolute
set grid nopolar
set grid xtics nomxtics ytics nomytics noztics nomztics \
 nox2tics nomx2tics noy2tics nomy2tics nocbtics nomcbtics
set grid layerdefault lt 0 linewidth 0.500,  lt 0 linewidth 0.500
#місцезнаходження легенди графіку - вгорі зліва
set key inside right top vertical Right noreverse enhanced autotitle columnhead box lt black linewidth 1.000 dashtype solid
set key opaque
set key outside above 
set pointsize 2
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
set style line 7 lc rgb 'brown'       lt 2 lw 2 pt 0 ps 1        ## НаружнаяТемпература blue

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

today_date='d:\Libraries\Plot\Logs\'.strftime("%Y%m%d",local_time).'.log'
#today_date= 'https://drive.google.com/open?id=1pMnPYVmI4-gAruL2d0vSOf2vyKEjRw37'
set xlabel "Графік  ".strftime("%d.%m.%Y,%H:%M:%S",local_time)
#вставляю к п перед даними по температурі подачі котла
LabelNameKP(String) = sprintf("{%s} кп", String)
LabelNameDP(String) = sprintf("бп:{%s}", String)
LabelNameKO(String) = sprintf("{%s} ко", String)
LabelNameDO(String) = sprintf("дo:{%s}", String)
LabelNameTK(String) = sprintf("тк:{%s}", String)
LabelNamePK(String) = sprintf("пр:{%s}", String)
LabelNameWT(String) = sprintf("в:{%s}", String)

LabelNameDiffB(String, String1) = sprintf("-:{%.1f} ", String - String1)
LabelNameDiffK(String, String1) = sprintf("ктл:{%.1f} ", String - String1)
#**********************************************
#set xtics rotate by -90
set xdata time
set timefmt "%d.%m.%Y,%H:%M:%S"

timestart = strftime("%d.%m.%Y,%H:%M:%S",local_time-(4*3600)) ## інтервал 4 години
timeend =  strftime("%d.%m.%Y,%H:%M:%S",local_time)
etvmx = 20
etvmn = 10
set xrange [timestart:timeend]
# time range must be in same format as data file
# лише для довідки:    set xrange ["06.02.2016,06:00:00":"06.02.2016,08:00:00"]
set format x "%H:%M"
#--------set timefmt "%d.%m.%Y,%H:%M"
#**********************************************
#	1			2		 3		  4		  5		   6		7		 8		 9
#05.10.2017,06:31:11, 30.0000, 53.5000, 22.5625, 32.6250, 69.8750, 78.1250, 07.3750
#11.10.2017,20:23:23, 26.4375, 47.5000, 22.6875, 27.5000, 68.4375, 72.0000, 10.7500
#22.12.2015,06:40:11,DS28_001,DS28_002,DS28_003,DS28_004,DS28_005,DS28_006,DS28_007
#                      
# BF  191      03    	ДомОбратка, LabelNameDO
# GE  110         04   			ДомПодача,  LabelNameDP
# D7  215           05                Приміщення,  LabelNamePK      
# 05    5             06-------------------  ТрехходовыйКлапан, LabelNameTK
# 9B  155               07                              КотелОбратка, LabelNameKO
# 44   16                 08                                      КотелПодача, LabelNameKP
# 10   68                   09                                    		Вулиця, LabelNameWT
#set xrange ["18:00":"20:00"]

plot today_date\
   using 1:4:xtic(substr(stringcolumn(2),0,5)) every 4 ti "ДомПодача" ls 1,\
'' every etvmx:etvmx using 1:4:(LabelNameDP(substr(stringcolumn(4),1,4))) w labels tc ls 1 center offset 3,1,\
\
'' using 1:($3+1) ti "ДомОбратка" ls 6,\
'' every etvmx:etvmx using 1:($3+1):(LabelNameDO(substr(stringcolumn(3),1,4))) w labels tc ls 6 center offset -3,-1,\
\
'' using 1:($5+17) ti "Приміщення" ls 3,\
'' every etvmx:etvmx using 1:($5+17):(LabelNamePK(substr(stringcolumn(5),1,4))) w labels tc ls 3 center offset -3,1,\
\
'' using 1:($6) ti "ТрехходовыйКлапан" ls 2,\
'' every etvmx:etvmx using 1:($6):(LabelNameTK(substr(stringcolumn(6),1,4))) w labels tc ls 2 center offset 3,1,\
\
'' using 1:($7) ti "КотелОбратка" ls 5,\
'' every etvmx:etvmx using 1:($7):(LabelNameKO(substr(stringcolumn(7),1,4))) w labels tc ls 5 center offset -3,1,\
\
'' using 1:($8) ti "КотелПодача" ls 4,\
'' every etvmn:etvmn using 1:($8):(LabelNameKP(substr(stringcolumn(8),1,4))) w labels tc ls 4 center offset 4,1,\
\
'' using 1:($9+40) ti "Вулиця" ls 7,\
'' every etvmx:etvmx using 1:($9+39):(LabelNameWT(substr(stringcolumn(9),1,5))) w labels tc ls 7 center offset 3,0,\
\
   32,55,60,64,70

   


print 'pause = ' .pa_. 'c. cycle N '.c_p 

print 'start pause ' .pa_. 'c. cycle N '.c_p.' time '.strftime("%H:%M:%S",local_time)
pause pa_ 
print ' end  pause ' .pa_. 'c. cycle N '.c_p.' time '.strftime("%H:%M:%S",local_time)
print ' '


  
# тут вставлена пауза для виводу графіка в командному рядку по F3 в Total(налаштовую в правка/просмотр По типам файлів,
# вказую розширення plt і шлях до gnuplot.exe), пауза до натискання Enter
#pause -1 "Hit return to continue"
#replot
#pause -1 "Hit return222 to continue"
#replot
#pause mouse any "Any key or button will terminate"
# тут вставлена пауза для виводу графіка в командному рядку по F3 в Total(налаштовую в правка/просмотр По типам файлів,
# вказую розширення plt і шлях до gnuplot.exe), пауза до натискання Enter

#print "I will resume after you hit the Tab key in the plot window"
#load "wait_for_tab"
# цей файл лежить поряд у папці


# а можна робити і так
# '' every 5:5 using 1:($9+10) ti "КотелВходОбратка" ls 7,\	 
# тут я додаю 10 до значення у стовбчику і за рахунок цього зміщую показник, хоча ti вказую правильне
# pause mouse any "Any key or button will terminate"
unset border
unset key
unset label
unset arrow
unset term
}
#