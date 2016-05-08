require 'spec_helper'

describe FFmpeg::Transcoder do
  describe '#run' do
    let(:input) { File.join(fixture_path, 'movies', 'sample.mp4') }
    let(:duration) { 6.4 }

    it 'transcode media' do
      output = File.join(tmp_path, 'encoded.webm')

      # require --enable-libvpx --enable-libvorbis
      command = FFmpeg::OptionParser.command(
        input, output, '-s 360x184 -ss 2 -t 1 -r 5 -vcodec libvpx -acodec libvorbis'
      )
      FFmpeg::Transcoder.run(command, duration)

      expect(FFmpeg::Media.new(output).video?).to be(true)
    end

    context 'with timeout nearly zero' do
      before do
        FFmpeg.timeout = 0.00000000000001
      end

      after do
        FFmpeg.timeout = 10
      end

      it 'raise Timeout error' do
        output = File.join(tmp_path, 'timeout.mp4')

        command = FFmpeg::OptionParser.command(input, output, '-s 360x184')
        expect { FFmpeg::Transcoder.run(command, duration) }
          .to raise_error(Timeout::Error, 'FFmpeg hung up')
      end
    end
  end
end
