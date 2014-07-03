require 'csv'

def student_list
	@students ||= []
end

def student_profile(name, cohort)
	return {name: name, cohort: cohort.to_sym} if cohort != nil
end

def add(student)
	student_list << student
end

def names_that_begin_with(letter = "A")
	student_list.select {|student| student[:name].start_with?(letter)}
end

def sort_students_by_cohort_month
	student_list.sort_by {|student| student[:cohort]}
end

def names_with_less_than_number_of_letters(number)
	student_list.select {|student| student[:name].length <= number}
end

def show(list)
	return list.each {|student| puts "#{student[:name]}, #{student[:cohort]} cohort"} if list != nil
end

def save_to_file(filename = "students.csv")
	CSV.open(filename, "wb") do |csv|
		student_list.each {|student| csv << student_values(student)}
			#student_list.each {|student|  csv << student.values}
	end
end

def student_values(student)
	student.values
end

def load_from_file(filename = "students.csv")
	CSV.foreach(filename) do |row|
		name, cohort = row[0], row[1]
		add(student_profile(name,cohort))
	end
end

def get_user_input
	STDIN.gets.chomp
end

def get_student_name
	puts "Enter the name of the student"
	get_user_input
end

def get_student_cohort
	puts "Enter the month of the cohort"
	get_user_input
end

def print_menu_options
	puts "Main menu\n1-.Add a student\n2-.Show the list of students\n3-.Save the list to a file\n4-.Load a list from a file\n5-.Show students names that begin with an A\n6-.Show students names that have less than 12 letters\n7-.Show students grouped by the cohort that they are in\n9-.Exit the program"	
end

def menu_options
	print_menu_options
	menu_selection = get_user_input
	case menu_selection
	when "1"
		add(student_profile(get_student_name,get_student_cohort))
	when "2"
		show(student_list)
	when "3"
		save_to_file
	when "4"
		load_from_file
	when "5"
		show(names_that_begin_with("A"))
	when "6"
		show(names_with_less_than_number_of_letters(12))
	when "7"
		show(sort_students_by_cohort_month)
	when "9"
		exit
	else
		puts "Try again, invalid menu option"
	end
end

def interactive_menu
	loop do
		menu_options
	end
end
