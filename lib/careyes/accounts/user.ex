defmodule Careyes.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :usuario, :string # Ex: "joao.silva" (sem o prefixo)
    field :password_hash, :string
    field :tipo, :string # Ex: "institucional"
    field :bloqueado, :boolean, default: false

    # Campo para guardar o JSON de configurações que o Adonis retornava
    field :configuracoes, :map

    field :instituicao_id, :integer

    # Campo virtual apenas para receber a senha no cadastro (se houver)
    field :password, :string, virtual: true

    timestamps()
  end
end
