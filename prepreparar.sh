#!/bin/bash

# Para o script parar em caso de erro
set -e

# Função para limpar arquivos e diretórios no diretório especificado
limpar_dir_publish() {
    local DIRETORIO="$1"  # Recebe o diretório como argumento

    # Muda para o diretório de destino
    cd "$DIRETORIO" || { echo "Falha ao acessar o diretório '$DIRETORIO'"; exit 1; }

    # Apagar todos os arquivos e diretórios, exceto .sh e arquivos ocultos
    find . -mindepth 1 ! -name ".*" ! -name "*.sh" ! -path "./.git/*" -exec rm -rf {} +

    # Verifica se a operação de remoção foi bem-sucedida
    if [ $? -eq 0 ]; then
        echo "Todos os arquivos e diretórios, exceto ocultos, foram apagados de '$DIRETORIO'."
    else
        echo "Falha ao apagar arquivos em '$DIRETORIO'."
        exit 1
    fi
}

# Muda para o diretório da área de trabalho
cd /home/giobon/Área\ de\ trabalho || { echo "Falha ao acessar a área de trabalho"; exit 1; }

# Verifica se a pasta "dendron (cópia)" existe
if [ -d "dendron (cópia)" ]; then
    cd "dendron (cópia)" || { echo "Falha ao entrar na pasta 'dendron (cópia)'"; exit 1; }
    echo "Entrou na pasta 'dendron (cópia)'"
    
    cd notes/
    python3 SCRIPT_TO_LOGSEQ.py
    echo "Processamento das notas concluído"

    # Diretório de destino
    DESTINO="/home/giobon/Documentos/Dendron_to_Logseq/dendron"

    # Apagar todos os arquivos no diretório de destino
    rm -f "$DESTINO"/*

    echo "Todos os arquivos em '$DESTINO' foram apagados."

    # Mover todos os arquivos .md da pasta atual para o diretório de destino
    if ls *.md 1> /dev/null 2>&1; then
        mv *.md "$DESTINO"
        echo "Todos os arquivos .md foram movidos para '$DESTINO'."
    else
        echo "Nenhum arquivo .md encontrado para mover."
    fi

    # Chamada da função
    limpar_dir_publish "/home/giobon/Documentos/Logseq_Publish"
else
    echo "A pasta 'dendron (cópia)' não existe."
fi

