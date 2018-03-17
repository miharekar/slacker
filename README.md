# slack

A simple utility to turn Slack's snooze mode on and off e.g. when you go into a meeting.

With the server running you can teach Siri on your HomePod/iPhone to change your Slack status like this (click for video demo):

[![Siri Do Not Disturb](https://pbs.twimg.com/ext_tw_video_thumb/974351899448180736/pu/img/m6ICgZpFm5ku3xci.jpg)](https://twitter.com/mr_foto/status/974351952825016320/video/1)

## Installation

You'll need `secrets.yml` file with Slack's [legacy token](https://api.slack.com/custom-integrations/legacy-tokens). It needs to have this structure:

```
slack:
  token: your-token-goes-here
```

You'll also need to install [Crystal](https://crystal-lang.org/). It's trivial to do on a [modern computer](https://crystal-lang.org/docs/installation/).

On a Raspberry Pi you have to install a semi-official build via [Portalier](http://public.portalier.com/raspbian/).


## Usage

### On a modern computer

1. `shards install`
2. `crystal run server.cr`
3. http://localhost:6789/

### On a Raspberry Pi

1. `shards install`
2. `crystal build -p server.cr`
3. `./server`
4. http://raspberrypi.local:6789/

| Normal                                           | Snoozed                                           |
|--------------------------------------------------|---------------------------------------------------|
| ![Normal Slack](https://i.imgur.com/CtRjI8v.png) | ![Snoozed Slack](https://i.imgur.com/NjYs69D.png) |


## Usage with Homebridge

You'll need:
- [homebridge](https://github.com/nfarina/homebridge)
- [homebridge-http](https://github.com/rudders/homebridge-http)
- Both `homebridge` and `server` running in the background via `systemd`
- Homebridge config along these lines:

```
"accessories":[
  {
    "accessory": "Http",
    "name": "Slack",
    "switchHandling": "yes",
    "http_method": "GET",
    "on_url":      "http://127.0.0.1:6789/api/on",
    "off_url":     "http://127.0.0.1:6789/api/off",
    "status_url":  "http://127.0.0.1:6789/api/status",
    "service": "Switch"
   }
],
```

## Contributing

Feel free to fork and customize with your own API calls: https://api.slack.com/methods
