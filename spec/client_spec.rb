#encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Onyx::Client" do
  before(:all) do
    Onyx::FakeServer.start
  end

  after(:all) do
  Onyx::FakeServer.stop
  end

  before(:each) do
    Onyx::Configuration.configure do |conf|
      conf.host 'localhost'
      conf.port '4567'
      conf.path '/'
    end
  end

  it "index a image" do
    key = 'testing'
    img_base64 = Base64.encode64(File.open('spec/resources/debian.jpg').read)
    result = Onyx::Client.index(key, img_base64)
    result["code"].should == '200'
  end

  it 'searches for an image' do
    img_base64 = Base64.encode64(File.open('spec/resources/debian.jpg').read)
    key = 'testing'
    Onyx::Client.index(key, img_base64)
    result = Onyx::Client.search(img_base64)
    result.size.should == 1
    result.first["id"].should == key
  end

  it 'deletes an image' do
    key = 'testing'
    result = Onyx::Client.delete(key)
    result["code"].should == '200'
  end
end
