require 'sinatra'
require 'sinatra/base'
require 'debugger'
require 'json'

module Onyx
  class FakeServer < Sinatra::Base

    @@storage = {}

    #indexar
    put '/' do
      params = JSON.parse(request.body.read)
      @@storage[params["key"]] = params["file"]
      { code: '200', message: 'message', name: 'name' }.to_json
    end

    #buscar
    post '/' do
      params = JSON.parse(request.body.read)
      key = @@storage.select {|key, value| value == params["file"] }  .keys.last
      [{"id" => key, "score" => "1.0", "duplicated" => "false" }].to_json
    end

    #excluir
    delete '/' do
      params = JSON.parse(request.body.read)
      if @@storage.has_key?(params["key"])
        @@storage.delete params["key"]
        { code: '200' }.to_json
      else
        { code: '404' }.to_json
      end
    end

    def self.start
      @thread = Thread.new do
        run!
      end
      sleep(1)
    end

    def self.stop
      @thread.kill
    end
  end
end
