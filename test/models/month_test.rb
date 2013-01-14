require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Month Model" do
  it 'can construct a new instance' do
    @month = Month.new
    refute_nil @month
  end
end
