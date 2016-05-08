require 'spec_helper'

describe FFmpeg::OptionParser do
  it 'create command with string' do
    command = FFmpeg::OptionParser.command('INPUT', 'OUTPUT',
                                           '-ss 2 -s 320x180')
    expect(command).to match('^ffmpeg -y -i INPUT')
    ['-ss 2', '-s 320x180'].each do |s|
      expect(command).to match(s)
    end
    expect(command).to match('OUTPUT$')
  end

  it 'create command with hash' do
    command = FFmpeg::OptionParser.command('INPUT', 'OUTPUT',
                                           seek_position: 2,
                                           resolution: '320x180')
    expect(command).to match('^ffmpeg -y -i INPUT')
    ['-ss 2', '-s 320x180'].each do |s|
      expect(command).to match(s)
    end
    expect(command).to match('OUTPUT$')
  end

  it 'create command with encode_option' do
    encode_option = FFmpeg::EncodeOption.new(seek_position: 2,
                                               resolution: '320x180')
    command = FFmpeg::OptionParser.command('INPUT', 'OUTPUT', encode_option)
    expect(command).to match('^ffmpeg -y -i INPUT')
    ['-ss 2', '-s 320x180'].each do |s|
      expect(command).to match(s)
    end
    expect(command).to match('OUTPUT$')
  end

  it 'create input seeking hacked command' do
    encode_option = FFmpeg::EncodeOption.new(seek_position: 2,
                                               resolution: '320x180')
    command = FFmpeg::OptionParser.hacked_command('INPUT', 'OUTPUT',
                                                  encode_option)
    expect(command).to match('^ffmpeg -y -ss 2 -i INPUT')
    expect(command).to match('-s 320x180')
    expect(command).to match('OUTPUT$')
  end

  it 'create 2pass hacked command' do
    command = FFmpeg::OptionParser.hacked_command('INPUT', 'OUTPUT',
                                                  '-pass' => 2,
                                                  seek_position: 2,
                                                  resolution: '320x180')
    expect(command).to match('^ffmpeg -y -ss 2 -i INPUT')
    ['-s 320x180', '-an', '-pass 1', '-pass 2'].each do |s|
      expect(command).to match(s)
    end
    expect(command).to match('OUTPUT && ffmpeg -y -ss 2 -i INPUT')
    expect(command).to match('OUTPUT$')
  end
end
