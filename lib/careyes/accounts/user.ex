defmodule Careyes.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bcrypt

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc """
  Um changeset para criar/atualizar um usuário.
  """
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 6)
    |> validate_format(:email, ~r/^[^\s@]+@[^\s@]+\.[^\s@]+$/, message: "não é um e-mail válido")
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case get_change(changeset, :password) do    # Verifica se o :password foi enviado
      password when not is_nil(password) ->    # Se um novo password foi enviado
        hash = Bcrypt.hash_pwd_salt(password)
        put_change(changeset, :password_hash, hash)
      nil -> changeset # Se nenhum password novo foi enviado retorna o changeset como está
    end
  end
end
