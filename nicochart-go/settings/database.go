package settings

import (
	"database/sql"

	_ "github.com/lib/pq"
)

func Db() (*sql.DB, error) {
	var (
		db  *sql.DB
		err error
	)

	db, err = sql.Open("postgres", "user=dev password=321321 dbname=nico_chart_dev sslmode=disable")
	if err != nil {
		return nil, err
	}

	db.SetMaxIdleConns(10)
	db.SetMaxOpenConns(20)

	return db, nil
}
