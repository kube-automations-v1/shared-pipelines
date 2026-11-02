FROM postgres:17-alpine
# Scripts executados apenas na primeira inicialização do volume
COPY initdb/ /docker-entrypoint-initdb.d/
