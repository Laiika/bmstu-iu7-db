class member():
    member_id = int()
    name = str()
    surname = str()
    age = int()
    position = str()
    group_id = int()

    def __init__(self, member_id, name, surname, age, position, group_id):
        self.member_id = member_id
        self.name = name
        self.surname = surname
        self.age = age
        self.position = position
        self.group_id = group_id

    def get(self):
        return {'member_id': self.member_id, 'name': self.name, 'surname': self.surname, 'age': self.age,
                'position': self.position, 'group_id': self.group_id}

    def __str__(self):
        return f"{self.member_id, self.name, self.surname, self.age, self.position, self.group_id}"


class group():
    group_id = int()
    name = str()
    fandom = str()
    founding_year = int()
    website = str()

    def __init__(self, group_id, name, fandom, founding_year, website):
        self.group_id = group_id
        self.name = name
        self.fandom = fandom
        self.founding_year = founding_year
        self.website = website

    def get(self):
        return {'group_id': self.group_id, 'name': self.name, 'fandom': self.fandom, 'founding_year': self.founding_year,
                'website': self.website}

    def __str__(self):
        return f"{self.group_id, self.name, self.fandom, self.founding_year, self.website}"


# Создает коллекцию объектов из файла
def create_members(file_name):
    file = open(file_name, 'r')
    members = list()

    for line in file:
        arr = line.split(';')
        arr[0], arr[3], arr[5] = int(arr[0]), int(arr[3]), int(arr[5].strip("\n"))
        members.append(member(*arr).get())

    return members


# Создает коллекцию объектов из файла
def create_groups(file_name):
    file = open(file_name, 'r')
    groups = list()

    for line in file:
        arr = line.split(';')
        arr[0], arr[3] = int(arr[0]), int(arr[3])
        groups.append(group(*arr).get())

    return groups