require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

puts "EventManager Initialized"

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
        ).officials
    rescue
        'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end
end

def save_thank_you_letter(id, from_letter)
    Dir.mkdir('output') unless Dir.exist?('output')

    filename = "output/thanks_#{id}.html"

    File.open(filename, 'w') do |file|
        file.puts from_letter
    end
end

def clean_phone_number(phone_number)
    phone_number.to_s.gsub!(/\D/, "")
    if phone_number.length == 10
        phone_number
    elsif phone_number.length == 11 && phone_number[0] == 1 
        phone_number..slice[1]
    else 
        "Bad number"
    end
end

def most_activate(hash)
    hash.key(hash.values.max)
end
  

contents = CSV.open(
    'event_attendees.csv',
    headers: true,
    header_converters: :symbol
  )

hour_list = Hash.new(0)
day_list = Hash.new(0)

days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

template_letter = File.read('from_letter.erb')
erb_template = ERB.new template_letter

contents.each do |row|
    id = row[0]
    name = row[:first_name]
  
    zipcode = clean_zipcode(row[:zipcode])

    phone_number = clean_phone_number(row[:homephone])

    date= DateTime.strptime(row[:regdate], '%m/%d/%y %H:%M')

    hour_list[date.hour] += 1

    day_list[days[date.wday]] += 1
    
    # legislators = legislators_by_zipcode(zipcode)

    # from_letter = erb_template.result(binding)

    # save_thank_you_letter(id, from_letter)
    puts "#{name} #{phone_number} #{date}"
end


puts "Most activate hour: " << most_activate(hour_list).to_s

puts "Most activate day: " << most_activate(day_list)
