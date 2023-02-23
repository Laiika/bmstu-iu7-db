CREATE TABLE IF NOT EXISTS members_json
(
    doc JSON
);

COPY
(
	SELECT row_to_json(ms) 
    FROM members ms
)
TO '/var/lib/postgresql/data/members.json';

COPY members_json 
FROM '/var/lib/postgresql/data/members.json';


CREATE OR REPLACE PROCEDURE set_member_group(_id INT, new_group INT)
AS '
BEGIN
	UPDATE members
    SET group_id = new_group
    WHERE member_id = _id;
END;
' LANGUAGE plpgsql;
