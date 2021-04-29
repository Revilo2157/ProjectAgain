#!/bin/bash

if [ $# -ne 2 ]; then
	echo "Need top level module name, and clock pin"
	exit 1
fi

export top=$1
export clk=$2


export CLK_PERIOD=1
echo Clock Period of: $CLK_PERIOD 

export outDir=outputs/${top}

export c=20
SLACK=$c
export TMGN=$(awk "BEGIN {printf \"%.2f\n \", $CLK_PERIOD * $SLACK / 100}");
pt_shell -f ./tcl/PT_scriptsd.tcl > "${outDir}/pt_final.txt"
echo Finished PrimeTime

export patterns=750
export time=1.5

echo
echo Doing final ATPG

tmax -shell ./tcl/sddatpg.tcl > "${outDir}/tmax_final.txt"
echo Finished TetraMax

echo
echo Starting size
export chance=5

echo Chance: $chance > ${outDir}/delay.txt 
for delay in $(seq 0.00025 0.00025 0.01)
do
	echo Delay: $delay
	python python/sdfParser.py $top $delay $chance

	pt_shell -f ./tcl/PT_faulty.tcl > "${outDir}/pt_faulty${delay}.txt"
	echo Finished PrimeTime
	grep Error "${outDir}/pt_faulty${delay}.txt"


	tmax -shell ./tcl/faulty_sim.tcl > "${outDir}/tmax_faulty${delay}.txt"
	echo Finished TetraMax
	grep Error "${outDir}/tmax_faulty${delay}.txt"

	cat ${outDir}/tmax_faulty${delay}.txt | grep SDQL | column | cut -d " " -f3 | xargs echo $delay >> ${outDir}/delay.txt

done

echo
echo Starting Locations
export delay=0.005

echo Delay: $delay > ${outDir}/chance.txt
for chance in $(seq 0.25 0.25 10)
do
	echo Chance: $chance
        python python/sdfParser.py $top $delay $chance

        pt_shell -f ./tcl/PT_faulty.tcl > "${outDir}/pt_faulty${chance}.txt"
        echo Finished PrimeTime

        tmax -shell ./tcl/faulty_sim.tcl > "${outDir}/tmax_faulty${chance}.txt"
        echo Finished TetraMax

        cat ${outDir}/tmax_faulty${chance}.txt | grep SDQL | column | cut -d " " -f3 | xargs echo $chance >> ${outDir}/chance.txt
done

