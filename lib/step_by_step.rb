require 'csv'
puts "EventManager Initialized"

#Reading the file:
contents = File.read "event_attendees.csv"
puts contents

#Reading the file by line:
lines = File.readlines "event_attendees.csv"
lines.each do |line|
    puts line
end 

#Display the first name
lines = File.readlines "event_attendees.csv"
lines.each do |line|
    columns = line.split(",")
    name = columns[2]
    puts name
end 

# Skipping the Header Row
lines = File.readlines "event_attendees.csv"
lines.each_with_index do |line, index|
    next if index == 0 
    columns = line.split(",")
    name = columns[2]
    puts name
end 

#Switching over to use the CSV Library
contents = CSV.open('event_attendees.csv', headers: true)
contents.each do |row|
    name = row[2]
    puts name
end

#Accessing Columns by their Names
contents = CSV.open(
    'event_attendees.csv',
    headers: true,
    header_converters: :symbol
)
contents.each do |row|
    name = row[:first_name]
    puts name
end

#Displaying the Zip Codes of All Attendees
#and
#Handling Bad and Good Zip Codes and Missing Zip Codes
contents = CSV.open(
    'event_attendees.csv',
    headers: true,
    header_converters: :symbol
)

contents.each do |row|
    name = row[:first_name]
    zipcode = row [:zipcode]
    if zipcode.nil?
        zipcode = '00000'
    elsif zipcode.length < 5
        zipcode = zipcode.rjust(5, '0')
    elsif zipcode.length > 5
        zipcode = zipcode[0..4]
    end
    puts "#{name} #{zipcode}"
end

#Moving Clean Zip Codes to a Method
def clean_zipcode(zipcode)
    if zipcode.nil?
        zipcode = '00000'
    elsif zipcode.length < 5
        zipcode = zipcode.rjust(5, '0')
    elsif zipcode.length > 5
        zipcode = zipcode[0..4]
    else 
        zipcode
    end
end

contents = CSV.open(
    'event_attendees.csv',
    headers: true,
    header_converters: :symbol
  )
  
contents.each do |row|
    name = row[:first_name]
  
    zipcode = clean_zipcode(row[:zipcode])
  
    puts "#{name} #{zipcode}"
end

#Refactoring Clean Zip Codes
def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5, '0')[0..4]
  end
  
  contents = CSV.open(
      'event_attendees.csv',
      headers: true,
      header_converters: :symbol
    )
    
  contents.each do |row|
      name = row[:first_name]
    
      zipcode = clean_zipcode(row[:zipcode])
    
      puts "#{name} #{zipcode}"
  end
  
# With html file
def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

    begin
        legislators = civic_info.representative_info_by_address(
            address: zip,
            levels: 'country',
            roles: ['legislatorUpperBody', 'legislatorLowerBody']
        )

        legislators = legislators.officials

        legislator_name = legislators.map do |legislator|
            legislator.name
        end
        #  legislator_name = legislators.map(&:name) <- this line do the same 

        legislators_string = legislator_name.join(", ")
    rescue
        'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end
end

contents = CSV.open(
    'event_attendees.csv',
    headers: true,
    header_converters: :symbol
  )

template_letter = File.read('from_letter.html')  

contents.each do |row|
    name = row[:first_name]
  
    zipcode = clean_zipcode(row[:zipcode])

    legislators = legislators_by_zipcode(zipcode)

    personal_letter = template_letter.gsub('FIRST_NAME', name)
    personal_letter.gsub!('LEGISLATORS', legislators)

    puts personal_letter
end
  