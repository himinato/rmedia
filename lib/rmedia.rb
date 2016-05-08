require 'open3'
require 'rmedia/version'
require 'rmedia/media'
require 'rmedia/encode_option'
require 'rmedia/option_parser'
require 'rmedia/transcoder'

module FFmpeg
  def self.command(command)
    Open3.popen3(*command) do |stdin, stdout, stderr, wait_thr|
      yield(stdin, stdout, stderr, wait_thr) if block_given?
    end
  end

  class << self
    attr_accessor :ffmpeg_bin, :ffprobe_bin, :timeout

    def ffmpeg_bin
      @ffmpeg_bin ||= 'ffmpeg'
    end

    def ffprobe_bin
      @ffprobe_bin ||= 'ffprobe'
    end

    def timeout
      @timeout ||= 10
    end
  end
end
