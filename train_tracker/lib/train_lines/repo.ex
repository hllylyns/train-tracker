defmodule TrainLines.Repo do
  use Ecto.Repo,
    otp_app: :train_tracker,
    adapter: Ecto.Adapters.Postgres
end
