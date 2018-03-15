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

get "/api/status" do
  slack = Slack.new
  slack.snoozed? ? "1" : "0"
end

get "/api/on" do
  Slack.new.dnd_on
end

get "/api/off" do
  Slack.new.dnd_off
end

Kemal.run(6789)
