# THis code download cfsv2 32 members starting from April 01 initial condition for 2021

#!/bin/ksh


set -x

dir1="/shared/pire/seasonalFcst/dnld/nineMonFcst"
dir2="/shared/pire/seasonalFcst/dnld/nineMonFcst/eightParams"

#https://nomads.ncep.noaa.gov/pub/data/nccf/com/cfs/prod/cfs/cfs.20190308/00/6hrly_grib_01/flxf2019030800.01.2019030800.grb2

urlBase="https://nomads.ncep.noaa.gov/pub/data/nccf/com/cfs/prod/cfs/cfs."

zero=0
one=1
yr=2021         # USER INPUT    ****************

monSt=4		# USER INPUT    ****************

for ((dayInit = 1; dayInit <= 8; dayInit++)); do  # USER INPUT
#*****************************************************
	
	initSt=0
	for ((initID = 1; initID <= 4; initID++)); do
#*****************************************************

		daySt=$dayInit

		yrMon="$yr$zero$monSt" 		#202104 
		yrMonDay="$yrMon$zero$dayInit" 	#20210401 	#Day is from 1 to 8

		if (($initSt<10))  
		then
			yrMonDayInit="$yrMonDay$zero$initSt"	#2021040100
			initPath="$zero$initSt"
		else
			yrMonDayInit="$yrMonDay$initSt"		
			initPath="$initSt"
		fi


		mkdir -p $dir1/$yr/$yrMon/$yrMonDay/$yrMonDayInit
		dir1Mod="$dir1/$yr/$yrMon/$yrMonDay/$yrMonDayInit"

		cd $dir1Mod

		mkdir -p $dir2/$yr/$yrMon/$yrMonDay/$yrMonDayInit
		dir2Mod="$dir2/$yr/$yrMon/$yrMonDay/$yrMonDayInit"

		#https://nomads.ncdc.noaa.gov/modeldata/cfsv2_forecast_6-hourly_9mon_flxf/
		#2012/201201/20120101/2012010106/
		#flxf2012010112.01.2012010106.grb2
		
		# THis part is for downloading from an alternate source
		#https://nomads.ncep.noaa.gov/pub/data/nccf/com/cfs/prod/cfs/cfs.20190308/00/6hrly_grib_01/flxf2019030800.01.2019030800.grb2

		urlMod="$urlBase""$yrMonDay/$initPath/6hrly_grib_01"	
		monEnd=10       #It ends on Oct 31, 2021
		dayMax=( "0" "31" "28" "31" "30" "31" "30" "31" "31" "30" "31" "30" "31" )

		hCont=0;
		dayCounter=0;

		for ((i = 4; i <= $monEnd; i++)); do	# USER INPUT = starting at Apr
			month=$i
	
#############################################################
			if (($month > 12))
			then
				yr=$(($yr+1))
				month=1		
			fi
	

			if (($month<10))
			then
				yM="$yr$zero$month"    
			else
				yM="$yr$month"  
			fi
##############################################################
			if (($month > $monSt))
        		then
				daySt=1
			fi
############################################################
			dayEnd=${dayMax[$month]}
#############################################################	
##############################################################
			
	
			for ((j = $daySt; j <= $dayEnd; j++)); do
				day=$j

				dayCounter=$(($dayCounter+1))

				if (($day<10))
        			then
                			yMD="$yM$zero$day" 
        			else
        				yMD="$yM$day"  	
				fi

	

				if (($dayCounter<2))
				then
					h=$initSt
				else
					h=0;
				fi


				if (($dayCounter<2))
				then
					if (($initSt==0))
					then
						anl=4
					elif (($initSt==6))
					then
						anl=3
					elif (($initSt==12))
					then
						anl=2
					else
						anl=1
					fi
				else
					anl=4
				fi



				for ((k = 1; k <= $anl; k++)); do
			
					if (($h<10))
					then
						yMDH="$yMD$zero$h"
					else
						yMDH="$yMD$h"										fi

			
					file="flxf""$yMDH"".01.$yrMonDayInit"".grb2"


					urlMod2="$urlMod""/$file"
	
	
					echo urlMod2=$urlMod2
					
					nohup wget $urlMod2 > out.txt

					if (($hCont>0))			
					then				
						wgrib2 $dir1Mod/$file -s | \
                                		egrep '(:TMP:2 m above ground:'$hCont' hour fcst|:PRES:surface:'$hCont' hour fcst|:PRATE:surface:'$hCont' hour fcst|:SPFH:2 m above ground:'$hCont' hour fcst|:UGRD:10 m above ground:'$hCont' hour fcst|:VGRD:10 m above ground:'$hCont' hour fcst|:DLWRF:surface:'$hCont' hour fcst|:DSWRF:surface:'$hCont' hour fcst)' | \
                                		wgrib2 -i $dir1Mod/$file -grib $dir2Mod/$file

					else
						wgrib2 $dir1Mod/$file -s | \
                                                egrep '(:TMP:2 m above ground:anl|:PRES:surface:anl|:PRATE:surface:anl|:SPFH:2 m above ground:anl|:UGRD:10 m above ground:anl|:VGRD:10 m above ground:anl|:DLWRF:surface:anl|:DSWRF:surface:anl)' | \
                                                wgrib2 -i $dir1Mod/$file -grib $dir2Mod/$file


					fi
					
					rm $dir1Mod/$file
							
				h=$(($h+6))
				hCont=$(($hCont+6))
				done

			done


		done
#done

	initSt=$(($initSt+6))
	done

done





