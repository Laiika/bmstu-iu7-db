from faker import Faker
from random import randint, choice, uniform

MAX = 1000
LINKS = 500


def GenerateGroups():
    faker = Faker()
    result = open("data/groups.csv", "w")

    for i in range(MAX):
        line = "{0};{1};{2};{3};{4}\n".format(
            i + 1,
            faker.word(),
            faker.word(),
            randint(1990, 2022),
            faker.url())
        result.write(line)

    result.close()


def GenerateMembers():
    faker = Faker()
    result = open("data/members.csv", "w")
    pos = ['vocalist', 'rapper']

    for i in range(MAX):
        line = "{0};{1};{2};{3};{4};{5}\n".format(
            i + 1,
            faker.first_name(),
            faker.last_name(),
            randint(10, 50),
            choice(pos),
            randint(1, 999))
        result.write(line)

    result.close()


def GenerateAlbums():
    faker = Faker()
    result = open("data/albums.csv", "w")

    for i in range(MAX):
        line = "{0};{1};{2};{3};{4}\n".format(
            i + 1,
            faker.word(),
            randint(1992, 2022),
            randint(100000, 1000000000),
            randint(1, 999))
        result.write(line)

    result.close()


def GenerateSongs():
    faker = Faker()
    result = open("data/songs.csv", "w")
    genre = ['rock', 'r&b', 'pop', 'jazz', 'hip-hop', 'electronic']

    for i in range(MAX):
        line = "{0};{1};{2};{3};{4};{5}\n".format(
            i + 1,
            faker.word(),
            faker.name(),
            choice(genre),
            round(uniform(1.5, 5.5), 2),
            randint(1, 999))
        result.write(line)

    result.close()


def GenerateEntertainments():
    faker = Faker()
    result = open("data/entertainments.csv", "w")

    for i in range(MAX):
        line = "{0};{1};{2};{3};{4}\n".format(
            i + 1,
            faker.company(), 
            randint(1970, 2022),
            faker.name(),
            faker.country())
        result.write(line)

    result.close()


def GenerateBrands():
    faker = Faker()
    result = open("data/brands.csv", "w")

    for i in range(MAX):
        line = "{0};{1};{2};{3}\n".format(
            i + 1,
            faker.company(), 
            randint(1800, 2022),
            faker.name())
        result.write(line)

    result.close()


def GenerateRelations():
    faker = Faker()
    result = open("data/rel_ent_gr.csv", "w")
    id = 1
    for i in range(LINKS):
        for _ in range(randint(1, 5)):
            line = "{0};{1}\n".format(
                randint(1, 999),
                id)
            result.write(line)
        id += 1

    result.close()

    result = open("data/rel_br_gr.csv", "w")
    id = 1
    for i in range(LINKS):
        for _ in range(randint(1, 5)):
            line = "{0};{1}\n".format(
                randint(1, 999),
                id)
            result.write(line)
        id += 1

    result.close()


if __name__ == "__main__":
    GenerateGroups()
    GenerateMembers()
    GenerateAlbums()
    GenerateSongs()
    GenerateEntertainments()
    GenerateBrands()
    GenerateRelations()