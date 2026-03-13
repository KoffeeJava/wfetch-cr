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
  
  disp = TOML.parse(File.read(Path["~/.local/share/Wfetch/disp.toml"].expand(home: true)))

  
  repeat = 1

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
    "{icon}" => nil
  }

  File.each_line("/home/koffeejava/.local/share/Wfetch/disp.toml") do |line|
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
