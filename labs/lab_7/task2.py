from members import member
import json
import psycopg2


def connection():
    con = None
    try:
        con = psycopg2.connect(
            database="kpop_db",
            user="zhenya_z",
            password="postgres",
            host="127.0.0.1",
            port="5432"
        )
    except:
        print("Ошибка при подключении к БД")

    return con


def output_json(array):
    for elem in array:
        print(json.dumps(elem.get()))


def read_table_json(cur, count=10):
    # Возвращает массив кортежей словарей.
    cur.execute("SELECT * FROM members_json")

    rows = cur.fetchmany(count)
    array = list()
    for elem in rows:
        tmp = elem[0]
        array.append(member(tmp['member_id'], tmp['name'], tmp['surname'], tmp['age'],
                          tmp['position'], tmp['group_id']))

    print(*array, sep='\n')

    return array


def update_member(members, id, gid):
    for elem in members:
        if elem.member_id == id:
            elem.group_id = gid

    output_json(members)


def add_member(members, member):
    members.append(member)
    output_json(members)


def task_2():
    con = connection()
    cur = con.cursor()

    # 1. Чтение из JSON документа.
    print('1. Чтение из JSON документа:')
    members_array = read_table_json(cur)

    # 2. Обновление JSON документа.
    print('2. Обновление JSON документа:')
    mid = int(input("Введите id участника: "))
    gid = int(input("Введите id группы: "))
    update_member(members_array, mid, gid)

    # 3. Запись (Добавление) в JSON документ.
    print('3. Запись (Добавление) в JSON документ:')
    add_member(members_array, member(1010, 'Ryujin', 'Shin', 21, 'vocalist', 123))

    cur.close()
    con.close()