module FFmpeg
  module OptionParser
    class << self
      def command(input, output, options)
        exec_ffmpeg_command(input, output, parse(options).to_s)
      end

      def hacked_command(input, output, options)
        opts = parse(options).to_s
        if opts.include?('-pass 2')
          two_pass(input, output, opts)
        else
          input_seeking(input, output, opts)
        end
      end

      private

      def parse(options)
        case
        when options.is_a?(String) || options.is_a?(EncodeOption)
          options
        when options.is_a?(Hash)
          EncodeOption.new(options)
        else
          fail ArgumentError, 'unknown options format, should be either optoins, Hash or String' # rubocop:disable LineLength
        end
      end

      def exec_ffmpeg_command(input, output, opts)
        "#{FFmpeg.ffmpeg_bin} -y -i #{input} #{opts} #{output}"
      end

      def two_pass(input, output, opts)
        first_opts = "#{opts.sub('-pass 2', '-pass 1')} -an"
        first_command = input_seeking(input, output, first_opts)
        "#{first_command} && #{input_seeking(input, output, opts)}"
      end

      def input_seeking(input, output, opts)
        opts.sub!(/-ss \d+[\.\d]*/, '')
        if Regexp.last_match
          # it makes faster transcoding.
          #   NOTE: works only transcode, do not use -codec copy.
          "#{FFmpeg.ffmpeg_bin} -y #{Regexp.last_match[0]} -i #{input} #{opts} #{output}"
        else
          exec_ffmpeg_command(input, output, opts)
        end
      end
    end
  end
end
