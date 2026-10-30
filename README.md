# FuelCalc

A **Phoenix web application** that calculates the fuel needed for a multi-step space flight
(for example Earth → Moon → Earth), written in **Elixir**.

## How it works

The user builds a route out of launch and landing steps and picks a spaceship. The app validates the route and
computes the fuel needed for every step, including the **fuel needed to carry the fuel** — the calculation is
repeated recursively until the additional fuel becomes zero or negative.

| Spaceship      | Mass (kg) | Planet | Gravity (m/s²) |
|----------------|-----------|--------|----------------|
| Apollo_11      | 28 801    | Earth  | 9.807          |
| Mars_Mission   | 14 606    | Mars   | 3.711          |
| Passenger_Ship | 75 432    | Moon   | 1.62           |

Formulas (rounded down):
- launch: `mass × gravity × 0.042 − 33`
- landing: `mass × gravity × 0.033 − 42`

The route is calculated backwards from the final landing, because each earlier step must also lift the fuel for every later step.

### Validation rules

- The flight must start on Earth and end on Earth
- Launch and landing planet of a step must be different
- One spaceship for the whole route
- Unknown planets or spaceships are rejected with a clear error message

## Architecture

- `FuelCalc.Computator` — recursive fuel calculation and route validation (pure functions, pattern matching)
- `FuelCalc.Service.FcServer` — GenServer entry point; each calculation runs in a task under `Task.Supervisor`
- `FuelCalc.FcCacher` — ETS-based cache: repeated identical routes are answered from memory without recalculation
- `FuelCalc.Repo` — in-memory catalogue of planets and spaceships

## Tech stack

Elixir · Phoenix 1.6 · GenServer · Task.Supervisor · ETS · ExUnit · ExCoveralls · Credo

## Getting started

Requirements: Erlang/OTP 24+, Elixir 1.12+, Node.js (for assets).

```bash
mix deps.get
cd assets && npm install && cd ..
iex -S mix phx.server
```

Open <http://localhost:4000/fuel>.

## Tests

```bash
mix test
mix coveralls.html
```
