package settings

import (
	"database/sql"
	"log"

	_ "github.com/lib/pq"
)

func Db() (*sql.DB, error) {
	var (
		db  *sql.DB
		err error
	)

	config, err := BuildFromFile("../config/database.yml")
	if err != nil {
		log.Fatal(err)
	}

	db, err = sql.Open("postgres", "user="+config.DbUser+" password="+config.DbPassword+" dbname="+config.DbName+" sslmode=disable")
	if err != nil {
		return nil, err
	}

	db.SetMaxIdleConns(10)
	db.SetMaxOpenConns(20)

	return db, nil
}
