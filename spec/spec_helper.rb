$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rmedia'

def fixture_path
  @fixture_path ||= File.join(__dir__, 'fixtures')
end

def tmp_path
  @tmp_path ||= File.join(__dir__, '../tmp/spec')
end

RSpec.configure do |config|
  config.before(:suite) do
    FileUtils.mkdir_p(tmp_path)
  end

  config.after(:suite) do
    FileUtils.rm_rf(tmp_path, secure: true)
  end
end
