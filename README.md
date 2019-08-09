[![Gem Version](https://badge.fury.io/rb/reverse_coverage.svg)](https://badge.fury.io/rb/reverse_coverage)

# ReverseCoverage

Statistics on spec coverage

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'reverse_coverage'
```

And then execute:

```console
$ bundle
```

Put the following code under you specs configuration

```ruby
require 'reverse_coverage'

RSpec.configure do |config|
  config.before(:suite) do
    ReverseCoverage::Main.instance.start Coverage.peek_result
  end

  config.around do |e|
    e.run
    ReverseCoverage::Main.instance.add(Coverage.peek_result, e)
  end

  config.after(:suite) do
    ReverseCoverage::Main.instance.save_results('tmp/reverse_coverage.yml')
  end
end
```

## Usage

Run your specs, inspect the 'tmp/reverse_coverage.yml' file.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nebulab/reverse_coverage. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

ReverseCoverage is copyright © 2019 [Nebulab](http://nebulab.it/). It is free software, and may be redistributed under the terms specified in the [license](LICENSE.txt).

## About

![Nebulab](http://nebulab.it/assets/images/public/logo.svg)

ReverseCoverage is funded and maintained by the [Nebulab](http://nebulab.it/) team.

We firmly believe in the power of open-source. [Contact us](http://nebulab.it/contact-us/) if you like our work and you need help with your project design or development.
