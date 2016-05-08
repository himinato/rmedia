require 'faraday'
require 'json'

module FFmpeg
  class Media
    attr_accessor :status
    attr_reader(
      :path, :filename, :format, :duration, :size, :bit_rate,
      :video_codec, :video_bit_rate, :width, :height, :resolution, :frame_rate, :sar, :dar, :pix_fmt,
      :audio_codec, :audio_bit_rate, :audio_sample_rate, :channel_layout
    )

    def initialize(path)
      raise Errno::ENOENT, "#{path} does not exist" unless path_exists?(path)

      @path = path

      options = '-v quiet -print_format json -show_format -show_streams'
      command = "#{FFmpeg.ffprobe_bin} #{options} #{path}"

      output = FFmpeg.command(command) { |_stdin, stdout| stdout.read }
      json = JSON.parse(output)

      raise "#{path} does not media" unless json['format']

      media_info(json['format'])
      streams_info(json['streams'])
    end

    def video?
      @status & 2 == 2
    end

    def audio?
      @status & 1 == 1
    end

    def transcode(output, options = {}, &block)
      opts = EncodeOption.new(options)
      command = OptionParser.command(@path, output, opts)
      Transcoder.run(command, @duration, &block)
      Media.new(output)
    end

    def screenshot(output, options = {}, &block)
      opts = EncodeOption.new(options.merge(screenshot: true))
      opts['-ss'] = @duration / 2.0 unless opts['-ss']
      command = OptionParser.hacked_command(@path, output, opts)
      Transcoder.run(command, @duration, &block)
      Media.new(output)
    end

    def hacked_transcode(output, options = {}, &block)
      opts = EncodeOption.new(options)
      command = OptionParser.hacked_command(@path, output, opts)
      Transcoder.run(command, @duration, &block)
      Media.new(output)
    end

    private

    def path_exists?(path)
      File.exist?(path) || url_exists?(path)
    end

    def url_exists?(path)
      client = Faraday.new { |f| f.use Faraday::Adapter::NetHttp }
      res = client.head(path)
      res.status == 200
    rescue
      false
    end

    def media_info(format)
      @filename = format['filename'].split('/')[-1]
      @format = format['format_name']
      @duration = format['duration'].to_f
      @size = format['size'].to_i
      @bit_rate = format['bit_rate'].to_i
      @status = 0
    end

    # Attributes set first stream both video and audio
    def streams_info(streams)
      streams.each do |stream|
        case stream['codec_type']
        when 'video' then @status & 2 == 0 && video_info(stream)
        when 'audio' then @status & 1 == 0 && audio_info(stream)
        end
      end
    end

    def video_info(stream)
      @video_codec = stream['codec_name']
      @video_bit_rate = stream['bit_rate'].to_i
      @width = stream['width'].to_i
      @height = stream['height'].to_i
      @resolution = "#{width}x#{height}"
      @frame_rate = stream['avg_frame_rate'] == '0/0' ? nil : Rational(stream['avg_frame_rate'])
      @sar = stream['sample_aspect_ratio']
      @dar = stream['display_aspect_ratio']
      @pix_fmt = stream['pix_fmt']
      @status += 2
    end

    def audio_info(stream)
      @audio_codec = stream['codec_name']
      @audio_bit_rate = stream['bit_rate'].to_i
      @audio_sample_rate = stream['sample_rate'].to_i
      @channel_layout = stream['channel_layout']
      @status += 1
    end
  end
end
