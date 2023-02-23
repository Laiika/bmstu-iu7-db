CREATE OR REPLACE FUNCTION get_albums(group_id INT, first_y INT, last_y INT)
RETURNS TABLE (album_id INT, name VARCHAR, issue_year INT)
AS $$
    plan = plpy.prepare("SELECT album_id, name, issue_year FROM albums WHERE group_id = $1 AND issue_year BETWEEN $2 AND $3", ["int", "int", "int"])
    res = plpy.execute(plan, [group_id, first_y, last_y])
    res_table = []
    if res is not None:
        for row in res:
            res_table.append(row)
    return res_table
$$ LANGUAGE PLPYTHON3U;

SELECT * 
FROM get_albums(33, 2020, 2022);