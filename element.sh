#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

PRINT_OUTPUT() {

    if [[ ! $1 =~ ^[0-9]+$ ]]; then
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1';" | sed 's/ //g')
    else
        ATOMIC_NUMBER=$1
    fi

    if [[ -n $ATOMIC_NUMBER ]]; then
        #echo $ATOMIC_NUMBER
        NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER;" | sed 's/ //g')
        #echo $NAME
        SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER;" | sed 's/ //g')
        #echo $SYMBOL
        TYPE=$($PSQL "SELECT types.type FROM elements RIGHT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER;" | sed 's/ //g')
        #echo $TYPE
        MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER;" | sed 's/ //g')
        #echo $MASS
        BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;" | sed 's/ //g')
        #echo $BOILING
        MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;" | sed 's/ //g')
        #echo $MELTING
        #The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    else
        echo "I could not find that element in the database."
    fi
}

if [[ -z $1 ]]; then
    echo "Please provide an element as an argument."
else
    PRINT_OUTPUT $1
fi
