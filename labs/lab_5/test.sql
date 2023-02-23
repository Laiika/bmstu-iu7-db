SELECT
    json_extract_path(info, 'fandom') fandom_name,
    json_extract_path(info, 'color') fandom_color
FROM for_task3
WHERE info IS NOT NULL;