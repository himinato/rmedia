require 'spec_helper'

describe FFmpeg::EncodeOption do
  let(:options) do
    FFmpeg::EncodeOption.new(
      format: 'mp4',
      seek_position: 2,
      duration: 15,
      frame_rate: 30
    )
  end

  it 'to_s' do
    [/-f mp4/, /-ss 2/, /-t 15/, /-r 30/].each do |regex|
      expect(options.to_s).to match(regex)
    end
  end

  describe 'friendly options' do
    let(:friendly_options) do
      FFmpeg::EncodeOption.new(
        format: 'mp4',
        input: 'path/to/input.flv',
        duration: '25.6',
        stop_position: '25',
        limit_size: '10485760',
        seek_position: '2',
        video_bit_rate: '1.5k',
        frame_rate: '30',
        resolution: '640x360',
        disable_video: true,
        video_filter: 'scale=640:360',
        audio_bit_rate: '256k',
        audio_sample_rate: '48k',
        audio_quality: '330',
        audio_channels: '6', # 5.1ch
        disable_audio: true,
        audio_filter: 'pan=stereo|c0=FL|c1=FR',
        disable_subtitle: true
      )
    end

    it 'format' do
      expect(friendly_options.to_s).to match(/-f mp4/)
      expect(friendly_options.to_s).not_to match(/format mp4/)
    end

    it 'input' do
      expect(friendly_options.to_s).to match(%r{-i path/to/input\.flv})
      expect(friendly_options.to_s).not_to match(%r{input path/to/input\.flv})
    end

    it 'duration' do
      expect(friendly_options.to_s).to match(/-t 25\.6/)
      expect(friendly_options.to_s).not_to match(/duration 25\.6/)
    end

    it 'stop_position' do
      expect(friendly_options.to_s).to match(/-to 25/)
      expect(friendly_options.to_s).not_to match(/stop_position 25/)
    end

    it 'limit_size' do
      expect(friendly_options.to_s).to match(/-fs 10485760/)
      expect(friendly_options.to_s).not_to match(/limit_size 10485760/)
    end

    it 'seek_position' do
      expect(friendly_options.to_s).to match(/-ss 2/)
      expect(friendly_options.to_s).not_to match(/seek_position 2/)
    end

    it 'video_bit_rate' do
      expect(friendly_options.to_s).to match(/-b:v 1\.5k/)
      expect(friendly_options.to_s).not_to match(/video_bit_rate 1\.5k/)
    end

    it 'frame_rate' do
      expect(friendly_options.to_s).to match(/-r 30/)
      expect(friendly_options.to_s).not_to match(/frame_rate 30/)
    end

    it 'resolution' do
      expect(friendly_options.to_s).to match(/-s 640x360/)
      expect(friendly_options.to_s).not_to match(/resolution 640x360/)
    end

    it 'disable_video' do
      expect(friendly_options.to_s).to match(/-vn/)
      expect(friendly_options.to_s).not_to match(/disable_video/)
    end

    it 'video_filter' do
      expect(friendly_options.to_s).to match(/-vf scale=640:360/)
      expect(friendly_options.to_s).not_to match(/video_filter scale=640:360/)
    end

    it 'audio_bit_rate' do
      expect(friendly_options.to_s).to match(/-b:a 256k/)
      expect(friendly_options.to_s).not_to match(/audio_bit_rate 256k/)
    end

    it 'audio_sample_rate' do
      expect(friendly_options.to_s).to match(/-ar 48k/)
      expect(friendly_options.to_s).not_to match(/audio_sample_rate 48k/)
    end

    it 'audio_quality' do
      expect(friendly_options.to_s).to match(/-q:a 330/)
      expect(friendly_options.to_s).not_to match(/audio_quality 330/)
    end

    it 'audio_channels' do
      expect(friendly_options.to_s).to match(/-ac 6/)
      expect(friendly_options.to_s).not_to match(/audio_channels 6/)
    end

    it 'disable_audio' do
      expect(friendly_options.to_s).to match(/-an/)
      expect(friendly_options.to_s).not_to match(/disable_audio/)
    end

    it 'audio_filter' do
      expect(friendly_options.to_s).to match(/-af pan=stereo\|c0=FL\|c1=FR/)
      expect(friendly_options.to_s).not_to match(/audio_filter pan=stereo\|c0=FL\|c1=FR/)
    end

    it 'disable_subtitle' do
      expect(friendly_options.to_s).to match(/-sn/)
      expect(friendly_options.to_s).not_to match(/disable_subtitle/)
    end
  end
end
