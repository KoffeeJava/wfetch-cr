orange = "\e[38;5;214m"
red = "\e[0;31m"
bold = "\033[1m"
reset = "\e[0m"

lib C
  fun getuid : UInt32
end

if C.getuid != 0
    puts "#{red}#{bold}You must be in root to install wfetch!#{reset}"
    exit(0)
end

sudo_user = ENV["SUDO_USER"]?
home = "/home/#{sudo_user}"

puts "#{orange}#{bold}wfetch installer 0.1.0#{reset}"

File.copy("data/wfetch", "/usr/bin/wfetch")

puts "#{orange}#{bold}Finished installing! Let's setup.#{reset}"

puts "Please enter your WeatherApi key (Learn to get one at README.md):"

api = gets

puts "Please enter the (closest) city you live in: "

city = gets

puts "#{orange}#{bold}Config setup finished. Starting disp setup.#{reset}"

File.write("/home/#{sudo_user}/.local/share/Wfetch/config.toml", "api = \"#{api}\"
city = \"#{city}\"")

puts "#{orange}#{bold}Would you like customary (1), metric (2), or both (3)?#{reset}"

choice = gets

if choice == "1"
  File.copy("data/1.toml", "/home/#{sudo_user}/.local/share/Wfetch/disp.toml")
elsif choice == "2"
  File.copy("data/2.toml", "/home/#{sudo_user}/.local/share/Wfetch/disp.toml")
elsif choice == "3"
  File.copy("data/3.toml", "/home/#{sudo_user}/.local/share/Wfetch/disp.toml")
else
  File.copy("data/1.toml", "/home/#{sudo_user}/.local/share/Wfetch/disp.toml")
end

puts "#{orange}#{bold}Install finnished. Enjoy!#{reset}"