defmodule TrelloTasker.Shared.Services.Trello do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.trello.com/1/cards"
  plug Tesla.Middleware.Headers, [{"User-Agent", "request"}]
  plug Tesla.Middleware.JSON

  @token Application.get_env(:trello_tasker, :trello)[:token]
  @key Application.get_env(:trello_tasker, :trello)[:key]

  def get_card(card_id) do
    {:ok, response} =
      "#{card_id}?list=true&key=#{@key}&token=#{@token}"
      |> get()

    mount_card_map(response.body, response.status)
  end

  def get_comments(card_id) do
    {:ok, response} =
      "#{card_id}/actions?commentCard=true&key=#{@key}&token=#{@token}"
      |> get()

    body = response.body

    body
    |> Enum.map(&%{text: &1["data"]["text"], user: &1["memberCreator"]["username"]})
  end

  defp mount_card_map(body, 200) do
    {:ok, delivery_date, _} = DateTime.from_iso8601(body["due"])

    %{
      name: body["name"],
      description: body["desc"],
      image: body["cover"]["sharedSourceUrl"],
      card_id: body["shortLink"],
      completed: body["dueComplete"],
      delivery_date: DateTime.to_date(delivery_date)
    }
  end

  defp mount_card_map(_body, _status) do
    {:error, "Erro ao buscar o card"}
  end
end
