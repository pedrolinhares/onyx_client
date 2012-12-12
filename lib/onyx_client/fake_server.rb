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
      @@storage[params["key"]] = params["image"]
      { code: '200', message: 'message' }.to_json
    end

    #buscar
    post '/' do
      params = JSON.parse(request.body.read)
      key = @@storage.select {|key, value| value == params["image"] }.keys.last
      [{ key: key, score: "1.0" }].to_json
    end

    #excluir
    delete '/' do
      params = JSON.parse(request.body.read)
      if @@storage.has_key?(params["key"])
        @@storage.delete params["key"]
        { code: '200', message: 'message' }.to_json
      else
        { code: '404', message: 'message' }.to_json
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
