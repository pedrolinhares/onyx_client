#encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ImageSearch::Client" do
  before(:all) do
    ImageSearch::FakeServer.start
  end

  after(:all) do
  ImageSearch::FakeServer.stop
  end

  before(:each) do
    ImageSearch::Configuration.configure do |conf|
      conf.host 'localhost'
      conf.port '4567'
      conf.path '/'
    end
  end

  it "index a image" do
    key = 'testing'
    img_base64 = Base64.encode64(File.open('spec/resources/debian.jpg').read)
    result = ImageSearch::Client.index(key, img_base64)
    result["code"].should == '200'
  end

  it 'searches for an image' do
    img_base64 = Base64.encode64(File.open('spec/resources/debian.jpg').read)
    key = 'testing'
    ImageSearch::Client.index(key, img_base64)
    result = ImageSearch::Client.search(img_base64)
    result.size.should == 1
    result.first["id"].should == key
  end

  it 'deletes an image' do
    key = 'testing'
    result = ImageSearch::Client.delete(key)
    result["code"].should == '200'
  end
end
