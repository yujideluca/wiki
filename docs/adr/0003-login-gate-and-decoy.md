# ADR-0003: One Elixir app as login gate, Google sign-in for one account, decoy for everyone else, Tailscale Funnel

- **Status:** accepted
- **Date:** 2026-10-22
- **Type (ISO/IEC/IEEE 14764):** initial
- **Decided by:** Giovanni (owner): web access, Google login with yujideluca@gmail.com, psychedelic decoy, Funnel.
  Shape of the implementation proposed by Claude Code.

## Context

The wiki describes Giovanni's whole setup, so it must be reachable from anywhere but readable only by Giovanni.
Anyone else should see only a decoy: an animated graph of gibberish and a login button.

## Decision

- **Address:** `tailscale funnel --bg 4180` publishes `https://yuji-nitro.tailed3a22.ts.net`; TLS ends at Tailscale,
  the server listens only on 127.0.0.1:4180. No router port, no domain.
- **Gate:** `Wiki.Web.Router` denies by default. Without a session holding the verified e-mail, page paths answer
  the decoy and `/data`, `/assets` answer 404. Sign-in is Google OpenID Connect through the Assent library (state
  and nonce checked, ID token verified); exactly `yujideluca@gmail.com` with `email_verified: true` gets an
  encrypted, signed, HttpOnly, Secure, SameSite=Lax cookie (30 days). The Google client stays in Testing mode with
  that one test user, so Google itself refuses other accounts.
- **Decoy:** one self-contained HTML file (inline canvas JS, no external URLs, no requests, CSP `default-src 'none'`).
- **Secrets:** `~/.config/wiki/oauth.env` and `secret.env`, mode 600, read by the systemd unit; never in git.

## Alternatives considered

- **oauth2-proxy in front of a static server** — the first draft; replaced when Giovanni chose Elixir for the back end.
- **Cloudflare Tunnel with an own domain** — nicer address, but needs a domain purchase; Giovanni chose Funnel.
- **Hand-written OAuth** — never; the library does the protocol.

## Consequences

Online only while the laptop is awake. Tests AU-1..AU-6 and DC-1 keep the gate and the decoy honest.
