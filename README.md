# STLd

A simple wrapper around gstreamer for creating a reliable low-latency Studio Transmitter Link. 

## Usage

### Sending

	stld tx
		--host 10.32.100.1
		--port 3600
		[--redundancy 0-2]
		--source 'alsasrc device="hw:0"'	(using ALSA)
		--source 'jackaudiosrc connect=1'	(using JACK)
		--source 'custom gstreamer string'

### Receiving

	stld rx
		--host 0.0.0.0
		--port 3600
		--sink 'alsasink device="plughw:0"'


Note the host parameter is the address to bind on. STLd provides no authentication. It is recommended to use a firewall to only accept UDP traffic from a known host, or - for example over the internet - to pair with a lightweight point-to-point VPN such as ZeroTier One. 

## Real World Use

This software is used in production at Insanity Radio. 

## Why not X?

We wrote this software to replace a faulty pair of Barix/Sonifex streaming boxes. 

Other software (such as our alumnus James Harrison's OpenOB) is brilliant and serves as inspiration for this project. However, OpenOB only supports error correction for OPUS/CELT codecs. STLd out-of-the-box uses Redundant RTP coding (audio/red) to improve reliability via the internet (or other networks which may experience a small level of packet loss). 

## Docker Usage

Note: JackD doesn't play nice inside Docker. ALSA works but requires the container to be launched with privileges. 

```
docker build . -t insanityradio/stld:latest
docker run --name stl --restart=always --device /dev/snd --net host --privileged -d insanityradio/stld:latest tx --host 10.0.0.10 --port 3600 --source "alsasrc device=plughw:0" --redundancy 2
docker run --name stl --restart=always --device /dev/snd --net host --privileged -d insanityradio/stld:latest rx --host 0.0.0.0 --port 3600 --sink 'alsasink device="plughw:0"'
```

## Development

This project requires gstreamer-1.0 with the good and bad plugins installed. Rather than using gstreamer native bindings, this application directly invokes gst-launch-1.0 with a suitable scheduling priority. 
