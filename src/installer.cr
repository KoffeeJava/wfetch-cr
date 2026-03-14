require "option_parser"

orange = "\e[38;5;214m"
red = "\e[0;31m"
bold = "\033[1m"
reset = "\e[0m"

sudo_user = ENV["SUDO_USER"]?
home = "/home/#{sudo_user}"

OptionParser.parse do |parser|
    parser.banner = "Usage: installer [arguments]"
    parser.on("-i", "--install-only", "Only instals wfetch; Does not run setup") {
      if LibC.getuid != 0
        puts "#{red}#{bold}You must be in root to install wfetch!#{reset}"
      exit(0)
      end

      puts "#{orange}#{bold}wfetch installer 1.0.0#{reset}"

      File.copy("data/wfetch", "/usr/bin/wfetch")

      puts "#{orange}#{bold}Finished installing!#{reset}"
      exit
    }
    parser.on("-u", "--uninstall", "Uninstalls wfetch"){
      if LibC.getuid != 0
        puts "#{red}#{bold}You must be in root to uninstall wfetch!#{reset}"
        exit(0)
      end

      File.delete("/usr/bin/wfetch")
      File.delete("#{home}/.local/share/Wfetch/disp.toml")
      File.delete("#{home}/.local/share/Wfetch/config.toml")
      Dir.delete("#{home}/.local/share/Wfetch")
      puts "#{bold}#{orange}Finished#{reset}"
      exit
    }
    parser.on("-s", "--setup", "Runs setup") {
      if LibC.getuid == 0
        puts "#{red}#{bold}Don't run the setup in root!#{reset}"
      exit(0)
      end
    
      Dir.mkdir("~//.local/share/Wfetch")


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

      puts "#{orange}#{bold}Setup finnished. Enjoy!#{reset}"
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

  if ARGV.empty?
    puts "Run installer -h"
  end