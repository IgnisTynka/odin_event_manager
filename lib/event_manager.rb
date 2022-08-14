# puts "EventManager Initialized"

#reading the file:
# contents = File.read "event_attendees.csv"
# puts contents

#reading the file by line:
# lines = File.readlines "event_attendees.csv"
# lines.each do |line|
#     puts line
# end 

#display the first name
# lines = File.readlines "event_attendees.csv"
# lines.each do |line|
#     columns = line.split(",")
#     name = columns[2]
#     puts name
# end 


# skippinf=g the Header Row
lines = File.readlines "event_attendees.csv"
lines.each_with_index do |line, index|
    next if index == 0 
    columns = line.split(",")
    name = columns[2]
    puts name
end 