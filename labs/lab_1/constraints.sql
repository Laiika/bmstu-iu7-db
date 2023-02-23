ALTER TABLE groups 
ADD CONSTRAINT gr_year_constraint CHECK (founding_year BETWEEN 1990 AND 2022);

ALTER TABLE members 
ADD CONSTRAINT age_constraint CHECK (age BETWEEN 10 AND 50);

ALTER TABLE albums 
ADD CONSTRAINT sales_constraint CHECK (sales > 0),
ADD CONSTRAINT issue_constraint CHECK (issue_year BETWEEN 1992 AND 2022);

ALTER TABLE songs 
ADD CONSTRAINT dur_constraint CHECK (duration > 0);

ALTER TABLE entertainments 
ADD CONSTRAINT ent_year_constraint CHECK (founding_year BETWEEN 1970 AND 2022);

ALTER TABLE brands
ADD CONSTRAINT br_year_constraint CHECK (founding_year BETWEEN 1800 AND 2022);