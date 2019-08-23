defmodule Reqrecipe.Repo do
  use Ecto.Repo,
    otp_app: :reqrecipe,
    adapter: Ecto.Adapters.Postgres
end
