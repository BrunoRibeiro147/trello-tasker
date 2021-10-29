defmodule TrelloTaskerWeb.CardLive do
  use TrelloTaskerWeb, :live_view

  alias Phoenix.View
  alias TrelloTasker.Cards.Card
  alias TrelloTasker.Cards
  alias TrelloTaskerWeb.CardView
  alias TrelloTasker.Shared.Services.Trello

  @impl true
  def mount(_params, _session, socket) do
    changeset = Card.changeset(%Card{})

    cards =
      Cards.list_cards()
      |> Enum.map(&Trello.get_card(&1.path))

    socket = assign(socket, cards: cards, changeset: changeset)

    {:ok, socket}
  end

  @impl true
  def handle_event("create", %{"card" => card}, socket) do
    changeset = %Ecto.Changeset{Card.changeset(%Card{}, card) | action: :insert}

    changeset.valid?
    |> case do
      false ->
        {:noreply, assign(socket, :changeset, changeset)}

      true ->
        card["path"]
        |> Trello.get_card()
        |> case do
          {:error, msg} ->
            {:noreply, socket |> put_flash(:error, msg) |> push_redirect(to: "/")}

          _card_info ->
            card
            |> Cards.create_card()
            |> response(socket)
            |> IO.inspect()
        end
    end
  end

  defp response({:ok, _card}, socket),
    do:
      {:noreply, socket |> put_flash(:info, "Card criado com sucesso") |> push_redirect(to: "/")}

  defp response({:error, changeset}, socket),
    do: {:noreply, assign(socket, :changeset, changeset)}

  @impl true
  def render(assigns) do
    View.render(CardView, "index.html", assigns)
  end
end
