#!/bin/bash

#
# Script para monitoramento de espaco em disco do PABXIP
#

# Especifica o caminho dos comandos
DF="/bin/df"
ECHO="/bin/echo"
UNAME="/bin/uname"
IFCONFIG="/sbin/ifconfig"
SED="/bin/sed"
AWK="/usr/bin/awk"
HEAD="/usr/bin/head"
SORT="/usr/bin/sort"
STATUS="E-MAIL ENVIADO COM SUCESSO"
CLIENTE="HOSPITAL CRUZ VERMELHA"

# Executa o comando df para obter o quinto campo "porcentagem em uso", ordena por espaco em uso e armazena na variavel $EMUSO
#
# Use esta opcao para particionamento convencional
#EMUSO=`$DF -h |$AWK '{print $5}'|$SORT -nr|$AWK -F % '{print $1}'|$HEAD -n1`
# Use esta opcao para particionamento com LVM (padrao Logical Volume da instalacao do ELASTIX)

echo $STATUS;

EMUSO=`$DF -h |$SED -n 3p|$AWK '{print $4}'|$AWK -F % '{print $1}'`


# Define as variaveis $RISCO e $CHEIO com o texto para o conteudo dos e-mails que serao enviados. Inclui tambem a captura dos dados dos comandos df -h, ifconfig e uname -a
RISCO="O disco esta com sua capacidade proxima ao limite para o uso adequado.\n"
CHEIO="O disco excedeu sua capacidade para o uso adequado.\n\nEntre em contato com a ACOMIP com urgencia!! suportecnico@acomip.com.br \n\n "

# Define a variavel $SUBJECT como o campo subject (Assunto) a ser utilizado no e-mail
SUBJECT="$CLIENTE Alerta de espaco em disco no PABXIP ACOMIP  - Disco com $EMUSO % em uso"

# Define as variaveis $EMAIL_ADM e $EMAIL_CLI como os enderecos de email do admin/suporte ACOMIP e do cliente respectivamente
EMAIL_ADM="suportecnico@acomip.com.br"
EMAIL_CLI="noc@acomip.com.br"

# Executa a verificacao do espaco em disco com a funcao "case" usando o valor obtido nos comandos da variavel $EMUSO
case $EMUSO in
        # Se o valor for entre 80 e 99 % segue o fluxo
       # [8-9][0-9])
         [4-9][0-9])


                # Envia um email para os administradores e para o cliente com os valores obtidos na execucao do script
                $ECHO -e "$RISCO" | echo -e "$SUBJECT" "$CHEIO" | mail -s "$SUBJECT" $EMAIL_ADM $EMAIL_CLI;;
        # Se o valor for 85 % segue o fluxo
        85)
                # Envia um email para os administradores e para o cliente com os valores obtidos na execucao do script
                $ECHO -e "$CHEIO" | $MUTT -s "$SUBJECT" $EMAIL_ADM $EMAIL_CLI;;
# Se nenhuma das especificacoes forem atendidas, finaliza o fluxo e encerra o script
esac
