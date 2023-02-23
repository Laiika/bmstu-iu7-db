from task1 import *
from task2 import *
from task3 import *

def main():
	answer = int(input("Номер задания: "))
	
	if answer == 1:
		task_1()
	elif answer == 2:
		task_2()
	elif answer == 3:
		task_3()

if __name__ == "__main__":
	main()