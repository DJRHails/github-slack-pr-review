require 'spec_helper'
require 'slack_notifier'

class SlackNotifierTest < Minitest::Spec
  include GithubHelpers

  let(:slack) {
    SlackNotifier.new(pull_request)
  }

  describe '#payload' do
    let(:payload) {
      slack.payload
    }

    let(:attachment) {
      payload[:attachments].first
    }

    let(:text) {
      payload[:blocks].first[:text][:text]
    }

    it 'has an icon' do
      _(payload[:icon_url]).wont_be :nil?
    end

    it 'has a username' do
      _(payload[:username]).must_equal SlackNotifier::SLACK_USERNAME
    end

    it 'contains text that mentions a specific user' do
      _(text).must_include "<@#{slack.name}>"
    end

    it 'has an attachment fallback that provides a link' do
      _(attachment[:fallback]).must_include pull_request['html_url']
    end

  end
end
