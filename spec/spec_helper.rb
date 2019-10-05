require 'bundler'
Bundler.require :default, :test

require 'minitest/spec'
require 'minitest/pride'
require 'minitest/autorun'
require 'mocha/minitest'

ENV['SLACK_NAMES'] ||= 'UXUXU,ADADA'
ENV['GITHUB_NAMES'] ||= 'Name1,Name2'

module GithubHelpers
  REQUEST_FIXTURE = File.expand_path('../fixtures/request.json', __FILE__)

  def request_body
    JSON.parse File.read(REQUEST_FIXTURE)
  end

  def pull_request
    request_body['pull_request']
  end
end
