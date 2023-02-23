COPY groups FROM '/var/lib/postgresql/data/groups.csv' delimiter ';' CSV;
COPY members FROM '/var/lib/postgresql/data/members.csv' delimiter ';' CSV;
COPY albums FROM '/var/lib/postgresql/data/albums.csv' delimiter ';' CSV;
COPY songs FROM '/var/lib/postgresql/data/songs.csv' delimiter ';' CSV;
COPY entertainments FROM '/var/lib/postgresql/data/entertainments.csv' delimiter ';' CSV;
COPY brands FROM '/var/lib/postgresql/data/brands.csv' delimiter ';' CSV;
COPY rel_ent_gr FROM '/var/lib/postgresql/data/rel_ent_gr.csv' delimiter ';' CSV;
COPY rel_br_gr FROM '/var/lib/postgresql/data/rel_br_gr.csv' delimiter ';' CSV;