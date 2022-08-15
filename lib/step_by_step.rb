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
  
  