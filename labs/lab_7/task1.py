from py_linq import Enumerable
from members import *


# Участники младше 20 лет, отсортированные по возрасту
def req_1(members):
	result = members.where(lambda x: x['age'] < 20).order_by(lambda x: x['age']).select(lambda x: {x['member_id'], x['name'], x['age']})
	return result

# Количество участников, младше 20
def req_2(members):
	result = members.count(lambda x: x['age'] < 20)
	return result

# Минимальный, максимальный возраст участников
def req_3(members):
	age = Enumerable([{members.min(lambda x: x['age']), members.max(lambda x: x['age'])}])	
	return age

# Группировка по группам
def req_4(members):
	result = members.group_by(key_names=['group_id'], key=lambda x: x['group_id']).select(lambda g: {'group_id': g.key.group_id, 'cnt': g.count()})
	return result


def req_5(members, groups):
	result = members.join(groups, lambda ms: ms['group_id'], lambda gs: gs['group_id'])
	return result


def task_1():
	members = Enumerable(create_members('data/members.csv'))
	groups = Enumerable(create_groups('data/groups.csv'))

	print('\n1. Участники младше 20 лет, отсортированные по возрасту:')
	for elem in req_1(members): 
		print(elem)

	print(f'\n2. Количество участников, младше 20 = {str(req_2(members))}')

	print('\n3. Минимальный, максимальный возраст участников:')
	for elem in req_3(members): 
		print(elem)

	print('\n4. Группировка по группам:')
	for elem in req_4(members): 
		print(elem)

	print('\n5. Join участников и групп:')
	for elem in req_5(members, groups): 
		print(elem)