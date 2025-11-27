defmodule Careyes.Repo.Migrations.CreateInstituicoesAndUsers do
  use Ecto.Migration

  def change do
    # 1. Tabela Instituições
    create table(:instituicoes) do
      add :nome, :string
      add :prefixo, :string # Ex: "my_"
      add :bloqueado, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end

    # Cria índice para buscar rápido pelo prefixo
    create index(:instituicoes, [:prefixo])

    # 2. Tabela Usuários
    create table(:users) do
      add :usuario, :string # Ex: "joao.silva"
      add :password_hash, :string
      add :tipo, :string # Ex: "institucional"
      add :bloqueado, :boolean, default: false, null: false

      # JSONB para guardar configurações flexíveis
      add :configuracoes, :map, default: %{}

      # Chave estrangeira ligando à instituição
      add :instituicao_id, references(:instituicoes, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    # Índice para garantir usuário único dentro da mesma instituição
    create unique_index(:users, [:usuario, :instituicao_id])
  end
end
