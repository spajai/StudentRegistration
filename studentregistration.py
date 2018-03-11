records = {
           'students' : {},
           'courses' : {},
           'results' : {}
          }
def add_course():
    course_code = input("Please enter course code: \n")
    if course_code in records['courses'].keys():
        print("course already exist")
        return
    course_name = input("Please enter course name: \n")
    records['courses'][course_code] = course_name

def add_student():
    student_id = input("Please enter student ID: \n")
    if student_id in records['students'].keys():
        print("student already exist")
        return
    student_name = input("Please enter student name: \n")
    records['students'][student_id] = student_name

def add_result():
    student_id = input("Please enter student ID: \n")
    if student_id not in records['students'].keys():
        print("%s Student does not exist"%student_id)
        add_result()
    while True:
        course_code = input("Please enter course code: \n")
        if course_code in records['courses'].keys():
            break
        else:
            print("Course does not exist")
    while True:
        try:
            score = float(input("Please enter final score: \n"))
        except:
            print("Score is not between 0.0 and 100.0 inclusive.")
            continue
        if 0 <= score and score <= 100:
            break
        else:
            print("Score is not between 0.0 and 100.0 inclusive.")

    if student_id not in records['results'].keys():
        records['results'][student_id] = {}
    records['results'][student_id][course_code] = score 

def view_course_result(course_code):
    course_results = {}
    for sid, record in records['results'].items():
        if course_code in record.keys():
            course_results[records['students'][sid]] = record[course_code]
    if course_results:
        for key, value in course_results.items():
            print(key , "   " , value)
        print("Maximum score: ", max(course_results.values()))
        print("Minimum score: ", min(course_results.values()))
    else:
        print("No record found")

def view_student_result(sid):
    if sid not in records['students'].keys():
        print("Student not Exist")
        sid = input("Please enter student id: ")
        view_student_result(sid)
    if sid in records['results'].keys():
        total_marks = 0
        for course_code, mark in records['results'][sid].items():
            total_marks += mark
            print(records['courses'][course_code] , "   ", mark)
        print("Avarage marks: " , total_marks/len(records['results'][sid].keys()))
    else:
        print("No record found")

def main():
    print("Main Menu - please select an option:")
    print("1.) Add a course ")
    print("2.) Add a student")
    print("3.) Add result")
    print("4.) View Results")
    print("5.) Quit")
    menu = int(input("Enter your choice:\n"))
    if menu == 1:
        while True:
            add_course()  
            ch = input("Would you like to [A]dd a new course or [R]eturn to the previous menu?: \n")
            if ch.upper() == 'A':
                continue
            else:
                main()
    elif menu == 2:
        while True:
            add_student()
            ch = input("Would you like to [A]dd a new student or [R]eturn to the previous menu?: \n")
            if ch.upper() == 'A':
                continue
            else:
                main()
    elif menu == 3:
        while True:
            add_result()
            ch = input("Would you like to [A]dd a new result or [R]eturn to the previous menu?: \n")
            if ch.upper() == 'A':
                continue
            else:
                main()
    elif menu == 4:
        while True:
            chv = input("Would you like to view [C]ourse results, [S]tudent results or [R]eturn? \n")
            if chv.upper() == 'C':
                course_code = input("Please enter course code: \n")
                view_course_result(course_code)
            elif chv.upper() == 'S':
                sid = input("Please enter student id: \n")
                view_student_result(sid)
            else:
                print("Wrong Input....")
                main()
    elif menu == 5:
        print("Goodbye !!")
        exit()
    else:
        print("Invalid choice!!")
        main()
main()

