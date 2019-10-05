require 'json'

class SlackNotifier
  SLACK_USERNAME = 'Natasha'
  attr_reader :name, :pull_request

  def initialize(pull_request)
    @pull_request = pull_request
    @name = ENV['SLACK_NAMES'].split(',').sample
  end

  def notify
    HTTParty.post ENV['SLACK_ENDPOINT'], body: payload.to_json, headers: headers
  end

  def payload
    {
      icon_url: 'https://assets-cdn.github.com/images/modules/logos_page/Octocat.png',
      username: SLACK_USERNAME,
      blocks: [{
           type: "section",
           text: {
             type: "mrkdwn",
             text: "Hey <@#{name}>, can you review this PR?"
           }
         }],
      attachments: [{
        title: pull_request['title'],
        title_link: link,
        fallback: "#{link}",
      }]
    }
  end

  private

  def headers
    { 'Content-Type' => 'application/json' }
  end

  def link
    pull_request['html_url']
  end
end
