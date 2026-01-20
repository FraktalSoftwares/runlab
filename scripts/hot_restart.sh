#!/bin/bash

# Script para fazer hot restart no Flutter
# Uso: ./scripts/hot_restart.sh

# Encontra o processo do Flutter e envia comando 'R' para hot restart
# Isso funciona se você estiver rodando flutter run em modo interativo

echo "Para fazer hot restart, pressione 'R' (maiúsculo) no terminal onde o Flutter está rodando"
echo ""
echo "Ou use este script se o Flutter estiver rodando em background:"
echo "  pkill -USR1 -f 'flutter run'"

# Alternativa: se você souber o PID do processo Flutter
# kill -USR1 <PID>
