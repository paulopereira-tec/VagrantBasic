#!/bin/bash

#################### SCRIPT PARA BACKUP MYSQL ####################
#                                                                #
# Jeferson R. Costa <rc.jeferson@gmail.com>                      #
# Created Feb, 2013                                              #
# Update Feb, 2013                                               #
# Fonte:                                                         #
# www.vivaolinux.com.br/script/Script-de-backup-MySQL-melhorado  #
#                                                                #
##################################################################
#                                                                #
# Para adicionar este arquivo no agendador de tarefas do linux   #
# para ser executado automaticamente há cada hora, siga o passo- #
# a-passo:                                                       #
# 1. Abra o arquivo de agendamento com privilégios de            #
#    de administrador.                                           #
#    sudo crontab -e                                             #
# 2. Adicione a seguinte linha no final do arquivo               #
#    00 * * * * /vagrant/vagrant/mysql/backup.sh                 #
#                                                                #
##################################################################

# Definindo parametros do MySQL
echo "  -- Definindo parametros do MySQL ..."
DB_NAME='gestor'
DB_USER='root'
DB_PASS='root'
DB_PARAM='--add-drop-table --add-locks --extended-insert --single-transaction --routines -quick'

# Definindo parametros do sistema
echo "  -- Definindo parametros do sistema ..."
DATE=`date +%Y-%m-%d_%H-%M-%s`
MYSQLDUMP=/usr/bin/mysqldump
BACKUP_DIR=/vagrant/vagrant/mysql/backup/
BACKUP_NAME=mysql-$DATE.sql
BACKUP_TAR=mysql-$DATE.tar

# Apagando todos os arquivos anteriormente salvos
# rm -rf $BACKUP_DIR/*

#Gerando arquivo sql
echo "  -- Gerando Backup da base de dados $DB_NAME em $BACKUP_DIR/$BACKUP_NAME ..."
$MYSQLDUMP $DB_NAME $DB_PARAM -u $DB_USER -p$DB_PASS > $BACKUP_DIR/$BACKUP_NAME

# Compactando arquivo em tar
echo "  -- Compactando arquivo em tar ..."
tar -cf $BACKUP_DIR/$BACKUP_TAR -C $BACKUP_DIR $BACKUP_NAME

# Compactando arquivo em bzip2
echo "  -- Compactando arquivo em bzip2 ..."
bzip2 $BACKUP_DIR/$BACKUP_TAR

# Excluindo arquivos desnecessarios
echo "  -- Excluindo arquivos desnecessarios ..."
rm -rf $BACKUP_DIR/$BACKUP_NAME