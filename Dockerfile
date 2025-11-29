# --- Estágio 1: Builder (Compilação) ---
FROM elixir:1.14-alpine as builder

# Instala dependências de build no sistema operacional
RUN apk add --no-cache build-base git nodejs npm

# Prepara diretório de trabalho
WORKDIR /app

# Instala Hex e Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Define ambiente de produção
ENV MIX_ENV=prod

# Copia arquivos de configuração de dependências
COPY mix.exs mix.lock ./
COPY config config

# Instala e compila dependências
RUN mix deps.get --only prod
RUN mix deps.compile

# Copia os assets e compila (se tiver frontend/liveview)
COPY assets assets
RUN mix assets.deploy

# Copia o resto do código
COPY lib lib
COPY priv priv

# Compila o projeto e gera o release
RUN mix compile
RUN mix release

# --- Estágio 2: Runner (Execução) ---
FROM alpine:3.19

# Instala dependências de runtime necessárias (OpenSSL, ncurses, libstdc++)
RUN apk add --no-cache libstdc++ openssl ncurses-libs

WORKDIR /app

# Copia o release compilado do estágio anterior
COPY --from=builder /app/_build/prod/rel/careyes ./

# Define o usuário padrão (segurança)
RUN adduser -D appuser
USER appuser

# Define variáveis de ambiente padrão
ENV HOME=/app
ENV PHX_SERVER=true

# Comando para iniciar o servidor
CMD ["bin/careyes", "start"]