require 'timeout'

module FFmpeg
  module Transcoder
    class << self
      def run(command, duration)
        yield(0.0) if block_given?
        FFmpeg.command(command) do |_stdin, _stdout, stderr, wait_thr|
          last_update = Time.now

          stderr.each('size=') do |line|
            check_timeout(wait_thr.pid, last_update)
            yield(edit_time(line) / duration) if block_given?
          end
        end
        yield(1.0) if block_given?
      end

      private

      def check_timeout(pid, last_update)
        last_update = Time.now
        if Time.now - last_update > FFmpeg.timeout
          raise Timeout::Error.new('FFmpeg hung up')
        end
      rescue
        Process.kill('KILL', pid)
        raise
      end

      def edit_time(line)
        return 0.0 unless line.include?('time=')
        # ffmpeg 0.8 and above style
        if line =~ /time=(\d+):(\d+):(\d+.\d+)/
          (Regexp.last_match[1].to_i * 3600) +
            (Regexp.last_match[2].to_i * 60) +
            Regexp.last_match[3].to_f
        else
          0.0
        end
      end
    end
  end
end
