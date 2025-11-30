defmodule Careyes.Institutions.Instituicao do
  use Ecto.Schema
  import Ecto.Changeset

  schema "instituicoes" do
    field :nome, :string
    field :prefixo, :string # Ex: "my_"
    field :bloqueado, :boolean, default: false

    #timestamps()
  end
end
