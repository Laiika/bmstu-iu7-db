from peewee import *
from datetime import *

con = PostgresqlDatabase(
    database='postgres',
    user='zhenya_z',
    password='postgres',
    host='127.0.0.1',
    port=5432,
)

class BaseModel(Model):
    class Meta:
        database = con


class Employee(BaseModel):
    id = IntegerField(column_name='id')
    fio = CharField(column_name='fio')
    date_of_birth = DateField(column_name='date_of_birth')
    department = CharField(column_name='department')

    class Meta:
        table_name = 'employee'

class EmployeeVisit(BaseModel):
    id = IntegerField(column_name='id')
    employee_id = ForeignKeyField(Employee, backref='employee_id')
    date = DateField(column_name='date')
    day_of_week =  CharField(column_name='day_of_week')
    time = TimeField(column_name='time')
    type = IntegerField(column_name='type')	

    class Meta:
        table_name = 'employee_visit'

def Task1():
    global con

    cur = con.cursor()

    cur.execute("""
SELECT department
FROM employee
WHERE department NOT IN 
(
    SELECT DISTINCT(department)
    FROM employee
    WHERE EXTRACT (YEARS FROM now()) - EXTRACT (YEARS FROM date_of_birth) < 25
);
""")
    print("Запрос 1:\n")
    rows = cur.fetchall()
    for row in rows:
        print(*row)

    cur.execute("""
SELECT fio
FROM employee_visit ev JOIN employee e ON ev.employee_id = e.id
WHERE date = CURRENT_DATE AND type = 1 AND time = (
    SELECT MIN(time)
    FROM employee_visit
    WHERE date = CURRENT_DATE AND type = 1
);
""")
    print("\nЗапрос 2:\n")
    rows = cur.fetchall()
    for row in rows:
        print(*row)

    cur.execute("""

""")
    print("\nЗапрос 3:\n")
    rows = cur.fetchall()
    for row in rows:
        print(*row)

    cur.close()

def Task2():
    global con

    cur = con.cursor()
	
    print("1. Найти все отделы, в которых нет сотрудников моложе 25 лет")
    query = Employee.select(Employee.department).where(datetime.now().year - Employee.date_of_birth.year < '25')
    deps = query.dicts().execute()
    query = Employee.select(Employee.department).where(Employee.department.not_in(deps))
    for q in query.dicts().execute():
        print(q)

    print("2. Найти сотрудника, который пришел сегодня на работу раньше всех")
    query = EmployeeVisit.select(
        fn.Min(EmployeeVisit.time).alias('min_time')).where(EmployeeVisit.type == 1 and EmployeeVisit.date == date.today())
    min_time = query.dicts().execute()
    query = EmployeeVisit.select(EmployeeVisit.employee_id).where(
        EmployeeVisit.time == min_time[0]['min_time']).where(EmployeeVisit.type == 1 and EmployeeVisit.date == date.today()).limit(1)
    for q in query.dicts().execute():
        print(q)
        
    print("3. Найти сотрудников, опоздавших не менее 5-ти раз")
    query = Employee.select(Employee.id, Employee.fio).join(EmployeeVisit).where(EmployeeVisit.time > '08:00:00').where(EmployeeVisit.type==1).group_by(Employee.id, Employee.fio).having(fn.Count(Employee.id) > 5)
    for q in query.dicts().execute():
        print(q)

    cur.close()
	

def main():
	Task1()
	Task2()

	con.close()

if __name__ == "__main__":
	main()