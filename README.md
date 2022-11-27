# FuelCalc

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Prerequisites

- [Erlang 24+](http://www.erlang.org/download.html)
- [Elixir 1.12+](http://elixir-lang.org/install.html)
- [Node.js 10.19.0+](https://nodejs.org/en/download/)

## Development Setup
1. Fetch dependencies - `mix deps.get`
2. Fetch Node.js dependencies - `cd assets && npm install && cd ..`
3. Start dev environment - `iex -S mix phx.server`
4. Open WEB app in your browser - `http://localhost:4000(2)`

##  Starting the elixir nodes in cluster locally
iex --name a@127.0.0.1 --erl "-connect_all true" --cookie "a_cookie" -S mix phx.server
iex --name b@127.0.0.1 --erl "-connect_all true" --cookie "a_cookie" -S mix phx.server
$> Node.connect :"a@127.0.0.1"
_true_
