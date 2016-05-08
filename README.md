# Rmedia

Rmedia is an interface between the Ruby and FFmpeg.

* http[s] input ready.
* [input seeking](https://trac.ffmpeg.org/wiki/Seeking) ready.
* 2 pass encode ready.

## Dependnecy

[FFmpeg](https://ffmpeg.org/)

How to build. [here](https://trac.ffmpeg.org/wiki/CompilationGuide)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rmedia'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rmedia

## Usage

### Settings

Default, Rmedia need execution path and named ffmpeg / ffprobe. But you can set binary.

```ruby
FFmpeg.ffmpeg_bin = '/path/to/bin/ffmpeg'
FFmpeg.ffprobe_bin = '/path/to/bin/ffprobe'
```

Default, Rmedia kill ffmpeg process when no 10 second IO feedback. But you can set timeout.

```ruby
FFmpeg.timeout = 30
```

### Media

Readable data [here](https://github.com/himinato/rmedia/blob/master/lib/rmedia/media.rb#L7-L11)

```ruby
media = FFmpeg::Media.new('path/to/media')

media.duration # 6.4
media.width # 640
```

Via http[s]

```ruby
media = FFmpeg::Media.new('http://any/to/media')
```

### Transcode

Use encode options. human friendly options [here](https://github.com/himinato/rmedia/blob/master/lib/rmedia/encode_options.rb#L3-L22)

```ruby
media.transcode('movie.webm', format: 'webm', video_bit_rate: '1500k') # transcode to webm
trnascoded = media.transcode('movie.webm', format: 'webm', video_bit_rate: '1500k') # return encoded media
```

Or give a string.

```ruby
media.transcode('audio.mp3', '-f mp3 -vn') # transcode to mp3
```

You can use progress.

```ruby
media.transcode('movie.mp4') { |progress| puts progress } # 0.0 to 1.0
```

Input seeking. Give you faster performance.

```ruby
media.screenshot('out.jpg') # default screenshot make half of duration frame.
media.screenshot('out.jpg', seek_position: 3.2) # you can change it. -ss / seek_position option.
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
