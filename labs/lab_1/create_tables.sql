CREATE TABLE IF NOT EXISTS groups(
    group_id INT PRIMARY KEY,
	name VARCHAR(100),
    fandom VARCHAR(100),
    founding_year INT,
    website VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS members(
    member_id INT PRIMARY KEY,
	name VARCHAR(100),
    surname VARCHAR(100),
	age INT,
    position VARCHAR(100),

	group_id INT,
	FOREIGN KEY (group_id) REFERENCES groups(group_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS albums(
    album_id INT PRIMARY KEY,
    name VARCHAR(50),
    issue_year INT,
    sales BIGINT,

	group_id INT,
	FOREIGN KEY (group_id) REFERENCES groups(group_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS songs(
    song_id INT PRIMARY KEY,
	name VARCHAR(100),
	author VARCHAR(100),
	genre VARCHAR(100),
	duration FLOAT,

	album_id INT,
	FOREIGN KEY (album_id) REFERENCES albums(album_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS entertainments(
    entertainment_id INT PRIMARY KEY,
	name VARCHAR(100),
    founding_year INT,
    founder VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS rel_ent_gr(
    entertainment_id INT,
    group_id INT,
    FOREIGN KEY (entertainment_id) REFERENCES entertainments(entertainment_id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES groups(group_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS brands(
    brand_id INT PRIMARY KEY,
	name VARCHAR(100),
    founding_year INT,
    founder VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS rel_br_gr(
    brand_id INT,
    group_id INT,
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES groups(group_id) ON DELETE CASCADE
);
