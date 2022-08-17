require 'csv'
require 'google/apis/civicinfo_v2'

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

from_letter = %{
    <html>
    <head>
      <meta charset='UTF-8'>
      <title>Thank You!</title>
    </head>
    <body>
      <h1>Thanks FIRST_NAME!</h1>
      <p>Thanks for coming to our conference.  We couldn't have done it without you!</p>
    
      <p>
        Political activism is at the heart of any democracy and your voice needs to be heard.
        Please consider reaching out to your following representatives:
      </p>
    
      <table>
        <tr><th>Legislators</th></tr>
        <tr><td>LEGISLATORS</td></tr>
      </table>
    </body>
    </html>
}