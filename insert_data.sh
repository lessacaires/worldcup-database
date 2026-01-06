#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Truncate tables teams and games
$PSQL "TRUNCATE teams, games RESTART IDENTITY"
echo "Truncate table teams and games..."
echo "Done."

# Read csv and insert
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WG OG
  do
    if [[ $YEAR != 'year' ]]
      then
        $PSQL "INSERT INTO teams(name) VALUES('$WINNER') ON CONFLICT (name) DO NOTHING"
        $PSQL "INSERT INTO teams(name) VALUES('$OPPONENT') ON CONFLICT (name) DO NOTHING"

        # insert game using looked-uo teams IDs (no hard-core Ids)
        # Insert game using looked-up team IDs (no hard-coded ids)
    $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
           VALUES(
             $YEAR,
             '$ROUND',
             (SELECT team_id FROM teams WHERE name='$WINNER'),
             (SELECT team_id FROM teams WHERE name='$OPPONENT'),
             $WG,
             $OG
           )"
    fi
  done
 



