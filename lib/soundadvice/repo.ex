defmodule Soundadvice.Repo do
  use Ecto.Repo,
    otp_app: :soundadvice,
    adapter: Ecto.Adapters.Postgres
end
