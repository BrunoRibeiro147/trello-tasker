defmodule TrelloTasker.Shared.Services.FindAllCards do
  alias TrelloTasker.Cards
  alias TrelloTasker.Shared.Services.Trello
  alias TrelloTasker.Shared.Providers.CacheProvider.CardCacheClient

  @table "card-list"

  def execute() do
    CardCacheClient.recover(@table)
    |> case do
      {:not_found, []} ->
        IO.inspect("sem cache")

        cards =
          Cards.list_cards()
          |> Enum.map(&Trello.get_card(&1.path))

        CardCacheClient.save(@table, cards)
        cards

      {:ok, cards} ->
        cards
    end
  end
end
