defmodule Careyes.Repo do
  use Ecto.Repo,
    otp_app: :careyes,
    adapter: Ecto.Adapters.MyXQL
end
