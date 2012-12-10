#encoding: utf-8

require 'base64'
require 'net/http'

module ImageSearch
  class Client
    class << self
      def index(key, string_file)
        settings = ImageSearch::Configuration.settings
        response = Net::HTTP.start(settings[:host], settings[:port]) do |http|
          request = Net::HTTP::Put.new(settings[:path])
          params = { key: key, file: string_file }
          request.body = params.to_json
          http.request(request)
        end
        JSON.parse response.body
      end

      def search(string_file)
        settings = ImageSearch::Configuration.settings
        response = Net::HTTP.start(settings[:host], settings[:port]) do |http|
          request = Net::HTTP::Post.new(settings[:path])
          params = { file: string_file }
          request.body = params.to_json
          http.request(request)
        end
        JSON.parse response.body
      end

      def delete(key)
        settings = ImageSearch::Configuration.settings
        response = Net::HTTP.start(settings[:host], settings[:port]) do |http|
          request = Net::HTTP::Delete.new(settings[:path])
          params = { key: key }
          request.body = params.to_json
          http.request(request)
        end
        JSON.parse response.body
      end
    end
  end
end
