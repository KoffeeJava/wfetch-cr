require "http/client"
require "json"
require "toml"
require "./icon-list"
require "option_parser"

module Wfetch
  VERSION = "1.0.0"
  orange = "\e[38;5;214m"
  red = "\e[0;31m"
  bold = "\e[1m"
  reset = "\e[0m"

  debug = false
  test_config = false

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
    parser.on("-d", "--debug", "Turns on debug mode.") {debug = true}
    parser.on("-t", "--test-disp-config", "Test a disp config without editing yours.") {
      test_config = true
    }
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
    puts "\n#{data}"
  end

  feelslike_f = data["current"]["feelslike_f"].to_s.to_f
  feelslike_c = data["current"]["feelslike_c"].to_s.to_f
  temp_f = data["current"]["temp_f"].to_s.to_f
  temp_c = data["current"]["temp_c"].to_s.to_f
  desc = data["current"]["condition"]["text"].to_s
  press_in = data["current"]["pressure_in"].to_s.to_f
  press_mb = data["current"]["pressure_mb"].to_s.to_f
  wind_mph = data["current"]["wind_mph"].to_s.to_f
  wind_kph = data["current"]["wind_kph"].to_s.to_f
  humidity = data["current"]["humidity"].to_s.to_f
  vis_mi = data["current"]["vis_miles"].to_s.to_f
  vis_km = data["current"]["vis_km"].to_s.to_f
  heatindex_f = data["current"]["heatindex_f"].to_s.to_f
  heatindex_c = data["current"]["heatindex_c"].to_s.to_f
  windchill_f = data["current"]["windchill_f"].to_s.to_f
  windchill_c = data["current"]["windchill_c"].to_s.to_f
  id = data["current"]["condition"]["code"]
  
  if debug == true
    disp = TOML.parse("
      1 = \"{icon}\"
      2 = \"Live Temperature: {temp_f_color}{temp_f}{reset}°F\"
      3 = \"Live Temperature: {temp_c_color}{temp_c}{reset}°C\"
      4 = \"Feels like: {fl_f_color}{feels_like_f}{reset}°F\"
      5 = \"Feels like: {fl_c_color}{feels_like_c}{reset}°C\"
      6 = \"Wind Speed: {wind_mph_color}{wind_mph}{reset} MPH\"
      7 = \"Wind Speed: {wind_kph_color}{wind_kph}{reset} KPH\"
      8 = \"Humidity: {humidity}%\"
      9 = \"Pressure: {pressure_in} IN\"
      10 = \"Pressure: {pressure_mb} MB\"
      11 = \"Description: {orange}{bold}{description}{reset}\"
      12 = \"{goodbye}\"
    ")
  elsif test_config
    puts "\nPlease paste the path of the config"
    path_config = gets
    disp = TOML.parse(File.read(Path["#{path_config}"].expand(home: true)))
  else
    disp = TOML.parse(File.read(Path["~/.local/share/Wfetch/disp.toml"].expand(home: true)))
  end
  
  repeat = 1

  if Time.local.minute < 10
      time = (Time.local.hour.to_s + 0.to_s + Time.local.minute.to_s).to_f

        if time < 1200
          message = "#{bold}#{orange}Have a good morning!#{reset}"
        elsif time >= 1200
          message = "#{bold}#{orange}Have a good afternoon!#{reset}"
        end
  elsif Time.local.minute >= 10
      time = (Time.local.hour.to_s + Time.local.minute.to_s).to_f
      if time < 1200
        message = "#{bold}#{orange}Have a good morning!#{reset}"
      elsif time >= 1200
        message = "#{bold}#{orange}Have a good afternoon!#{reset}"
      end
  end

  if feelslike_f > 85
    fl_f_color = bold + red
  elsif (70..84).includes?(feelslike_f)
    fl_f_color = bold + "\e[1;33m"
  elsif feelslike_f < 70
    fl_f_color = "\e[0;34m" + bold
  end

  if feelslike_c > 29
    fl_c_color = bold + red
  elsif (21..28).includes?(feelslike_c)
    fl_c_color = bold + "\e[1;33m"
  elsif feelslike_c < 21
    fl_c_color = "\e[0;34m" + bold
  end

  if temp_f > 85
    temp_f_color = bold + red
  elsif (70..84).includes?(temp_f)
    temp_f_color = bold + "\e[1;33m"
  elsif temp_f < 70
    temp_f_color = "\e[0;34m" + bold
  end

  if temp_c > 29
    temp_c_color = bold + red
  elsif (21..28).includes?(temp_c)
    temp_c_color = bold + "\e[1;33m"
  elsif temp_c < 21
    temp_c_color = "\e[0;34m" + bold
  end

  if wind_mph > 73
    wind_mph_color = bold + red
  elsif (13..26).includes?(wind_mph)
    wind_mph_color = bold + "\e[1;33m"
  elsif (1..12).includes?(wind_mph)
    wind_mph_color = "\e[0;34m" + bold
  end

  if wind_kph > 46
    wind_kph_color = bold + red
  elsif (20..45).includes?(wind_mph)
    wind_kph_color = bold + "\e[1;33m"
  elsif (1..19).includes?(wind_mph)
    wind_kph_color = "\e[0;34m" + bold
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
    "{fl_f_color}" => fl_f_color,
    "{fl_c_color}" => fl_c_color,
    "{temp_f_color}" => temp_f_color,
    "{temp_c_color}" => temp_c_color,
    "{wind_mph_color}" => wind_mph_color,
    "{wind_kph_color}" => wind_kph_color,
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
