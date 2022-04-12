defmodule College.Repo do
  use Ecto.Repo,
    otp_app: :college,
    adapter: Ecto.Adapters.Postgres

  use Paginator
end
