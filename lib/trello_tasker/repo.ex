defmodule TrelloTasker.Repo do
  use Ecto.Repo,
    otp_app: :trello_tasker,
    adapter: Ecto.Adapters.Postgres
end
