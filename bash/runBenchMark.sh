# if [ #? -ne 3 ]; then 
#  echo Requires 3 inputs
#  exit 1
# fi

export top=multdiv
export clk=clock
bash/compile.sh $top $clk

echo Running ATPG
bash/run4small.sh 1

push
