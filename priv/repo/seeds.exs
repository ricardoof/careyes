# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Careyes.Repo.insert!(%Careyes.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Script para popular o banco de dados.
# Você pode rodá-lo com: mix run priv/repo/seeds.exs

# Script para popular o banco de dados.
# Rode com: mix run priv/repo/seeds.exs

alias Careyes.Repo
alias Careyes.Accounts.User
alias Careyes.Institutions.Instituicao

# 1. LIMPEZA (Reset)
# Apagamos tudo para garantir um estado limpo
Repo.delete_all(User)
Repo.delete_all(Instituicao)

IO.puts "🧹 Banco de dados limpo."

# 2. CRIAR INSTITUIÇÃO
instituicao = %Instituicao{
  nome: "MedYes",
  prefixo: "my_",
  bloqueado: false
}
|> Repo.insert!()

IO.puts "✅ Instituição 'MedYes' criada com ID: #{instituicao.id}"

# 3. CRIAR USUÁRIO
# Usamos o changeset para garantir que a senha seja hasheada corretamente.
params_usuario = %{
  "usuario" => "joao.silva",
  "password" => "123123",
  "tipo" => "institucional",
  "bloqueado" => false,
  "instituicao_id" => instituicao.id,
  "configuracoes" => %{
    "permissao" => "funcionario",
    "acesso_mobile" => true
  }
}

%User{}
|> User.changeset(params_usuario)
|> Repo.insert!()

IO.puts "✅ Usuário 'joao.silva' criado com senha criptografada."
