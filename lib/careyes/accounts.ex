defmodule Careyes.Accounts do
  alias Careyes.Repo
  alias Careyes.Accounts.User
  alias Bcrypt

  def register_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def authenticate_user(email, password) do
    case get_user_by_email(email) do
      nil -> {:error, :unauthorized}
      user -> verify_password(user, password)
    end
  end

  defp get_user_by_email(email), do: Repo.get_by(User, email: email)

  defp verify_password(user, password) do
    if Bcrypt.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :unauthorized}
    end
  end

end
