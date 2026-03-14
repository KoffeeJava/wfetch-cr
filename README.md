# WeatherFetch - A weather app for your terminal

Wfetch-cr is a rewrite of one of my programs, wfetch (made in python)
I made this version because I wanted to learn a new programming language and take advantage of the speed of crystal!
This version of wfetch is semi-backwards compatible (config.toml will work! But not disp.toml...)

## Installation

Fist download the latest release fron the releases page and extract it. Inside of the folder, you will see an executible named "wf-tool".
This will be the program that you will use to install and setup wfetch.

Open your favorite terminal in the folder and run `sudo ./wf-tool -i` This will install wfetch.
> **WARNING**: You must run wf-tool with sudo to install wfetch.

Wfetch should quickly install. After wfetch is installed, run `./wf-tool -s` and follow the setup instructions
> **WARNING**: Do not run this command under sudo. It will not let you run the setup if you do so.

## FAQ

### How do I get an Weather API key?

First, go to the [Weather API](https://www.weatherapi.com/) website and then sign up. When finished creating an account, login then copy your api key.

### Why don't you provide an api key?

Giving out an api key is one of the top ten things to never do in your life.


## Contributing

1. Fork it (<https://github.com/koffeejava/wfetch/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [KoffeeJava](https://github.com/koffeejava) - creator and maintainer
