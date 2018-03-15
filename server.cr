require "./slack"
require "kemal"

get "/" do
  slack = Slack.new
  snooze = slack.snoozed? ? "Unsnooze" : "Snooze"
  status = slack.status_text

  render "views/index.ecr"
end

post "/" do |env|
  Slack.new.toggle_snooze
  env.redirect("/")
end

Kemal.run
