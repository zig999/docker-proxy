# Variáveis de ambiente

O objetivo do teste é permitir setar toda a configuração do proxy quando necessário.
A princípio, é necessário configurar o proxy para os comandos apt-get e como variáveis de ambiente.

## Bashscripts
O arquivo deve ser salvo com EOL (quebra de linha) no formato Unix (LF).

No Notepad++, *Edit > EOL Conversion*. Caso contrário dá erro na execução

## Executando o script via Dockerfile
Para setar variáveis de ambiente através do script, é necessário executá-las tanto no contexto do build, como no context de inicialização do container.
Para inicialização do container, é utilizando um wrapper script:

    #!/bin/sh
    # Load the script of environment variables
    . /root/configproxy.sh
    # Run the main container command
    exec "$@"

`configproxy.sh` é o script que atribui as variáveis de ambientes desejadas.

>#TODO No caso de configuração do PROXY, as variáveis deveriam ser condicionadas a ter ou não acesso a internet.

No Dockerfile, é necessário configurar o wrapper script como ENTRYPOINT do container.

A linha `CMD` ao final é para executar o bash e manter o container executando.

## Build

A configuração do proxy é condicionada à utilização da --build-arg user=<>. É possível utilizar o mesmo Dockerfile para ambas as situações, com ou sem proxy.

### Build sem proxy

    docker build -t img01 -f Dockerfile . 

### Build com proxy

    docker build -t img01 --build-arg user=<USER> --build-arg pass=<PASS> -f Dockerfile . 

# Scripting

## EOL Unix

Ao editar os arquivos no Windows, sempre verificar a configuração do caracter de quebra de linha.

# Running

Para criar o container:

    docker run -it -v c:\temp:/hosttemp --name teste01 img01

Onde:

- -it -i para permitir nossa interação com o container e -t.
- -v é a tag de *bind mount*.  
- --name para fixar um nome para o container.