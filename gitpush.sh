#Diretorio do gitpush
cd "/data/data/com.termux/files/home/storage/diretorio_exemplo"

# Configurações globais do Git (se ainda não tiver configurado)
git config --global user.name "Seu Nome"
git config --global user.email "seuemail@example.com"

# Verifica se o repositório tem remote origin
if ! git remote | grep -q origin; then
  read -p "🔗 Digite a URL do repositório remoto: " repo_url
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

read -p "Digite o número do tipo: " tipo_num

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

read -p "Área afetada (ex: Jogador, Menu, Sons): " area
read -p "Descrição do commit: " descricao

msg="[$tipo] $area: $descricao"

git add .
git commit -m "$msg"

branch=$(git branch --show-current)

git push -u origin "$branch"
