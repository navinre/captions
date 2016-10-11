# Capy - Subtitle Editor and Converter

[![Build Status](https://travis-ci.org/navinre/capy.svg?branch=master)](https://travis-ci.org/navinre/capy)

Capy can read subtitles of various formats, modify them and convert the subtitle to other formats. Currently capy supports `SRT`, `WebVTT` files.

## Supported Features
- Read subtitles
- Move subtitles
- Increase duration
- Filter subtitles
- Change frame rate
- Convert to other format (SRT, WebVTT)

## Features Planned
- Read subtitle properties (Font Style, Aligment, Position etc.)
- Delete subtitles
- Change subtitle fonts
- Command Line Interface
- Spell Check
- And More...


## Usage

**Read subtitle file:**

```ruby
s = Capy::SRT.new('test.srt')
s.parse

s = Capy::VTT.new('test.vtt')
s.parse
```

**Filter subtitles:**

Once the subtitle file has been parsed. Every subtitle will get **start_time, end_time, duration and text**. All the values are stored in milliseconds. `Capy::InvalidSubtitle` error will be thown if start-time or end-time cannot be found for a subtitle.

View all subtitle text:
```ruby
s.cues.map { |c| c.text }
```

Filter subtitles based on condition:
```ruby
s.cues { |c| c.start_time > 1000 }
s.cues { |c| c.end_time > 1000 }
s.cues { |c| c.duration > 1000 }
```

To get all subtitles:
```ruby
s.cues.each { |c| puts c }
```

**Move Subtitle:**

```ruby
s.move_by(1000)
s.move_by(1000) { |c| c.start_time > 3000 }
```

Former command moves all subtitles by 1 second. Later moves the subtitles which are starting after 3 seconds by 1 second.

**Increase Duration:**

```ruby
s.increase_duration_by(1000)
s.increase_duration_by(1000) { |c| c.start_time > 3000 }
```

Former command increases duration of all subtitles by 1 second. Later increases the duration of subtitles which are starting after 3 seconds by 1 second.

**Change Frame Rate:**

All subtitles are parsed based on **25 frames/second** by default. This can be changed by passing frame rate at the time of reading the subtitle file.

```ruby
s = Capy::SRT.new('test.srt', 29.97)
s.parse
```

Frame rate can also be changed after parsing. This command changes all the subtitles which are parsed in different frame-rate to new frame-rate.

```ruby
s.set_frame_rate(29.97)
```

**Convert to Other Format:**

Subtitles parsed in one format can be converted to other format. Currently export is supported for **SRT** and **WebVTT**. Other formats will be added soon.

```ruby
s = Capy::SRT.new('test.srt')
s.parse
s.export_to_vtt('test.vtt')
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capy'
```

Or install it yourself as:

    $ gem install capy


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/navinre/capy.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

