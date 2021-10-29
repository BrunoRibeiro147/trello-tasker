defmodule TrelloTaskerWeb.CardInfoLive do
  use TrelloTaskerWeb, :live_view

  alias Phoenix.View
  alias TrelloTaskerWeb.CardView
  alias TrelloTasker.Shared.Services.Trello

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    card_info = Trello.get_card(id)
    card_comments = Trello.get_comments(id)

    {:ok, socket |> assign(comments: card_comments, card: card_info)}
  end

  @impl true
  def render(assigns) do
    View.render(CardView, "info.html", assigns)
  end
end
