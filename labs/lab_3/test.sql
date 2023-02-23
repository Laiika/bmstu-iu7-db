CREATE OR REPLACE TRIGGER insert_in_tables
AFTER INSERT ON members
FOR EACH ROW
EXECUTE FUNCTION func_insert();

CREATE OR REPLACE TRIGGER insert_in_tables2
AFTER INSERT ON groups
FOR EACH ROW
EXECUTE FUNCTION func_insert();

CREATE OR REPLACE TRIGGER insert_in_tables3
AFTER INSERT ON albums
FOR EACH ROW
EXECUTE FUNCTION func_insert();

CREATE OR REPLACE TRIGGER insert_in_tables4
AFTER INSERT ON songs
FOR EACH ROW
EXECUTE FUNCTION func_insert();

CREATE OR REPLACE TRIGGER insert_in_tables5
AFTER INSERT ON entertainments
FOR EACH ROW
EXECUTE FUNCTION func_insert();

CREATE OR REPLACE TRIGGER insert_in_tables6
AFTER INSERT ON brands
FOR EACH ROW
EXECUTE FUNCTION func_insert();

CREATE OR REPLACE TRIGGER insert_in_tables7
AFTER INSERT ON rel_br_gr
FOR EACH ROW
EXECUTE FUNCTION func_insert();

CREATE OR REPLACE TRIGGER insert_in_tables8
AFTER INSERT ON rel_ent_gr
FOR EACH ROW
EXECUTE FUNCTION func_insert();


select *
from about_tables at2 ;

INSERT
INTO members (member_id, name, surname, age, position, group_id)
SELECT MAX(member_id) + 1, 'Jisoo', 'Kim', 18, 'vocalist', 3
FROM members;

select *
from about_tables at2 ;