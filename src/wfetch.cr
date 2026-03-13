require "http/client"
require "json"
require "toml"
require "./icon-list"
require "option_parser"

module Wfetch
  VERSION = "0.1.0"
  orange = "\e[38;5;214m"
  red = "\e[38;5;52m"
  bold = "\033[1m"
  reset = "\e[0m"

  puts "#{bold}#{orange}Wfetch KoffeeJava 2026#{reset}"

  debug = false

  OptionParser.parse do |parser|
    parser.banner = "Usage: wfetch [arguments]"
    parser.on("-i", "--icons", "Shows all icons") {    
    icon(1000)
    icon(1003)
    icon(1006)
    icon(1009)
    icon(1072)
    icon(1087)
    print "End"
    exit(1)
    }
    parser.on("-v", "--verbose", "Gives additional details.") {debug = true}
    parser.on("-h", "--help", "Show this help") do
    
      puts parser
      exit(1)
    end
    parser.invalid_option do |flag|
      STDERR.puts "ERROR: #{flag} is not a valid option."
      STDERR.puts parser
      exit(1)
    end
  end



  config = TOML.parse(File.read("/home/koffeejava/.local/share/Wfetch/config.toml"))
  city = config["city"]
  api_key = config["api"]

  response = HTTP::Client.get "http://api.weatherapi.com/v1/current.json?q=#{city}&key=#{api_key}"
    
  if response.status_code != 200
    puts "Error: status code #{response.status_code}"
    exit
  end

  data = JSON.parse(response.body.lines.join)

  if debug == true
    puts data
  end

  fftemp = data["current"]["feelslike_f"]
  fctemp = data["current"]["feelslike_c"]
  temp = data["current"]["temp_f"]
  tempm = data["current"]["temp_c"]
  desc = data["current"]["condition"]["text"]
  pressin = data["current"]["pressure_in"]
  pressmb = data["current"]["pressure_mb"]
  cwind = data["current"]["wind_mph"]
  mwind = data["current"]["wind_kph"]
  humidity = data["current"]["humidity"]
  vism = data["current"]["vis_miles"]
  visk = data["current"]["vis_km"]
  heatindex_f = data["current"]["heatindex_f"]
  heatindex_c = data["current"]["heatindex_c"]
  windchill_f = data["current"]["windchill_f"]
  windchill_c = data["current"]["windchill_c"]
  id = data["current"]["condition"]["code"]
  
  disp = TOML.parse(File.read("/home/koffeejava/.local/share/Wfetch/disp.toml"))

  
  repeat = 1
  File.each_line("/home/koffeejava/.local/share/Wfetch/disp.toml") do |line|
    entry = disp["#{repeat}"]?  # Use []? to avoid KeyError
    
    if entry
      if entry.to_s == "{icon}"
        icon(id)
      end
      puts entry.to_s.gsub("{temp_f}", temp).gsub("{temp_c}", tempm).gsub("{feels_temp_f}", fftemp).gsub("{feels_temp_c}", fctemp).gsub("{wind_mph}", cwind).gsub("{wind_kph}", mwind).gsub("{humidity}", humidity).gsub("{pressure_in}", pressin).gsub("{description}", desc).gsub("{orange}", "\e[38;5;214m").gsub("{blue}", "\e[38;5;33m").gsub("{bold}", "\033[1m").gsub("{reset}", "\e[0m").gsub("{icon}", nil)
    end
    
    repeat += 1
  end

end
