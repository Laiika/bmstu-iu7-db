import psycopg2


def start_connection():
    try:
        connection = psycopg2.connect(
            database="kpop_db",
            user="zhenya_z",
            password="postgres",
            host="127.0.0.1",
            port="5432",
        )
        return connection
    except Exception as e:
        print(f'Ошибка: {e}')


def stop_program(cursor):
    cursor.close()
    exit(0)

# Получить возраст самого младшего среди всех участников
def task1(cursor):
    cursor.execute("""
        SELECT MIN(age)
        FROM members;
        """)

    result = cursor.fetchone()[0]
    print(f'Самому младшему участнику {result} лет')
    return result

# Получить число песен в каждом альбоме указанной группы
def task2(cursor):
    try:
        id = int(input('Введите id группы: '))
    except ValueError as e:
        print("Ошибка ввода")
        return

    cursor.execute(f"""
        SELECT als.album_id AS id, COUNT(*) AS number_of_songs
        FROM groups gs 
        INNER JOIN albums AS als ON gs.group_id = als.group_id
        INNER JOIN songs AS ss ON als.album_id = ss.album_id
        where als.group_id = '{id}'
        GROUP BY als.album_id
        ORDER BY als.album_id;
        """)

    for row in cursor:
        print(f'album id: {row[0]}, number of songs: {row[1]}')

# Получить средний возраст вокалистов в каждой группе
def task3(cursor):
    cursor.execute("""
        WITH mems_vocal AS
        (
            SELECT *
            FROM members m
            WHERE m.position = 'vocalist'
        )
        SELECT group_id, member_id, age, AVG(age)  OVER(PARTITION BY group_id) avg_age
        FROM mems_vocal;
        """)

    for row in cursor:
        print(f'group id {row[0]}, member_id {row[1]}, age {row[2]}, avg_age {row[3]}')

# Получить поля и их типы для заданной таблицы
def task4(cursor):
    table_name = input('Введите название таблицы: ')

    cursor.execute(f"""
        SELECT column_name, data_type, is_nullable
        FROM information_schema.columns
        WHERE table_name = '{table_name}';
        """)

    for row in cursor:
        print(f'{row[0]}, {row[1]}, {row[2]}')

# Получить количество альбомов, выпущенных указанной группой за конкретный год
def task5(cursor):
    try:
        id = int(input('Введите group_id: '))
        year = int(input('Введите год выпуска: '))
    except ValueError as e:
        print("Ошибка ввода")
        return

    cursor.execute(f"""
        SELECT count_albums('{id}', '{year}');
        """)

    count = cursor.fetchone()[0]
    print(f"Количество альбомов, выпущенных указанной группой за {year} год = {count}")

# Получить все альбомы с продажами выше средних за указанный год
def task6(cursor):
    cursor.execute(f"""
        SELECT *
        FROM popular_albums(2015);
        """)

    for album_id, name, sales in cursor:
        print(f'album_id: {album_id}, name: {name}, sales: {sales}')

# Увеличить продажи альбома
def task7(cursor):
    try:
        id = int(input("Введите album_id: "))
        inc = int(input("Введите, сколько добавить: "))
    except ValueError as e:
        print("Ошибка ввода")
        return

    cursor.execute(f"""
        CALL inc_album_sales({id}, {inc});
        """)

# Получить имя текущей базы данных и имя пользователя в текущем контексте выполнения
def task8(cursor):
    cursor.execute("""
        SELECT current_database(), current_user;
        """)
    db, user = cursor.fetchone()

    print(f"db : {db}, user : {user}")

# Создание таблицы сотрудников компании
def task9(cursor):
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS ent_empls(
            empl_id INT PRIMARY KEY,
	        name VARCHAR(100),
	        job VARCHAR(100),
            entertainment_id INT,
            FOREIGN KEY (entertainment_id) REFERENCES entertainments(entertainment_id) ON DELETE CASCADE
        );""")

# Добавить сотрудника
def task10(cursor):
    cursor.execute("""
        SELECT * 
        FROM INFORMATION_SCHEMA.TABLES 
        WHERE TABLE_NAME='ent_empls';
        """)

    if not cursor.fetchone():
        print("Таблица не создана")
        return

    try:
        name = input('Введите имя сотрудника: ')
        job = input('Введите должность сотрудника: ')
        id = int(input('Введите id компании сотрудника: '))
    except ValueError as e:
        print("Ошибка ввода")
        return

    cursor.execute("""
        SELECT * 
        FROM ent_empls;
        """)

    if not cursor.fetchone():
        try:
            cursor.execute(f"""
                INSERT INTO ent_empls VALUES
                (1, '{name}', '{job}', '{id}');
            """)
        except Exception as e:
            print(f'Ошибка: {e}')
            return
    else:
        try:
            cursor.execute(f"""
                INSERT INTO ent_empls
                SELECT MAX(empl_id) + 1, '{name}', '{job}', '{id}'
                FROM ent_empls;
            """)
        except Exception as e:
            print(f'Ошибка: {e}')
            return


def get_action(action_number):
    if action_number == 11:
        return stop_program
    elif action_number == 1:
        return task1
    elif action_number == 2:
        return task2
    elif action_number == 3:
        return task3
    elif action_number == 4:
        return task4
    elif action_number == 5:
        return task5
    elif action_number == 6:
        return task6
    elif action_number == 7:
        return task7
    elif action_number == 8:
        return task8
    elif action_number == 9:
        return task9
    elif action_number == 10:
        return task10
    else:
        print('Нет такого пункта')


def work(connection):
    cursor = connection.cursor()
    command = 1

    while command != 11:
        print("\nМеню:\n")
        print("1. Найти минимальный возраст среди всех участников")
        print("2. Вывести число песен в каждом альбоме указанной группы")
        print("3. Вывести средний возраст вокалистов в каждой группе")
        print("4. Вывести поля и их типы для заданной таблицы")
        print("5. Вызвать скалярную функцию из 3й ЛР")
        print("6. Вызвать табличную функцию из 3й ЛР")
        print("7. Вызвать хранимую процедуру из 3й ЛР")
        print("8. Вызвать системную функцию")
        print("9. Создать таблицу сотрудников компании")
        print("10. Добавить сотрудника в таблицу")
        print("\n11. Выход\n")

        try:
            command= int(input())
            action = get_action(command)
            action(cursor)
        except Exception as e:
            print(f'Ошибка: {e}')

        connection.commit()


def main():
    connection = start_connection()
    if connection is None:
        exit(1)

    work(connection)
    connection.close()


if __name__ == '__main__':
    main()