defmodule CubEcto do

  @behaviour Ecto.Adapter

  @impl true
  defmacro __before_compile__(_env), do: :ok

  @impl true
  @spec init(config :: Keyword.t()) :: {:ok, :supervisor.child_spec(), Ecto.Adapter.adapter_meta()}
  def init(_config \\ []) do
    child_spec = CubDB.child_spec(data_dir: "../cubecto", name: CubEcto, auto_compact: true)
    {:ok, child_spec, %{}}
  end

  @impl true
  @spec checkout(Ecto.Adapter.adapter_meta(), Keyword.t(), (() -> any())) :: any()
  def checkout(_adapter_meta, _config, function) do
    function.()
  end

  @impl true
  @spec dumpers(Ecto.Type.primitive(), Ecto.Type.t()) :: [(term() -> {:ok, term()} | :error) | Ecto.Type.t()]
  def dumpers(:binary_id, type), do: [type, Ecto.UUID]
  def dumpers(_primitive, type), do: [type]

  @impl true
  @spec loaders(Ecto.Type.primitive(), Ecto.Type.t()) :: [(term() -> {:ok, term()} | :error) | Ecto.Type.t()]
  def loaders(:binary_id, type), do: [Ecto.UUID, type]
  def loaders(_primitive, type), do: [type]

  @impl true
  @spec ensure_all_started(Keyword.t(), :permanent | :transient | :temporary) :: {:ok, [atom()]} | {:error, atom()}
  def ensure_all_started(config, _type) do
    with {:ok, _} = Application.ensure_all_started(:cub_ecto) do
      {:ok, [config]}
    end
  end

  @behaviour Ecto.Adapter.Schema

  alias Ecto.Adapter.Schema

  @impl true
  @spec autogenerate(:id | :binary_id | :embed_id) :: term() | nil
  def autogenerate(_any), do: Ecto.UUID.generate()

  @impl true
  @spec insert(Schema.adapter_meta(), Schema.schema_meta(), Schema.fields(), Schema.on_conflict(), Schema.returning(), Schema.options()) :: {:ok, Schema.fields()} | {:invalid, Schema.constraints()}
  def insert(%{pid: pid}, schema_meta, fields, on_conflict, returning, opts) do
    # Handle fetch for Ecto {:error, stale callback}

    IO.inspect(schema_meta)
    IO.inspect(fields)
    IO.inspect(on_conflict)
    IO.inspect(returning)
    IO.inspect(opts)

    id = Keyword.fetch!(fields, :id)
    if CubDB.has_key?(pid, id) do
      {:invalid, primary_key: "Already exists"}
    else
      :ok = CubDB.put(pid, id, fields)
      {:ok, fields}
    end
  end

  @impl true
  @spec insert_all(Schema.adapter_meta(), Schema.schema_meta(), [atom()], [[{atom(), term() | {Ecto.Query.t(), list()}}]], Schema.on_conflict(), Schema.returning(), Schema.options()) :: {integer(), [[term()]] | nil}
  def insert_all(%{pid: _pid}, _schema_meta, _header, rows, _on_conflict, _returning, _opts) do
    IO.inspect(rows)
    {0, nil}
    #if Enum.any?(rows, CubDB.has_key?(pid, fn row -> row.id end)) do
    #  IO.inspect(rows)
    #  # error
    #  {nil}
    #else
    #  IO.inspect(rows)
    #  #CubDB.put_multi(pid, )
    #  {1, [[:ok]]}
    #end
  end

  @impl true
  @spec update(Schema.adapter_meta(), Schema.schema_meta(), Schema.fields(), Schema.filters(), Schema.returning(), Schema.options()) :: {:ok, Schema.fields()} | {:invalid, Schema.constraints()} | {:error, :stale}
  def update(%{pid: pid}, _schema, fields, _filters, _returning, _options) do
    # Handle fetch for Ecto {:error, stale callback}
    id = Keyword.fetch!(fields, :id)
    if CubDB.has_key?(pid, id) do
      :ok = CubDB.put(pid, id, fields)
      {:ok, fields}
    else
      {:invalid, primary_key: "Primary key doesn't exists"}
    end
  end

  @impl true
  @spec delete(Schema.adapter_meta(), Schema.schema_meta(), Schema.filters(), Schema.options()) :: {:ok, Schema.fields()} | {:invalid, Schema.constraints()} | {:error, :stale}
  def delete(%{pid: pid}, _wat, filters, _options) do
    case Keyword.fetch(filters, :id) do
      {:ok, id} ->
        record = CubDB.get(pid, id)
        :ok = CubDB.delete(pid, id)
        {:ok, Enum.to_list(record)}

      :error ->
        {:error, :stale}
    end
  end
end
