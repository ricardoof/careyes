defmodule Careyes.Accounts do
  alias Careyes.Repo
  alias Careyes.Accounts.User
  alias Bcrypt

  def register_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  defp get_user_by_email(email), do: Repo.get_by(User, email: email)

end
