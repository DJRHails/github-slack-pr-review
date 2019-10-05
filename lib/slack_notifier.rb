require 'json'

class SlackNotifier
  SLACK_USERNAME = 'Natasha'
  attr_reader :name, :pull_request

  def initialize(pull_request)
    @pull_request = pull_request
    @name = valid_ids.sample
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

  def valid_ids
    owner = pull_request['user']['login']
    gh_users = ENV['GITHUB_NAMES'].split(',')
    valid_ids = ENV['SLACK_NAMES'].split(',')
    valid_ids.delete_at(gh_users.find_index(owner))
    valid_ids
  end

  def headers
    { 'Content-Type' => 'application/json' }
  end

  def link
    pull_request['html_url']
  end
end
