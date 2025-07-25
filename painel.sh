instalar_aplicacoes() {
  termux-setup-storage

  echo "🔁 Atualizando Termux e instalando pacotes..."
  pkg update -y && pkg upgrade -y
  pkg install -y git curl wget proot-distro python nodejs ruby perl clang cmake make zsh vim nano figlet toilet cowsay lolcat htop neofetch openssh dnsutils net-tools nmap whois termux-api

  echo "📦 Instalando Ubuntu..."
  proot-distro install ubuntu

  echo "🐉 Baixando Kali NetHunter..."
  wget -O install-nethunter-termux https://offs.ec/2MceZWr
  chmod +x install-nethunter-termux
  ./install-nethunter-termux
}

ver_atalhos() {
  bash ~/atalhos.sh
  echo " "
  read -p "Enter para voltar..."
}

pacotes_instalados() {
  echo "📦 Pacotes instalados:"
  echo "═══════════════════════════════════════════════════════════════════════" | lolcat
  apt list --installed 2>/dev/null | lolcat
  echo " "
  read -p "Enter para voltar..."
}

meus_scripts() {
  echo "Executando Meus Scripts Favoritos..."
  echo " "
  read -p "Enter para voltar..."
}

info_sistema() {
  echo "🖥️ Informações do sistema:"
  echo "═══════════════════════════════════════════════════════════════════════" | lolcat
  echo "🕒 Data e hora"
  uptime
  echo "═══════════════════════════════════════════════════════════════════════" | lolcat
  echo "📁 Uso de memória"
  free -h
  echo "═══════════════════════════════════════════════════════════════════════" | lolcat
  echo "💿 Espaço livre no disco"
  df -h
  echo "═══════════════════════════════════════════════════════════════════════" | lolcat
  echo "🔋 Bateria"
  termux-battery-status | cat -A
  echo " "
  read -p "Enter para voltar..."
}

atualizar_tudo() {
  echo "Atualizando pacotes..."
  pkg update && pkg upgrade -y
  read -p "Enter para voltar..."
}

limpar_cache() {
  echo "Limpando cache do Termux..."
  rm -rf /data/data/com.termux/cache/*
  echo "Cache limpo!"
  echo " "
  read -p "Enter para voltar..."
}

submenu_mais_funcoes() {
  echo ""
  echo "╔═════════════════════════════════════════════════════════════════════╗"
  echo "║                       -> 🔧 MAIS FUNÇÕES <-                         ║"
  echo "╠═════════════════════════════════════════════════════════════════════╣"
  echo "║ [1] Ver uso da CPU                │ [2] Ver processo atual          ║"
  echo "║ [3] Abrir calculadora             │ [4] Ver ip                      ║"
  echo "║ [5] Informações do Kernel         │ [6] Variáveis do ambiente       ║"
  echo "║ [7] Usuários que conectam         │ [8] Portas em uso               ║"
  echo "╠═════════════════════════════════════════════════════════════════════╣"
  echo "║ [0] Voltar                                                          ║"
  echo "╠═════════════════════════════════════════════════════════════════════╝"
  read -rp $'\e[1;32m└──>> \e[0m' opt
  case $opt in
    1) top -n 1; read -p "Enter para voltar..." ;;
    2)
       echo ""
       echo "╔═════════════════════════════════════════════════════════════════════╗
║                    🔍 Processos Atuais no Sistema                   ║
╚═════════════════════════════════════════════════════════════════════╝" | lolcat
             ps -aux | head -n 25 | lolcat
       echo "═══════════════════════════════════════════════════════════════════════" | lolcat
       read -p $'\e[1;37mEnter para voltar...\e[0m' ;;

    3) bash -c "read -p 'Conta: ' conta; echo \$((conta)); read -p 'Enter para voltar...'" ;;
    4)
       echo "🔹 IP Local:"
       termux-wifi-connectioninfo | grep ip | awk -F'"' '{print $4}'
       echo "═══════════════════════════════════════════════════════════════════════" | lolcat
       echo "🔸 IP Público:"
       curl ifconfig.me
       echo " "
       echo " "
       read -p "Enter para voltar..." ;;
    5)
       uname -a
       echo " "
       read -p "Enter para voltar..." ;;
    6)
       env | grep -E 'USER|HOME|SHELL|TERM|LANG|PATH|PWD' | lolcat
       echo " "
       read -p "Enter para voltar..." ;;
    7)
       cut -d: -f1 /etc/passwd
       echo " "
       read -p "Enter para voltar..." ;;
    8)
       netstat -tuln
       echo " "
       read -p "Enter para voltar..." ;;
    0) return ;;
    *) echo "Opção inválida"; sleep 1 ;;
  esac
}

ferramentas() {
  echo " "
  read -p "Enter para voltar..." 
}

# === Menu Principal ===

while true; do
  echo ""
  echo "╔═════════════════════════════════════════════════════════════════════╗"
  echo "║                              >> MENU <<                             ║"
  echo "╠═════════════════════════════════════════════════════════════════════╣"
  echo "║ [1] Instalar Aplicações          │ [2] Ver Atalhos                  ║"
  echo "║ [3] Pacotes Instalados           │ [4] Gitpush                      ║"
  echo "║ [5] Informações do Sitema        │ [6] Atualizar Tudo               ║"
  echo "║ [7] Limpar Cache                 │ [8] Kali Linux                   ║"
  echo "║ [9] Ubuntu                       │ [10] Mais Funções                ║"
  echo "║ [11] Ferramentas                 │                                  ║"
  echo "╠═════════════════════════════════════════════════════════════════════╣"
  echo "║ [0] Sair do Menu                                                    ║"
  echo "╠═════════════════════════════════════════════════════════════════════╝"
  read -rp $'\e[1;31m└──>> \e[0m' opcao
  case $opcao in
    1) instalar_aplicacoes ;;
    2) ver_atalhos ;;
    3) pacotes_instalados ;;
    4)
       bash ~/gitpush.sh
       break ;;
    5) info_sistema ;;
    6) atualizar_tudo ;;
    7) limpar_cache ;;
    8) bash ~/kali.sh ;;
    9) bash ~/ubuntu.sh ;;
    10) submenu_mais_funcoes ;;
    11) ferramentas ;;
    0)
      echo "Saindo do menu..."
      break ;;
    *)
      echo "⚠️ Opção inválida! Tente novamente."
      clear
      sleep 1 ;;
  esac
  clear
done
