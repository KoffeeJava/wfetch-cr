require "http/client"
require "json"
require "toml"
require "./icon-list"
require "option_parser"

module Wfetch
  VERSION = "1.0.0"
  orange = "\e[38;5;214m"
  red = "\e[0;31m"
  bold = "\033[1m"
  reset = "\e[0m"

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
    icon(1066)
    icon(1030)
    print "End"
    exit(1)
    }
    parser.on("-r", "--verbose", "Gives additional details.") {debug = true}
    parser.on("-v", "--version", "Shows the current version of wfetch") {
      puts "#{bold}#{orange}Wfetch 1.0.0 KoffeeJava 2026#{reset}"
      exit
    }
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

   print "#{bold}#{orange}Wfetch KoffeeJava 2026#{reset}"

  config = TOML.parse(File.read(Path["~/.local/share/Wfetch/config.toml"].expand(home: true)))
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

  feelslike_f = data["current"]["feelslike_f"]
  feelslike_c = data["current"]["feelslike_c"]
  temp_f = data["current"]["temp_f"]
  temp_c = data["current"]["temp_c"]
  desc = data["current"]["condition"]["text"]
  press_in = data["current"]["pressure_in"]
  press_mb = data["current"]["pressure_mb"]
  wind_mph = data["current"]["wind_mph"]
  wind_kph = data["current"]["wind_kph"]
  humidity = data["current"]["humidity"]
  vis_mi = data["current"]["vis_miles"]
  vis_km = data["current"]["vis_km"]
  heatindex_f = data["current"]["heatindex_f"]
  heatindex_c = data["current"]["heatindex_c"]
  windchill_f = data["current"]["windchill_f"]
  windchill_c = data["current"]["windchill_c"]
  id = data["current"]["condition"]["code"]
  
  if debug == true
    disp = TOML.parse("
      1 = \"{icon}\"
      2 = \"Live Temperature: {temp_f}°F\"
      3 = \"Live Temperature: {temp_c}°C\"
      4 = \"Feels like: {feels_like_f}°F\"
      5 = \"Feels like: {feels_like_c}°C\"
      6 = \"Wind Speed: {wind_mph} MPH\"
      7 = \"Wind Speed: {wind_kph} KPH\"
      8 = \"Humidity: {humidity}%\"
      9 = \"Pressure: {pressure_in} IN\"
      10 = \"Pressure: {pressure_mb} MB\"
      11 = \"Description: {orange}{bold}{description}{reset}\"
      12 = \"{goodbye}\"
    ")
  else
    disp = TOML.parse(File.read(Path["~/.local/share/Wfetch/disp.toml"].expand(home: true)))
  end
  
  repeat = 1

  if Time.local.minute < 10
      time = (Time.local.hour.to_s + 0.to_s + Time.local.minute.to_s).to_i

        if time < 1200
          message = "#{bold}#{orange}Have a good morning!#{reset}"
        elsif time >= 1200
          message = "#{bold}#{orange}Have a good afternoon!#{reset}"
        end
  elsif Time.local.minute >= 10
      time = (Time.local.hour.to_s + Time.local.minute.to_s).to_i
      if time < 1200
        message = "#{bold}#{orange}Have a good morning!#{reset}"
      elsif time >= 1200
        message = "#{bold}#{orange}Have a good afternoon!#{reset}"
      end
  end


  vars = {
    "{temp_f}" => temp_f,
    "{temp_c}" => temp_c,
    "{feels_like_f}" => feelslike_f,
    "{feels_like_c}" => feelslike_c,
    "{wind_mph}" => wind_mph,
    "{wind_kph}" => wind_kph,
    "{pressure_in}" => press_in,
    "{pressure_mb}" => press_mb,
    "{humidity}" => humidity,
    "{visibility_mi}" => vis_mi,
    "{visibility_km}" => vis_km,
    "{windchill_f}" => windchill_f,
    "{windchill_c}" => windchill_c,
    "{description}" => desc,
    "{orange}" => orange,
    "{bold}" => bold,
    "{reset}" => reset,
    "{icon}" => nil,
    "{goodbye}" => message
  }

  File.each_line(Path["~/.local/share/Wfetch/disp.toml"].expand(home: true)) do |line|
    entry = disp["#{repeat}"]?
    
    if entry
      if entry.to_s == "{icon}"
        icon(id)
      end
      pattern = Regex.new(vars.keys.map { |k| Regex.escape(k) }.join("|"))
      puts entry.to_s.gsub(pattern, vars)
    end
    
    repeat += 1
  end

end
