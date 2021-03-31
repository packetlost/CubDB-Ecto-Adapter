# CubEcto  🚀
## ESL Internal Hackathon 2021
#### Team Erlingers: Raúl Chouza & Carlo Gilmar


Create an Ecto adapter for the [Cub DB](https://hex.pm/packages/cubdb) library.


## Inspiration 💖

Although the BEAm ecosystem have multiple databases as ETS, DETS, or Mnesia, there are few options for sql-like storage engines. 

Our idea is create an Ecto Adapter for `Cub DB`, a embedded key-value database written in Elixir. 

We considered create an adapter for other options, but we choosed Cub DB because it's relative newest in the ecosystem and it looks like a great opportunity to contribute. 

Other projects that we found to take inspiration and guidance were:

- [Dynamo Ecto Adapter](https://github.com/circles-learning-labs/ecto_adapters_dynamodb)
- [ETSO Ets Ecto Adapter](https://github.com/evadne/etso)
- [ets_ecto Ets Ecto adapter](https://github.com/wojtekmach/ets_ecto)


## Personal Goals ⚽️

- Contribute to grow the tools for Cub DB 
- Learn about `Ecto Adapters`
- Search similar projects and explore them to see how they are implementing their adapters


## Scope 🏹

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

## Achievements 🎉

- Implement `Ecto.Adapter`
- Create our own `Repo` and start the Cube DB process
- Implement `Ecto.Adapter.Schema`
- Autogenerate UUIDS for inserts
- Insert a schema
- Delete a schema
- Implement `Ecto.Adapter.Queryable`

## Nexts Steps 👣

We focused on implement the Ecto.Adapter and be able to insert a schema:

- Implement: `insert all`, `update`
- Implement the `execute/5` function from Ecto.Adapter.Queryable to make searches 
- Add tests, clean the code and add refactors

## DEMO 

You can download our video here: (MOV file)
[Download Video Demo](https://drive.google.com/file/d/1g6uYU_yDiRLaxfhaIyROwb_y9zYtkwzU/view?usp=sharing)
