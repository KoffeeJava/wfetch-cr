# WeatherFetch - A weather app for your terminal

Wfetch-cr is a rewrite of one of my programs, wfetch (made in python)
I made this version because I wanted to learn a new programming language and take advantage of the speed of crystal!
This version of wfetch is semi-backwards compatible (config.toml will work! But not disp.toml...)

## Installation

### Linux

Fist download the latest release fron the releases page and extract it. Inside of the folder, you will see an executible named "wf-tool".
This will be the program that you will use to install and setup wfetch.

Open your favorite terminal in the folder and run `sudo ./wf-tool -i` This will install wfetch.
> **WARNING**: You must run wf-tool with sudo to install wfetch.

Wfetch should quickly install. After wfetch is installed, run `./wf-tool -s` and follow the setup instructions
> **WARNING**: Do not run this command under sudo. It will not let you run the setup if you do so.

### Windows

At this time Windows dows not have a build.

### MacOS

At this time MacOS does not have a build.

## Compiling

### Requirements

- Crystal compiler
- Wfetch Source Code
- wfetch-1.0.0-data.tar.xz

Download the latest release's source code and open your terminal inside the directory and run `shards build --release` and the build will be outputted in bin/

To actually install and setup your wfetch build, you will need to have a data directory with wftech and the disp configs.

Extract the data directory file and copy it to where your wfetch and wf-tool executable are. Once your data directory is copied/moved over, move wfetch inside of the data directory and then follow the installing instructions.

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
