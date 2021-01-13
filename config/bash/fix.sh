
FILES=`ls`

for F in $FILES
do
    if [ "$F" == "fix.sh" ]; then
        continue
    fi
    T=`echo $F | awk -F'-%trash%-' '{print $1}' | sed 's/\://g' | sed 's/-//'| sed 's/-//'`
    P=`echo $F | awk -F'-%trash%-' '{print $2}' | sed 's/\^\^/##/g'`
    N=$T-%TRASH%-$P
    echo $F $N
    mv $F $N
done
