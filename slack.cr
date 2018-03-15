require "yaml"
require "json"
require "http/client"

class Slack
  BASE = "https://slack.com/api/"
  QUOTE_API = "http://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en"
  getter token : String

  def initialize
    @token = secrets["slack"]["token"].to_s
  end

  def toggle_snooze
    if snoozed?
      dnd_off
    else
      dnd_on
    end
  end

  def dnd_off
    end_snooze!
    set_status!("status_text": quote, "status_emoji": ":coffee:")
  end

  def dnd_on
    set_snooze!
    set_status!(status_text: "In a meeting", status_emoji: ":phone:")
  end

  def status_text
    body = get("users.profile.get").body
    JSON.parse(body)["profile"]["status_text"]
  end

  def snoozed? : Bool
    body = get("dnd.info").body
    JSON.parse(body)["snooze_enabled"].to_s == "true"
  end

  private def set_snooze!(duration = "60")
    get("dnd.setSnooze", {"num_minutes" => duration})
  end

  private def end_snooze!
    post("dnd.endSnooze")
  end

  private def set_status!(status_text : String, status_emoji : String)
    profile = {"status_text" => status_text, "status_emoji" => status_emoji}.to_json
    post("users.profile.set", {"profile" => profile})
  end

  private def get(endpoint, params = Hash(String, String).new)
    params["token"] = token
    params = HTTP::Params.encode(params)
    url = BASE + endpoint + '?' + params
    HTTP::Client.get(url)
  end

  private def post(endpoint, params = Hash(String, String).new)
    params["token"] = token
    url = BASE + endpoint
    # HTTP::Client.post(url, form: params) # Crystal 0.24.2
    HTTP::Client.post_form(url, form: params) # Crystal 0.23.1
  end

  private def quote
    body = HTTP::Client.get(QUOTE_API).body
    json = JSON.parse(body)
    text = json["quoteText"].to_s.strip
    raise "Too long" if text.size > 100
    text
  rescue
    p "Retrying"
    sleep 1
    quote
  end

  private def secrets
    YAML.parse(File.open("secrets.yml"))
  end
end
