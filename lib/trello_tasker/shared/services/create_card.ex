defmodule TrelloTasker.Shared.Services.CreateCard do
  alias TrelloTasker.Cards
  alias TrelloTasker.Shared.Services.Trello
  alias TrelloTasker.Shared.Providers.CacheProvider.CardCacheClient

  @table "card-list"

  def execute(card) do
    card["path"]
    |> Trello.get_card()
    |> case do
      {:error, msg} ->
        {:trello_error, msg}

      card_info ->
        card
        |> Cards.create_card()
        |> return_call(card_info)
    end
  end

  defp return_call({:error, changeset}, _card_info), do: {:error, changeset}

  defp return_call({:ok, card}, card_info) do
    {:ok, cards} = CardCacheClient.recover(@table)

    new_cards_cache = cards ++ [card_info]
    CardCacheClient.save(@table, new_cards_cache)

    {:ok, card}
  end
end
