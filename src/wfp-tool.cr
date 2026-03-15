orange = "\e[38;5;214m"
red = "\e[0;31m"
bold = "\033[1m"
reset = "\e[0m"
  
Dir.mkdir("config")


puts "Please enter your WeatherApi key (Learn to get one at README.md):"

api = gets

puts "Please enter the (closest) city you live in: "

city = gets

puts "#{orange}#{bold}Config setup finished. Starting disp setup.#{reset}"

File.write("config/config.toml", "
  api = \"#{api}\"
  city = \"#{city}\"
")

puts "#{orange}#{bold}Would you like customary (1), metric (2), or both (3)?#{reset}"

choice = gets

if choice == "1"
  File.copy("data/1.toml", "config/disp.toml")
elsif choice == "2"
  File.copy("data/2.toml", "config/disp.toml")
elsif choice == "3"
  File.copy("data/3.toml", "config/disp.toml")
else
  File.copy("data/1.toml", "config/disp.toml")
end

puts "#{orange}#{bold}Setup finnished. Enjoy!#{reset}"

Dir.remove("data")