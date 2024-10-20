#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

echo -e "\nRenaming columns weight, melting_point and boiling_point: "
echo $($PSQL "ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;")
echo $($PSQL "ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;")
echo $($PSQL "ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;")
echo -e "\nChanging types of columns melting_point_celsius and boiling_point_celsius: "
echo $($PSQL "ALTER TABLE properties ALTER COLUMN melting_point_celsius TYPE NUMERIC, ALTER COLUMN melting_point_celsius SET NOT NULL;")
echo $($PSQL "ALTER TABLE properties ALTER COLUMN boiling_point_celsius TYPE NUMERIC, ALTER COLUMN boiling_point_celsius SET NOT NULL;")
echo -e "\nAdd the UNIQUE constraint to the symbol and name columns from the element:"
echo $($PSQL "ALTER TABLE elements ADD CONSTRAINT constraint_symbol UNIQUE (symbol);")
echo $($PSQL "ALTER TABLE elements ADD CONSTRAINT constraint_name UNIQUE (name);")
echo -e "\nAddsymbol and name columns should have the NOT NULL constraint:"
echo $($PSQL "ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL;")
echo $($PSQL "ALTER TABLE elements ALTER COLUMN name SET NOT NULL;")
echo -e "\nSet the atomic_number column from the properties table as a foreign key that references the column of the same name in the elements table:"
echo $($PSQL "ALTER TABLE properties ADD CONSTRAINT properties_atomic_number_fkey FOREIGN KEY (atomic_number) REFERENCES elements(atomic_number);")
echo -e "\nCreate a types table that will store the three types of elements:"
echo "- types table should have a type_id column that is an integer and the primary key"
echo "- types table should have a type column that's a VARCHAR and cannot be null." 
echo $($PSQL "CREATE TABLE types(type_id SERIAL PRIMARY KEY, type VARCHAR NOT NULL);")
echo -e "\nInsert three rows to your types table whose values are the three different types from the properties table"
echo $($PSQL "INSERT INTO types(type) SELECT (type) FROM properties;")
echo -e "\nProperties table should have a type_id foreign key column that references the type_id column from the types table. It should be an INT with the NOT NULL constraint"
echo $($PSQL "ALTER TABLE properties ADD COLUMN type_id INT;")
echo $($PSQL "ALTER TABLE properties ADD CONSTRAINT properties_type_id_fkey FOREIGN KEY (type_id) REFERENCES types(type_id);")
echo $($PSQL "UPDATE properties SET type_id = types.type_id FROM types WHERE properties.type = types.type AND properties.type IS NOT NULL AND types.type IS NOT NULL AND properties.atomic_number IS NOT NULL;")
echo $($PSQL "ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL;")
echo -e "\nCapitalize the first letter of all the symbol values in the elements table. Be careful to only capitalize the letter and not change any others"
echo $($PSQL "UPDATE elements SET symbol = UPPER(symbol);")
echo -e "\nRemove all the trailing zeros after the decimals from each row of the atomic_mass column"
echo $($PSQL "ALTER TABLE properties ALTER COLUMN atomic_mass TYPE DECIMAL;")
echo $($PSQL "UPDATE properties SET atomic_mass=trim(trailing '0' from atomic_mass::text)::DECIMAL;")
echo -e "\nAdd the element with atomic number 9 to your database. Its name is Fluorine, symbol is F, mass is 18.998, melting point is -220, boiling point is -188.1, and it's a nonmetal"
echo $($PSQL "INSERT INTO elements(atomic_number, name, symbol) VALUES (9, 'Fluorine', 'F');INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type, type_id) VALUES (9, 18.998, -220, -188.1, 'nonmetal', 1);")
echo -e "\nAdd the element with atomic number 10 to your database. Its name is Neon, symbol is Ne, mass is 20.18, melting point is -248.6, boiling point is -246.1, and it's a nonmetal"
echo $($PSQL "INSERT INTO elements(atomic_number, name, symbol) VALUES (10, 'Neon', 'Ne');INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type, type_id) VALUES (10, 20.18, -248.6, -246.1, 'nonmetal', 1);")

echo -e "\nCreate a periodic_table folder in the project folder and turn it into a git repository with git init. Repository should have a main branch with all your commits"
mkdir periodic_table
cd periodic_table
git init -b main
echo -e "\nYour periodic_table repo should have at least five commits"
echo -e "\n1. Initial commit - create element.sh"
touch element.sh
git add element.sh
git commit -m "Initial commit"
echo -e "\n2. Exec permissions element.sh and shebang"
chmod +x element.sh
echo '#!/bin/bash' >> element.sh
git add element.sh
git commit  -m "feat: Add shebang"
echo 'PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"' >> element.sh
git add element.sh
git commit  -m "feat: Add PSQL variable"
cp ../element.sh element.sh
git add element.sh
git commit -m "refactor: Full solution"
echo '#Just run fixdb.sh make whole solution' >> element.sh 
git add element.sh
git commit -m "refactor: Add main runner comment"
touch logger.log 
./element.sh 1>> logger.log
git add logger.log
git commit -m "test: Log functionality"

echo -e "\nDelete the non existent element, whose atomic_number is 1000, from the two tables"
echo $($PSQL "DELETE FROM properties WHERE atomic_number=1000;")
echo $($PSQL "DELETE FROM elements WHERE atomic_number=1000;")
echo -e "\mProperties table should not have a type column"
echo $($PSQL "ALTER TABLE properties DROP COLUMN type;")