
#!/bin/ksh
#* Script to download GDAS Real time data

set -x
dir1="/shared/pire/gdasRealTime"

#https://www.ftp.ncep.noaa.gov/data/nccf/com/gfs/prod/gdas.20190813/00/gdas.t00z.sfluxgrbf000.grib2
urlBase="http://www.ftp.ncep.noaa.gov/data/nccf/com/gfs/prod"

zero=0
year=$(date +'%Y')
month=$(date +'%m')
day=$(date +'%d')

yrMon="$year$month"
yrMonDay="$year$month$day"

#gdas.20190813/00/gdas.t00z.sfluxgrbf000.grib2

urlBase2="$urlBase""/gdas.""$yrMonDay"

mkdir -p $dir1/$year/$yrMon/$yrMonDay
dirMod="$dir1/$year/$yrMon/$yrMonDay"

anl=4
fcst=1

h=0
for ((i = 1; i <= $anl; i++)); do

        if (($h<10))
        then
        	hh="$zero$h"
        else
                hh="$h"
        fi

	#url="$urlBase2""/""$hh"
	url="$urlBase2""/""$hh""/atmos"  # modified on 04/10/2021 as the poduct owner changed the file path


        hfcst=0
        for ((j = 0; j <= $fcst; j++)); do
		hhf="$zero""$zero""$hfcst"  		

		file="gdas.t""$hh""z.sfluxgrbf""$hhf"".grib2"

		urlMod="$url""/""$file"		

		cd $dirMod

		#wget "$urlMod" -O $file
		nohup wget "$urlMod"

 	hfcst=$(($hfcst+3))
	done

        hfcst=0


h=$(($h+6))
done

h=0


