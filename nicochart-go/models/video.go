package models

import (
	"database/sql"
	"fmt"
	"nicochart-go/settings"
	"strconv"
	"time"

	_ "github.com/lib/pq"
)

type Video struct {
	Id            uint64         `db:"id"`
	Title         string         `db:"title"`
	YoutubeId     sql.NullString `db:"youtube_id"`
	NicoId        string         `db:"nico_id"`
	UploadedAt    time.Time      `db:"uploaded_at"`
	CreatedAt     time.Time      `db:"created_at"`
	UpdatedAt     time.Time      `db:"updated_at"`
	ViewsCount    uint32         `db:"views_count"`
	CommentsCount uint32         `db:"comments_count"`
	MylistCount   uint32         `db:"mylist_count"`
	TotalScore    uint32         `db:"total_score"`
	Score         uint32
}

func Get(id string) (*Video, error) {
	var (
		video *Video = &Video{}
		err   error
		db    *sql.DB
	)

	db, err = settings.Db()
	if err != nil {
		return nil, err
	}
	defer db.Close()

	err = db.QueryRow("SELECT * FROM videos WHERE id = $1", id).Scan(
		&video.Id,
		&video.Title,
		&video.YoutubeId,
		&video.NicoId,
		&video.UploadedAt,
		&video.CreatedAt,
		&video.UpdatedAt,
	)
	if err != nil {
		return nil, err
	}

	return video, nil
}

func RankList(rank_type string, order string) (*[]Video, error) {
	var (
		videos []Video
		err    error
		db     *sql.DB
	)

	db, err = settings.Db()
	if err != nil {
		return nil, err
	}
	defer db.Close()

	rows, err := db.Query(fmt.Sprintf(`SELECT  "videos".id, "videos".title, "videos".youtube_id, "videos".nico_id,
																	"videos".uploaded_at, "rankings".views_count, "rankings".comments_count,
																	"rankings".mylist_count, "rankings".total_score
                          FROM "rankings"
                          INNER JOIN
                          "videos" ON "videos"."id" = "rankings"."video_id"
                          WHERE
                          "rankings"."rank_type" = $1
                          ORDER BY %s DESC LIMIT 100`, order), rank_type)

	defer rows.Close()

	for rows.Next() {
		var video Video = Video{}
		err = rows.Scan(
			&video.Id,
			&video.Title,
			&video.YoutubeId,
			&video.NicoId,
			&video.UploadedAt,
			&video.ViewsCount,
			&video.CommentsCount,
			&video.MylistCount,
			&video.TotalScore,
		)
		if err != nil {
			return nil, err
		}

		video.Score = score(order, &video)

		videos = append(videos, video)
	}

	return &videos, nil
}

func ArchiveList(limit uint64, page string) (*[]Video, error) {
	var (
		videos []Video
		err    error
		db     *sql.DB
		offset uint64
	)

	if page == "" {
		offset = 0
	} else {
		page_uint, err := strconv.ParseUint(page, 10, 64)
		if err != nil {
			return nil, err
		}

		offset = limit * page_uint
	}

	db, err = settings.Db()
	if err != nil {
		return nil, err
	}
	defer db.Close()

	rows, err := db.Query(`SELECT  "videos".id, "videos".title, "videos".youtube_id, "videos".nico_id,
													"videos".uploaded_at
                          FROM "videos"
                          ORDER BY uploaded_at DESC
                          LIMIT $1 OFFSET $2`, limit, offset)

	defer rows.Close()

	for rows.Next() {
		var video Video = Video{}
		err = rows.Scan(
			&video.Id,
			&video.Title,
			&video.YoutubeId,
			&video.NicoId,
			&video.UploadedAt,
		)
		if err != nil {
			return nil, err
		}

		videos = append(videos, video)
	}

	return &videos, nil
}

func score(order string, video *Video) uint32 {
	switch order {
	case "total_score":
		return video.TotalScore
	case "views_count":
		return video.ViewsCount
	case "comments_count":
		return video.CommentsCount
	case "mylist_count":
		return video.MylistCount
	}
	return 0
}
