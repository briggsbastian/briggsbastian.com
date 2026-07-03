---
title: 'The cloud box is a bouncer, not a server'
description: 'How I published a Minecraft server from my LAN with zero open home ports: a $5 Linode as the public face, and a WireGuard tunnel my side dials out.'
stage: 'budding'
planted: 2026-07-02
tended: 2026-07-02
topics: ['networking', 'security', 'homelab']
---

I wanted friends to reach a Minecraft server that lives on my LAN. The
usual answers are all some flavor of bad: port-forward and publish my home
IP to everyone who runs a scanner; rent a VPS big enough to run the
modpack itself (8 GB of JVM heap is real money); or hand the traffic to a
third-party tunnel service and hope they stay in business and out of my
packets.

The pattern I landed on instead: the cheap cloud box doesn't run the game
at all. It's a bouncer. Players connect to `play.briggsbastian.com` on the
Linode, nftables DNATs the flow down a WireGuard tunnel, and the actual
server runs at home on the box with the RAM. The part that makes it work
behind NAT is the direction of the handshake — the *home* side dials out
and keeps the tunnel alive with keepalives, so nothing ever needs to reach
in. No inbound rule on the home firewall, the home IP never appears in
DNS, and every drive-by scan on the internet lands on a $5 box that runs
nothing but a kernel and a tunnel. WireGuard won't even answer a probe
without a valid peer key, so the one open UDP port leaks nothing.

What it costs, honestly. The masquerade on the cloud side means every
player arrives at the server wearing the tunnel's address — IP bans and
IP whitelists are meaningless, and username-level moderation is the only
lever left. And the bounce adds latency: I measured it, and players pay
roughly 10–25 ms over connecting directly. For a modded co-op server
that's nothing; for a twitch shooter it might not be.

The part I keep chewing on: this took two small Nix files and a
`terraform apply` — the cloud box had actually been torn down for weeks,
and it came back *because* it was code. Now that the pattern exists, it
wants to become the front door for everything else I self-host, and I'm
not sure where that ends. Follow it far enough and I've built myself a
tiny, worse Cloudflare, one DNAT rule at a time. The site-to-site mesh
from the original plan is still the more general answer; this tunnel is a
single-purpose special case that shipped first because it had a deadline
shaped like a friend asking "can we play tonight?"
