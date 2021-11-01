defmodule TrelloTasker.Shared.Providers.CacheProvider.CardCache do
  use GenServer

  @db :cards

  def start_link(_), do: GenServer.start_link(__MODULE__, %{}, name: :cards_cache)

  def init(state) do
    :ets.new(@db, [:set, :public, :named_table])
    {:ok, state}
  end

  def handle_call({:get, key}, _from, state) do
    response =
      :ets.lookup(@db, key)
      |> case do
        [] -> {:not_found, []}
        [{_k, value}] -> {:ok, value}
      end

    {:reply, response, state}
  end

  def handle_cast({:put, key, value}, state) do
    :ets.insert(@db, {key, value})
    {:noreply, state}
  end
end
