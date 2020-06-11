#!/usr/bin/env bash

# File: vagrant/cron/cron-job.sh

# Write current date to cron.html
#!/bin/sh
# bkp_seubanco.sh

# DATA vai imprimir a data no estio dia-mes-ano
DATA=`/bin/date +%d-%m-%Y`

# NOME armazena o nome do arquivo de backup e
# o diretorio onde o arquivo será salvo no meu caso
# /www/virtual/backup é uma pasta publica do apache,
# coloque o diretório onde quer guardar o backup.

DESTINY="/vagrant/vagrant/mysql/data/ecology-$DATA.sql"

# variaveis do MySQL
HOST="localhost"
USER="root"
PASSWORD="root"
DATABASE="ecology"

mysqldump -h $HOST -u $USER -p$PASSWORD $DATABASE > $DESTINY