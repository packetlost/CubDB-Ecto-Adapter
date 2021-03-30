# CubEcto

## Scope

Create an Ecto adapter for the [CubDB](https://hex.pm/packages/cubdb) library.

* Leverage Ecto.Repo for basic CRUD calls.
* Leverage Ecto.Query for composing more complex calls.

## Installation

Installation through github:

```elixir
def deps do
  [
    {:cub_ecto, git: "git@github.com:chouzar/cubecto.git", branch: "main"}
  ]
end
```
