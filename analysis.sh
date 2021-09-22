COUNTER=0
for f in footage/up/*.mov; 
do
	python3 main.py "$f"
	mv "output.txt" "data/up/$COUNTER.txt"
	let COUNTER++
done