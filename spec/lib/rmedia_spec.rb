require 'spec_helper'

describe FFmpeg do
  it 'has a version number' do
    expect(FFmpeg::VERSION).not_to be nil
  end

  it 'has command method' do
    output = FFmpeg.command('echo test') { |_stdin, stdout| stdout.read }
    expect(output).to eq("test\n")
  end
end
