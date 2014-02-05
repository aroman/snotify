require "net/http"
require "uri"
require "json"
require 'terminal-notifier'

URL_ROOT = "http://closings.victorlourng.com/"

def fetch_json
	uri = URI.parse(URL_ROOT + "api/?all")

	http = Net::HTTP.new(uri.host, uri.port)
	request = Net::HTTP::Get.new(uri.request_uri)

	response = http.request(request)

	if response.code == "200"
		return JSON.parse(response.body)
	end
end

schools = Array.new
counter = 0

fetch_json().each {|item| schools.push(item['name'])}
puts "#{schools.length} schools already accounted for\n"

loop do
	counter += 1
	STDOUT.write " ❄ x #{counter}\r"
	fetch_json().each do |item|
		if !schools.include?(item['name'])
			TerminalNotifier.notify(item['name'], 
				:title => item['status'],
				:sender => "com.apple.safari",
				:sound => 'Blow'
			)
			schools.push item['name']
		end
	end
	sleep 5
end