# Estilos
BOLD='\e[1m'
RESET='\e[0m'

# Cores RGB
ROXO='\e[38;2;128;0;128m'
VERDE='\e[38;2;0;255;100m'
AMARELO='\e[38;2;255;215;0m'
VERMELHO='\e[38;2;220;20;60m'
CIANO='\e[38;2;0;255;255m'
BRANCO='\e[97m'

# Caminho onde será salvo o último diretório digitado
LAST_DIR_FILE="$HOME/.gitpush_dir"

# Verifica se já existe um diretório salvo
if [ -f "$LAST_DIR_FILE" ]; then
  dir=$(cat "$LAST_DIR_FILE")
else
  read -rp "Digite o caminho do projeto (primeira vez): " dir
  echo "$dir" > "$LAST_DIR_FILE"
fi

# Tenta acessar o diretório
cd "$dir" || { echo -e "${VERMELHO}❌ Não foi possível acessar:{$RESET} $dir"; exit 1; }

# === MENU PRINCIPAL ===
echo -e "$(cat <<EOF
${BOLD}${ROXO}═══════════════════════════════════════════════════════════════════════
${BOLD}${CIANO}📂 Diretório atual: $dir
🔗 Repositório remoto atual: $(git remote get-url origin 2>/dev/null || echo 'Nenhum remoto configurado')
👤 Usuário git global: $(git config --global user.name || echo 'Não configurado')
📧 Email git global: $(git config --global user.email || echo 'Não configurado')
${BOLD}${ROXO}╔═════════════════════════════════════════════════════════════════════╗
║                           ${BRANCO}-> GIT PUSH <-${ROXO}                            ║
╠═════════════════════════════════════════════════════════════════════╣
║ ${BRANCO}[1] Só fazer push no repositório atual                              ${ROXO}║
${ROXO}║ ${BRANCO}[2] Mudar URL do repositório atual                                  ${ROXO}║
${ROXO}║ ${BRANCO}[3] Mudar usuário git (nome e email globais)                        ${ROXO}║
${ROXO}║ ${BRANCO}[4] Fazer commit e push (padrão)                                    ${ROXO}║
${ROXO}║ ${BRANCO}[5] Mudar diretório do projeto                                      ${ROXO}║
╠═════════════════════════════════════════════════════════════════════╝${RESET}
EOF
)"
  read -rp $'\e[1;38;2;128;0;128m└──>> \e[0m' opcao
# === OPÇÕES DO MENU ===
case $opcao in
  1)
    if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
      echo -e "${AMARELO}⚠️ Nenhum commit encontrado. Criando commit inicial...${RESET}"
      touch README.md
      git add .
      git commit -m "Initial commit"
    fi

    # Pega a branch atual
    branch=$(git branch --show-current)

    echo -e "${CIANO}Fazendo push na branch '${ROXO}$branch${CIANO}'...${RESET}"
    git push -u origin "$branch"
    exit 0
    ;;
  2)
    if [ ! -d ".git" ]; then
      echo -e "${VERDE}❌ Esse diretório não é um repositório Git.${RESET}"
      read -rp "Deseja inicializar com 'git init'? (s/n): " resp
      if [[ "$resp" =~ ^[sS]$ ]]; then
        git init
        echo -e "${VERDE}✅ Repositório Git inicializado.${RESET}"
      else
        echo -e "${VERMELHO}❌ Operação cancelada.${RESET}"
        exit 1
      fi
    fi

    read -rp "Digite a nova URL do repositório remoto: " nova_url
    if git remote | grep -q origin; then
      git remote set-url origin "$nova_url"
      echo -e "${CIANO}🔄 URL do remoto 'origin' atualizado.${RESET}"
    else
      git remote add origin "$nova_url"
      echo -e "${VERDE}✅ Remoto 'origin' adicionado.${RESET}"
    fi
    exit 0
    ;;
  3)
    read -rp "Novo nome de usuário global: " novo_nome
    read -rp "Novo e-mail global: " novo_email
    git config --global user.name "$novo_nome"
    git config --global user.email "$novo_email"
    echo "Usuário git global atualizado."
    exit 0
    ;;
  4)
    if ! git config --global user.name > /dev/null; then
      read -rp "Digite seu nome para git config global: " nome
      git config --global user.name "$nome"
    fi
    if ! git config --global user.email > /dev/null; then
      read -rp "Digite seu email para git config global: " email
      git config --global user.email "$email"
    fi

    if ! git remote | grep -q origin; then
      read -rp "🔗 Digite a URL do repositório remoto: " repo_url
      git remote add origin "$repo_url"
    fi

   echo "Escolha o tipo de commit:"
   echo "1) Feat      – Nova funcionalidade"
   echo "2) Fix       – Correção de bug"
   echo "3) Update    – Atualizações ou ajustes menores"
   echo "4) Refactor  – Reestruturação do código sem mudar funcionalidade"
   echo "5) Style     – Alterações visuais ou de formatação"
   echo "6) Remove    – Remoção de arquivos, funções ou elementos"
   echo "7) Add       – Adição de arquivos ou recursos básicos"
   echo "8) Docs      – Documentação ou comentários"
   echo "9) Chore     – Tarefas auxiliares, manutenção ou configurações"
    read -rp "Tipo: " tipo_num

    case $tipo_num in
      1) tipo="Feat" ;;
      2) tipo="Fix" ;;
      3) tipo="Update" ;;
      4) tipo="Refactor" ;;
      5) tipo="Style" ;;
      6) tipo="Remove" ;;
      7) tipo="Add" ;;
      8) tipo="Docs" ;;
      9) tipo="Chore" ;;
      *) echo "Tipo inválido"; exit 1 ;;
    esac

    read -rp "Área afetada (ex: Jogador, Menu): " area
    read -rp "Descrição do commit: " descricao

    msg="[$tipo] $area: $descricao"

    git add .
    git commit -m "$msg"

    branch=$(git branch --show-current)
    git push -u origin "$branch"
    ;;
  5)
    read -rp "Digite o novo diretório do projeto: " novo_dir
    cd "$novo_dir" || { echo -e "${VERMELHO}❌ Diretório inválido.${RESET}"; exit 1; }
    echo "$novo_dir" > "$LAST_DIR_FILE"
    echo -e "${VERDE}✅ Diretório atualizado e salvo.${RESET}"
    ;;
  *)
    echo -e "${VERMELHO}❌ Opção inválida.${RESET}"
    exit 1
    ;;
esac
