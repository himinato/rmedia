module FFmpeg
  class EncodeOption < Hash
    FRIENDLY_OPTIONS = {
      format: '-f',
      input: '-i',
      duration: '-t',
      stop_position: '-to',
      limit_size: '-fs',
      seek_position: '-ss',
      video_bit_rate: '-b:v',
      frame_rate: '-r',
      resolution: '-s',
      disable_video: '-vn',
      video_filter: '-vf',
      audio_bit_rate: '-b:a',
      audio_sample_rate: '-ar',
      audio_quality: '-q:a',
      audio_channels: '-ac',
      disable_audio: '-an',
      audio_filter: '-af',
      disable_subtitle: '-sn'
    }.freeze

    def initialize(opts = {})
      opts.each do |key, value|
        case
        when FRIENDLY_OPTIONS[key.to_sym]
          self[FRIENDLY_OPTIONS[key.to_sym]] = value
        when private_methods.include?("opt_#{key}".to_sym)
          send("opt_#{key}", value)
        else
          self[key.to_s] = value
        end
      end
    end

    def to_s
      map do |key, value|
        value.is_a?(String) || value.is_a?(Numeric) ? "#{key} #{value}" : key
      end.join(' ')
    end

    private

    def opt_screenshot(_v)
      self['-f'] = 'image2'
      self['-vframes'] = 1
    end
  end
end
