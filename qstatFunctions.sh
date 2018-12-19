#Functions for making Qstat output better. 
#add the line
#source /path/to/qstatFunctions.sh
#in your .bashrc file
function qs() {
	#displays your own jobs including a summary that are running, queued, errored or paused
	iAm=$(whoami)
	qstatOutput=$(qstat -u $iAm)
	#get the total number of lines in qstat and subtract two for the headers
	#if the total is less than 0 (ie no jobs running) set the total to 0
	total=$(($(echo "$qstatOutput" | wc -l) - 2))
	if [ $total -lt 0 ]; then total=0; fi 
	#get the number of items in each queue
	queued=$(echo "$qstatOutput" | awk '{print $5}' | grep qw | wc -l)
	running=$(echo "$qstatOutput" | awk '{print $5}' | grep r | wc -l)
	errored=$(echo "$qstatOutput" | awk '{print $5}' | grep Eqw | wc -l)
	paused=$(echo "$qstatOutput" | awk '{print $5}' | grep T | wc -l)
	date
	echo "$qstatOutput"
	echo "Total:   $total"
	echo "Running: $running"
	echo "Queued:  $queued"
	echo "Errored: $errored"
	echo "Paused:  $paused"
} 

function qall() {
	#gets the number of jobs running on the cluster and prints a summary of the 
	#number that you have running/queued and the total number running/queued
	iAm=$(whoami)
	qstatOutput=$(qstat -u "*")
	echo "$qstatOutput"
	queued=$(echo "$qstatOutput" | awk '{print $5}' | grep qw | wc -l)
	running=$(echo "$qstatOutput" | awk '{print $5}' | grep r | wc -l)
	mineTotal=$(($(echo "$qstatOutput" | wc -l) - 2))
	mineRun=$(echo "$qstatOutput" | grep $iAm | awk '{print $5}' | grep r | wc -l)
	mineQueue=$(echo "$qstatOutput" |  grep $iAm | awk '{print $5}' | grep qw | wc -l)
	echo "Running: $running ($mineRun for $iAm)"
	echo "Queued:  $queued ($mineQueue for $iAm)"
}

#qexplain is useful when jobs errored to investigate why.
#eg > qexplain <jobid>
alias qexplain='qstat -explain c -j'
alias qwa='watch -n 10 qstat -u $(whoami)'
alias qstat='qstat -u \*'
