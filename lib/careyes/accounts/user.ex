defmodule Careyes.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bcrypt

  schema "usuarios" do
    field :usuario, :string
    #field :password_hash, :string
    field :tipo, :string
    field :bloqueado, :boolean, default: false
    field :configuracoes, :map
    field :instituicao_id, :integer

    field :password, :string, virtual: true

    #timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:usuario, :password, :tipo, :bloqueado, :configuracoes, :instituicao_id])
    |> validate_required([:usuario, :password, :tipo, :instituicao_id])
    |> put_password_hash()
  end

  # Esta função deve estar definida DENTRO do módulo, mas pode ser privada (defp)
  defp put_password_hash(changeset) do
    case get_change(changeset, :password) do
      password when is_binary(password) ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
      _ ->
        changeset
    end
  end
end
