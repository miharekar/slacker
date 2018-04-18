require "./slack"
require "kemal"

get "/" do
  slack = Slack.new
  snoozed = slack.snoozed?
  status = slack.status_text

  render "views/index.ecr", "views/layout.ecr"
end

post "/" do |env|
  if env.params.body.has_key? "snooze"
    Slack.new.toggle_snooze
  elsif env.params.body.has_key? "pair"
    Slack.new.lets_pair
  elsif env.params.body.has_key? "run"
    Slack.new.gonna_run
  end
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
