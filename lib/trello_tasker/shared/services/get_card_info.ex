defmodule TrelloTasker.Shared.Services.GetCardInfo do
  alias TrelloTasker.Shared.Services.Trello
  alias TrelloTasker.Shared.Providers.CacheProvider.CardCacheClient

  @table "card-list"

  def execute(id) do
    CardCacheClient.recover(id)
    |> case do
      {:ok, {card_comments, card_info}} ->
        {card_comments, card_info}

      {:not_found, []} ->
        {:ok, cards} = CardCacheClient.recover(@table)

        card_info = Enum.find(cards, &(&1.card_id == id))
        card_comments = Trello.get_comments(id)

        CardCacheClient.save(id, {card_comments, card_info})

        {card_comments, card_info}
    end
  end
end
