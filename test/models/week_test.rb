require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Week Model" do
  it 'can construct a new instance' do
    @week = Week.new
    refute_nil @week
  end
end
