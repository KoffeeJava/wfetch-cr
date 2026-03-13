orange = "\e[38;5;214m"
red = "\e[38;5;52m"
bold = "\033[1m"
reset = "\e[0m"

if Process.uid != 0
    puts "#{red}#{bold}You must be in root to install wfetch!#{reset}"
    exit(0)
end

puts "#{orange}#{bold}wfetch installer 0.1.0#{reset}"

File.copy("data/wfetch", "/usr/bin/wfetch")

puts "Finished"