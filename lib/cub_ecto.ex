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

end
