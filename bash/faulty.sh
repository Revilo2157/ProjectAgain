export outDir=outputs/${top}

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

	tmax -shell ./tcl/faulty_sim.tcl > "${outDir}/tmax_faulty${delay}.txt"
	echo Finished TetraMax

	cat ${outDir}/tmax_faulty${delay}.txt | grep SDQL | column | cut -d " " -f3 | xargs echo $delay >> ${outDir}/delay.txt

done

echo
echo Starting Locations
export delay=0.005

echo Delay: $delay > ${outDir}/chance.txt
for chance in $(seq 1 1 10)
do
	echo Chance: $chance
        python python/sdfParser.py $top $delay $chance

        pt_shell -f ./tcl/PT_faulty.tcl > "${outDir}/pt_faulty${chance}.txt"
        echo Finished PrimeTime

        tmax -shell ./tcl/faulty_sim.tcl > "${outDir}/tmax_faulty${chance}.txt"
        echo Finished TetraMax

        cat ${outDir}/tmax_faulty${chance}.txt | grep SDQL | column | cut -d " " -f3 | xargs echo $chance >> ${outDir}/chance.txt
done

