require 'directory'

describe 'Student Directory' do

		it 'Have an empty array at the beginning' do
			expect(student_list.empty?).to be true
		end

		it 'Have a hash for each student' do
			student_hash = {name: "Marco", cohort: :June}
			expect(student_profile("Marco", "June")).to eq student_hash
		end

		it 'Can add a student to the student list' do
			student_hash = {name: "Marco", cohort: :June}
			expect(add(student_hash)).to eq [student_hash]
		end

		it 'Can add two or more students to the student list' do
			student_hash1 = {name: "Marco", cohort: :June}
			student_hash2 = {name: "Jean", cohort: :June}
			add(student_hash1)
			expect(add(student_hash2)).to eq [student_hash1,student_hash2]
		end

		it 'Can display the student list to the terminal' do
			student_list = [{name: "Marco", cohort: :June},{name: "Jean", cohort: :June}]
			expect(self).to receive(:puts).with("Marco, June cohort")
			expect(self).to receive(:puts).with("Jean, June cohort")
			show(student_list)
		end

		it 'saves a student list to a csv file' do
			csv = double
			add({name: "Marco", cohort: :June})
			expect(CSV).to receive(:open).with(filename = "students.csv", "wb").and_yield(csv)
			expect(csv).to receive(:<<).with(["Marco", :June])
			save_to_file(filename)
		end

		it 'loads a student list from a file called students.csv by default' do
			row = double
			student_profile("Marco","June")
			expect(CSV).to receive(:foreach).with(filename = "students.csv").and_yield(row)
			expect(row).to receive(:[]).with(0)
			expect(row).to receive(:[]).with(1)
			expect(self).to receive(:add)
			load_from_file(filename)
		end

		it 'Can get user input' do
			input = "String"
			expect(STDIN).to receive(:gets).and_return(input+"\n")
			expect(get_user_input).to eq input
		end

		it 'Ask the student name' do
			expect(self).to receive(:puts).with("Enter the name of the student")
			expect(self).to receive(:get_user_input)
			get_student_name
		end

		it 'Ask the student month of the cohort' do
			expect(self).to receive(:puts).with("Enter the month of the cohort")
			expect(self).to receive(:get_user_input)
			get_student_cohort
		end

		it 'prints a menu with options' do
			expect(self).to receive(:puts).with("Main menu\n1-.Add a student\n2-.Show the list of students\n3-.Save the list to a file\n4-.Load a list from a file\n5-.Show students names that begin with an A\n6-.Show students names that have less than 12 letters\n7-.Show students grouped by the cohort that they are in\n9-.Exit the program")
			print_menu_options
		end

	context 'have menu options #' do

		it '1 adds a student' do
			selection = "1"
			expect(self).to receive(:print_menu_options)
			expect(self).to receive(:get_user_input).and_return(selection)
			expect(self).to receive(:get_student_name)
			expect(self).to receive(:get_student_cohort)
			expect(self).to receive(:add)
			menu_options
		end

		it '2 show student list' do
			selection = "2"
			expect(self).to receive(:print_menu_options)
			expect(self).to receive(:get_user_input).and_return(selection)
			expect(self).to receive(:show).with(student_list)
			menu_options
		end

		it '3 save the student list into a csv file called students.csv by default' do
			selection = "3"
			expect(self).to receive(:print_menu_options)
			expect(self).to receive(:get_user_input).and_return(selection)
			expect(self).to receive(:save_to_file)
			menu_options
		end

		it '4 load students from a file' do
			selection = "4"
			expect(self).to receive(:print_menu_options)
			expect(self).to receive(:get_user_input).and_return(selection)
			expect(self).to receive(:load_from_file)
			menu_options
		end

		it '5 Print the names that begin with a letter' do
			selection = "5"
			expect(self).to receive(:print_menu_options)
			expect(self).to receive(:get_user_input).and_return(selection)
			expect(self).to receive(:names_that_begin_with)
			menu_options
		end


		it '6 Print the names that have less that a number of letters' do
			selection = "6"
			expect(self).to receive(:print_menu_options)
			expect(self).to receive(:get_user_input).and_return(selection)
			expect(self).to receive(:names_with_less_than_number_of_letters)
			menu_options
		end

		it '7 Print the student sorted by month of the cohort they are in' do
			selection = "7"
			expect(self).to receive(:print_menu_options)
			expect(self).to receive(:get_user_input).and_return(selection)
			expect(self).to receive(:sort_students_by_cohort_month)
			menu_options
		end

		it '9 exit from the program' do
			selection = "9"
			expect(self).to receive(:print_menu_options)
			expect(self).to receive(:get_user_input).and_return(selection)
			expect(self).to receive(:exit)
			menu_options
		end

		it 'Invalid selection' do
			selection = "invalid selection"
			expect(self).to receive(:print_menu_options)
			expect(self).to receive(:get_user_input).and_return(selection)
			expect(self).to receive(:puts).with("Try again, invalid menu option")
			menu_options
		end

	end

	context 'Have Extras' do

		it 'Shows names that begin with the letter A by default' do
			add({name: "Arco", cohort: :June})
			add({name: "Luis", cohort: :June})
			expect(names_that_begin_with("A")).to eq ([{name: "Arco", cohort: :June}])
		end

		it 'Shows students that their names have less that 12 letters' do
			add({name: "Marcoooooooooooooo", cohort: :June})
			add({name: "Luis", cohort: :June})
			expect(names_with_less_than_number_of_letters(12)).to eq ([{name: "Luis", cohort: :June}])
		end

		it 'Shows students sorted and grouped by their month of the cohort they are in' do
			add({name: "Marco", cohort: :June})
			add({name: "Luis", cohort: :May})
			add({name: "Pedro", cohort: :June})
			expect(sort_students_by_cohort_month).to eq ([{name: "Marco", cohort: :June},{name: "Pedro", cohort: :June},{name: "Luis", cohort: :May}])
		end

	end
	
end