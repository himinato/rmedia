require 'spec_helper'

describe FFmpeg::Media do
  let(:movie) { FFmpeg::Media.new("#{fixture_path}/movies/sample.mp4") }
  let(:movie_via_http) do
    FFmpeg::Media.new('http://s3-ap-northeast-1.amazonaws.com/himinato/rmedia/sample.mp4')
  end
  let(:broken) { FFmpeg::Media.new("#{fixture_path}/movies/broken.mp4") }
  let(:audio) { FFmpeg::Media.new("#{fixture_path}/audios/sample.mp3") }
  it 'initialize' do
    expect(movie.is_a?(FFmpeg::Media)).to be(true)
  end

  it 'initialize with URL' do
    # skip 'it takes a while'
    expect(movie_via_http.is_a?(FFmpeg::Media)).to be(true)
  end

  it 'raise not exist' do
    expect { FFmpeg::Media.new('nothing_path.mp4') }.to raise_error(
      Errno::ENOENT, /does not exist$/
    )
  end

  it 'raise does not media' do
    expect { broken }.to raise_error(RuntimeError, /does not media$/)
  end

  describe 'media informations' do
    it 'video?' do
      expect(movie.video?).to be(true)
    end

    it 'hasnt video' do
      expect(audio.video?).to be(false)
    end

    it 'audio?' do
      expect(audio.audio?).to be(true)
    end

    it 'has path' do
      expect(movie.path).to eq("#{fixture_path}/movies/sample.mp4")
    end

    it 'has  filename' do
      expect(movie.filename).to eq('sample.mp4')
    end

    it 'has duration' do
      expect(movie.duration).to eq(6.4)
    end

    it 'has size' do
      expect(movie.size).to eq(1_057_551)
    end

    it 'has bit_rate' do
      expect(movie.bit_rate).to eq(1_321_938)
    end
  end

  describe 'video informations' do
    it 'has codec' do
      expect(movie.video_codec).to eq('mpeg4')
    end

    it 'has bit_rate' do
      expect(movie.video_bit_rate).to eq(932_552)
    end

    it 'has width' do
      expect(movie.width).to eq(640)
    end

    it 'has height' do
      expect(movie.height).to eq(368)
    end

    it 'has resolution' do
      expect(movie.resolution).to eq('640x368')
    end

    it 'has frame_rate' do
      expect(movie.frame_rate).to eq(25 / 1)
    end

    it 'has sar' do
      expect(movie.sar).to eq('1:1')
    end

    it 'has dar' do
      expect(movie.dar).to eq('40:23')
    end

    it 'has pix_fmt' do
      expect(movie.pix_fmt).to eq('yuv420p')
    end
  end

  describe 'audio informations' do
    it 'has codec' do
      expect(audio.audio_codec).to eq('mp3')
    end

    it 'has bit_rate' do
      expect(audio.audio_bit_rate).to eq(56_000)
    end

    it 'has sample_rate' do
      expect(audio.audio_sample_rate).to eq(22_050)
    end

    it 'has channel_layout' do
      expect(audio.channel_layout).to eq('stereo')
    end
  end

  describe 'transcode' do
    it 'transcode' do
      path = File.join(tmp_path, 'sample.mov')

      transcoded = movie.transcode(
        path,
        format: 'mov',
        stop_position: 1,
        disable_audio: true
      )
      expect(transcoded.video?).to be(true)
      expect(transcoded.audio?).to be(false)
      expect(transcoded.format).to include('mov')
    end

    it 'screenshot' do
      path = File.join(tmp_path, 'sample.jpg')

      transcoded = movie.screenshot(path)
      expect(transcoded.video?).to be(true)
      expect(transcoded.format).to include('image2')
    end
  end
end
