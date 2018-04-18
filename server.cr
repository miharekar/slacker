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

get "/api/pair" do
  Slack.new.lets_pair
end

get "/api/pairing" do
  slack = Slack.new
  slack.status_emoji == ":rubberduck:" ? "1" : "0"
end

get "/api/run" do
  Slack.new.gonna_run
end

get "/api/running" do
  slack = Slack.new
  slack.status_emoji == ":runner:" ? "1" : "0"
end

Kemal.run(6789)
