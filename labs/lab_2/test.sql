SELECT issue_year, COUNT(*) AS number_of_songs
FROM albums A INNER JOIN songs AS S ON A.album_id = S.album_id
GROUP BY issue_year
ORDER BY issue_year;
