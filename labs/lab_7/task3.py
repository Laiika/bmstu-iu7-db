from peewee import *

con = PostgresqlDatabase(
    database='kpop_db',
    user='zhenya_z',
    password='postgres',
    host='127.0.0.1',
    port=5432
)


class BaseModel(Model):
    class Meta:
        database = con


class Groups(BaseModel):
    group_id = PrimaryKeyField(column_name='group_id')
    name = CharField(column_name='name')
    fandom = CharField(column_name='fandom')
    founding_year = IntegerField(column_name='founding_year')
    website = CharField(column_name='website')

    class Meta:
        table_name = 'groups'


class Members(BaseModel):
    member_id = PrimaryKeyField(column_name='member_id')
    name = CharField(column_name='name')
    surname = CharField(column_name='surname')
    age = IntegerField(column_name='age')
    position = CharField(column_name='position')
    group_id = IntegerField(column_name='group_id')

    class Meta:
        table_name = 'members'

# 1. Однотабличный запрос на выборку.
def query_1():
    print('1. Однотабличный запрос на выборку:')
    print('\nУчастники старше 18:\n')

    query = Members.select(Members.member_id, Members.name, Members.age).where(Members.age > 18).limit(5).order_by(Members.member_id)

    for elem in query.dicts().execute():
        print(elem)

# 2. Многотабличный запрос на выборку.
def query_2():
    global con
    print('2. Многотабличный запрос на выборку:')
    print("Группы и их участники:")

    query = Groups.select(Groups.group_id, Groups.name, Members.member_id).join(
        Members, on=(Groups.group_id == Members.group_id)).limit(5)

    for elem in query.dicts().execute():
        print(elem)

# Вывод последних 3-ти записей.
def print_last_3_members():
    print('Последние 3 участника:')
    query = Members.select(Members.member_id, Members.name, Members.surname, Members.age, Members.position, Members.group_id).limit(3).order_by(Members.member_id.desc())
    for elem in query.dicts().execute():
        print(elem)
    print()


def add_member(new_id, new_name, new_surname, new_age, new_position, new_group):
    global con
    try:
        with con.atomic() as txn:
            Members.create(member_id=new_id, name=new_name, surname=new_surname, age=new_age,
                         position=new_position, group_id=new_group)
            print("Участник добавлен")
    except:
        print("Такой участник уже существует")
        txn.rollback()


def update_age(id, new_age):
    member = Members(member_id=id)
    member.age = new_age
    member.save()
    print("Возраст участника обновлен")


def del_member(id):
    print("Участник удален")
    member = Members.get(Members.member_id == id)
    member.delete_instance()

# 3. Три запроса на добавление, изменение и удаление данных в базе данных.
def query_3():
    print('3. Три запроса на добавление, изменение и удаление данных в базе данных:')
    print_last_3_members()

    add_member(1021, 'Yuna', 'Shin', 18, 'vocalist', 123)
    print_last_3_members()

    update_age(1021, 19)
    print_last_3_members()

    del_member(1021)
    print_last_3_members()

# 4. Получение доступа к данным, выполняя только хранимую процедуру.
def query_4():
    print('4. Получение доступа к данным, выполняя только хранимую процедуру:')
    global con
    cursor = con.cursor()

    cursor.execute("CALL set_member_group(%s, %s);", (1, 55))
    # # Фиксируем изменения.
    # # Т.е. посылаем команду в бд.
    # # Метод commit() помогает нам применить изменения,
    # # которые мы внесли в базу данных,
    # # и эти изменения не могут быть отменены,
    # # если commit() выполнится успешно.
    con.commit()

    cursor.close()


def task_3():
    global con

    query_1()
    query_2()
    query_3()
    query_4()

    con.close()