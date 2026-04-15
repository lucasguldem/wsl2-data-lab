#!/usr/bin/env bash
# =============================================================================
# WSL2 Setup Completo para Analista de Dados
# Autor: Claude | Data: 2026
# =============================================================================

set -euo pipefail

# ── Cores ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

# ── Helpers ───────────────────────────────────────────────────────────────────
info()    { echo -e "${CYAN}[INFO]${NC}  $*"; }
ok()      { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
step()    { echo -e "\n${BOLD}${BLUE}━━━ $* ━━━${NC}"; }
banner()  {
  echo -e "${BOLD}${CYAN}"
  cat <<'EOF'
  ██████╗  █████╗ ████████╗ █████╗     ██╗      █████╗ ██████╗
  ██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗    ██║     ██╔══██╗██╔══██╗
  ██║  ██║███████║   ██║   ███████║    ██║     ███████║██████╔╝
  ██║  ██║██╔══██║   ██║   ██╔══██║    ██║     ██╔══██║██╔══██╗
  ██████╔╝██║  ██║   ██║   ██║  ██║    ███████╗██║  ██║██████╔╝
  ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝    ╚══════╝╚═╝  ╚═╝╚═════╝
  WSL2 Setup Completo — Analista de Dados 2026
EOF
  echo -e "${NC}"
}

confirm() {
  read -rp "$(echo -e "${YELLOW}$1 [s/N]: ${NC}")" ans
  [[ "${ans,,}" == "s" ]]
}

# ── Verificação do ambiente ───────────────────────────────────────────────────
check_wsl() {
  if ! grep -qi microsoft /proc/version 2>/dev/null; then
    warn "Este script foi projetado para WSL2. Continuando mesmo assim..."
  else
    ok "WSL2 detectado."
  fi
}

# =============================================================================
# 1. SISTEMA BASE
# =============================================================================
setup_system() {
  step "1. Atualizando sistema base (Ubuntu/Debian)"
  sudo apt-get update -qq && sudo apt-get upgrade -y -qq
  sudo apt-get install -y -qq \
    build-essential curl wget git unzip zip tar \
    ca-certificates gnupg lsb-release software-properties-common \
    apt-transport-https jq tree htop ncdu tmux \
    libssl-dev libffi-dev libpq-dev libsqlite3-dev \
    fonts-powerline
  ok "Sistema base atualizado."
}

# =============================================================================
# 2. ZSH + OH-MY-ZSH + POWERLEVEL10K
# =============================================================================
setup_shell() {
  step "2. Shell: Zsh + Oh-My-Zsh + Powerlevel10k"

  sudo apt-get install -y -qq zsh

  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no sh -c \
      "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ok "Oh-My-Zsh instalado."
  else
    ok "Oh-My-Zsh já instalado."
  fi

  # Powerlevel10k
  local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  if [ ! -d "$p10k_dir" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
    ok "Powerlevel10k instalado."
  fi

  # Plugins
  local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  for plugin_repo in \
    "zsh-users/zsh-autosuggestions" \
    "zsh-users/zsh-syntax-highlighting" \
    "zsh-users/zsh-completions"; do
    plugin_name=$(basename "$plugin_repo")
    plugin_dir="$ZSH_CUSTOM/plugins/$plugin_name"
    [ -d "$plugin_dir" ] || git clone --depth=1 "https://github.com/${plugin_repo}.git" "$plugin_dir"
  done

  # .zshrc
  cat > "$HOME/.zshrc" <<'ZSHRC'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions docker kubectl python pip)
source $ZSH/oh-my-zsh.sh

# Powerlevel10k
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Paths
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)" 2>/dev/null || true

# Node (nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Aliases — Utilitários
alias ll='ls -lAh --color=auto'
alias la='ls -A --color=auto'
alias grep='grep --color=auto'
alias update='sudo apt update && sudo apt upgrade -y'
alias cls='clear'

# Aliases — Python / Data
alias py='python3'
alias pip='pip3'
alias jn='jupyter notebook'
alias jl='jupyter lab'
alias act='source .venv/bin/activate'

# Aliases — Git
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Aliases — Docker
alias dps='docker ps'
alias dimg='docker images'
alias dprune='docker system prune -f'

# dbt
alias dbt-run='dbt run'
alias dbt-test='dbt test'

# Funções úteis
mkcd() { mkdir -p "$1" && cd "$1"; }
venv() { python3 -m venv .venv && source .venv/bin/activate && pip install --upgrade pip; }
csvhead() { head -1 "$1" | tr ',' '\n' | nl; }
ZSHRC

  # Muda shell padrão para zsh
  sudo chsh -s "$(which zsh)" "$USER" 2>/dev/null || warn "Altere o shell padrão manualmente: chsh -s $(which zsh)"
  ok "Shell configurado. Execute: source ~/.zshrc"
}

# =============================================================================
# 3. PYTHON (pyenv + versões LTS)
# =============================================================================
setup_python() {
  step "3. Python via pyenv"

  # Dependências pyenv
  sudo apt-get install -y -qq \
    make libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

  if [ ! -d "$HOME/.pyenv" ]; then
    curl -fsSL https://pyenv.run | bash
    ok "pyenv instalado."
  else
    ok "pyenv já instalado."
  fi

  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"

  # Instala Python 3.12 (LTS recomendado para dados)
  local py_version="3.12.3"
  if ! pyenv versions | grep -q "$py_version"; then
    info "Instalando Python $py_version (pode demorar)..."
    pyenv install "$py_version"
    pyenv global "$py_version"
    ok "Python $py_version definido como global."
  else
    ok "Python $py_version já instalado."
  fi

  pip install --upgrade pip setuptools wheel
}

# =============================================================================
# 4. PACOTES PYTHON PARA DADOS
# =============================================================================
setup_python_packages() {
  step "4. Pacotes Python para Análise de Dados"

  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)" 2>/dev/null || true

  # 1. Instalar pacotes do PyPI padrão
  pip install --upgrade \
    numpy pandas polars pyarrow \
    matplotlib seaborn plotly altair bokeh \
    jupyterlab notebook ipywidgets ipykernel nbformat nbconvert \
    jupyterlab-git jupyter_contrib_nbextensions \
    scikit-learn xgboost lightgbm \
    scipy statsmodels \
    sqlalchemy psycopg2-binary pymysql duckdb \
    pyspark boto3 google-cloud-bigquery \
    dbt-core dbt-postgres dbt-bigquery \
    prefect apache-airflow \
    great-expectations pandera \
    requests httpx fastapi uvicorn \
    python-dotenv pydantic rich typer tqdm \
    openpyxl xlrd xlwt \
    loguru black ruff mypy pytest

  # 2. Instalar PyTorch CPU separadamente (índice específico)
  pip install --upgrade torch torchvision --index-url https://download.pytorch.org/whl/cpu

  ok "Pacotes Python instalados."
}

# =============================================================================
# 5. NODE.JS via NVM
# =============================================================================
setup_node() {
  step "5. Node.js via nvm"

  if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    ok "nvm instalado."
  else
    ok "nvm já instalado."
  fi

  # Carrega nvm
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  # Desativa 'set -u' temporariamente (nvm usa variáveis não definidas)
  set +u
  nvm install --lts
  nvm use --lts
  nvm alias default node
  set -u

  # Utilitários globais
  npm install -g \
    yarn pnpm \
    ts-node typescript \
    prettier eslint \
    http-server \
    @databricks/sql-driver 2>/dev/null || true

  ok "Node.js LTS instalado: $(node -v)"
}

# =============================================================================
# 6. RUST (para ferramentas de CLI modernas)
# =============================================================================
setup_rust() {
  step "6. Rust + ferramentas CLI modernas"

  if ! command -v rustup &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    ok "Rust instalado."
  else
    ok "Rust já instalado."
  fi

  source "$HOME/.cargo/env" 2>/dev/null || true

  # Ferramentas CLI modernas em Rust (instalar uma por vez para mostrar progresso)
  local rust_tools=(ripgrep fd-find bat lsd delta tokei hyperfine bottom du-dust)
  for tool in "${rust_tools[@]}"; do
    info "Instalando $tool (pode demorar na primeira vez)..."
    cargo install "$tool" 2>/dev/null || warn "$tool falhou (não crítico)"
  done

  ok "Ferramentas Rust instaladas: rg, fd, bat, lsd, delta, btm..."
}

# =============================================================================
# 7. DOCKER
# =============================================================================
setup_docker() {
  step "7. Docker Engine"

  if command -v docker &>/dev/null; then
    ok "Docker já instalado: $(docker --version)"
    return
  fi

  # Repositório oficial Docker
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update -qq
  sudo apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  sudo usermod -aG docker "$USER"
  ok "Docker instalado. Reinicie o terminal para usar sem sudo."
}

# =============================================================================
# 8. BANCOS DE DADOS
# =============================================================================
setup_databases() {
  step "8. Bancos de Dados (PostgreSQL, Redis, DuckDB CLI)"

  # PostgreSQL client + server
  sudo apt-get install -y -qq postgresql postgresql-client redis-server redis-tools

  # DuckDB CLI
  local duck_version="v0.10.2"
  if ! command -v duckdb &>/dev/null; then
    wget -qO /tmp/duckdb.zip \
      "https://github.com/duckdb/duckdb/releases/download/${duck_version}/duckdb_cli-linux-amd64.zip"
    sudo unzip -o /tmp/duckdb.zip -d /usr/local/bin/ && sudo chmod +x /usr/local/bin/duckdb
    rm /tmp/duckdb.zip
    ok "DuckDB CLI instalado."
  else
    ok "DuckDB já instalado."
  fi

  # SQLite3
  sudo apt-get install -y -qq sqlite3

  ok "Bancos de dados prontos."
}

# =============================================================================
# 9. FERRAMENTAS DE PRODUTIVIDADE CLI
# =============================================================================
setup_productivity() {
  step "9. Ferramentas de Produtividade"

  # fzf — fuzzy finder
  if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all
    ok "fzf instalado."
  fi

  # Starship (opcional, alternativa ao p10k)
  # curl -sS https://starship.rs/install.sh | sh

  # tmux config
  cat > "$HOME/.tmux.conf" <<'TMUX'
set -g default-terminal "screen-256color"
set -g history-limit 10000
set -g mouse on

# Atalhos intuitivos
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind r source-file ~/.tmux.conf \; display "Config recarregado!"

# Status bar
set -g status-style 'bg=#1e1e2e fg=#cdd6f4'
set -g status-left '#[bold]  #S '
set -g status-right '#[fg=#89b4fa] %d/%m %H:%M '
TMUX

  # git config global
  git config --global init.defaultBranch main
  git config --global core.editor "code --wait" 2>/dev/null || \
    git config --global core.editor "nano"
  git config --global pull.rebase false
  git config --global core.autocrlf input

  # delta (git diff bonito)
  git config --global core.pager delta 2>/dev/null || true
  git config --global delta.navigate true 2>/dev/null || true
  git config --global delta.side-by-side true 2>/dev/null || true

  ok "Ferramentas de produtividade configuradas."
}

# =============================================================================
# 10. JUPYTER LAB — Configuração
# =============================================================================
setup_jupyter() {
  step "10. Configurando JupyterLab"

  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)" 2>/dev/null || true

  # Cria config
  info "Gerando arquivo de configuração padrão..."
  jupyter lab --generate-config -y 2>/dev/null || true

  # Extensões úteis (instalar uma por vez para mostrar progresso)
  local jlab_extensions=(
    "jupyterlab-lsp"
    "python-lsp-server"
    "jupyterlab_code_formatter black isort"
    "jupyterlab-git"
    "jupyterlab-drawio"
    "theme-darcula"
  )

  for ext in "${jlab_extensions[@]}"; do
    info "Instalando extensão: $ext"
    pip install $ext 2>/dev/null || warn "⚠️  $ext falhou (não crítico)"
  done

  # Cria diretório para scripts locais
  mkdir -p "$HOME/.local/bin"

  # Script de atalho
  cat > "$HOME/.local/bin/jlab" <<'JLAB'
#!/bin/bash
cd "${1:-$HOME/data-projects}" && jupyter lab --no-browser
JLAB
  chmod +x "$HOME/.local/bin/jlab"

  ok "JupyterLab configurado. Use 'jlab' para iniciar."
}

# =============================================================================
# 11. ESTRUTURA DE PASTAS
# =============================================================================
setup_folders() {
  step "11. Estrutura de Pastas do Analista"

  local BASE="$HOME/data-projects"
  mkdir -p \
    "$BASE"/{notebooks,data/{raw,processed,external},scripts,reports,dashboards,models} \
    "$HOME"/{.config/dbt,tools}

  # .gitignore global
  cat > "$HOME/.gitignore_global" <<'GTIG'
# Python
__pycache__/
*.py[cod]
.venv/
*.egg-info/
dist/
.pytest_cache/

# Dados
*.csv
*.parquet
*.xlsx
*.json
!config.json
data/raw/
data/processed/

# Notebooks checkpoints
.ipynb_checkpoints/

# Env
.env
.env.*
!.env.example

# OS
.DS_Store
Thumbs.db

# IDEs
.vscode/
.idea/
*.swp
GTIG

  git config --global core.excludesfile "$HOME/.gitignore_global"

  # Template de projeto
  cat > "$BASE/template_projeto.ipynb" <<'NB'
{
 "cells": [
  {"cell_type": "markdown", "metadata": {}, "source": ["# 📊 Projeto de Análise\n\n**Objetivo:** ...\n\n**Data:** ...\n"]},
  {"cell_type": "code", "metadata": {}, "source": ["import numpy as np\nimport pandas as pd\nimport matplotlib.pyplot as plt\nimport seaborn as sns\n\npd.set_option('display.max_columns', None)\npd.set_option('display.float_format', '{:.2f}'.format)\nsns.set_theme(style='whitegrid')\n\nprint('Ambiente pronto! ✅')"], "outputs": [], "execution_count": null}
 ],
 "metadata": {
  "kernelspec": {"display_name": "Python 3", "language": "python", "name": "python3"},
  "language_info": {"name": "python", "version": "3.12.3"}
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
NB

  ok "Estrutura criada em $BASE"
}

# =============================================================================
# 12. CONFIGURAÇÃO DO WSL2 (/etc/wsl.conf)
# =============================================================================
setup_wsl_config() {
  step "12. Configuração WSL2 (wsl.conf)"

  sudo tee /etc/wsl.conf > /dev/null <<'WSLCONF'
[boot]
systemd=true

[network]
hostname=data-lab
generateResolvConf=true

[interop]
enabled=true
appendWindowsPath=false

[automount]
enabled=true
root=/mnt/
options="metadata,umask=22,fmask=11"
mountFsTab=true
WSLCONF

  # Limites de memória (crie no Windows: %USERPROFILE%\.wslconfig)
  local wslconfig_win="$HOME/.wslconfig_tip.txt"
  cat > "$wslconfig_win" <<'WC'
# Copie este conteúdo para: C:\Users\<SeuUsuário>\.wslconfig (no Windows)
# Ajuste os valores conforme sua RAM disponível.

[wsl2]
memory=8GB
processors=4
swap=4GB
localhostForwarding=true
WC

  warn "Crie o arquivo .wslconfig no Windows. Veja: ~/wslconfig_tip.txt"
  ok "wsl.conf configurado."
}

# =============================================================================
# 13. VS CODE EXTENSIONS (lista para instalar no Windows)
# =============================================================================
setup_vscode_list() {
  step "13. Lista de Extensões VS Code para Dados"

  cat > "$HOME/vscode_extensions_data.sh" <<'VSC'
#!/bin/bash
# Execute este script no PowerShell/CMD do Windows (com code no PATH)
# ou diretamente no WSL se VS Code estiver integrado.

extensions=(
  ms-python.python
  ms-python.vscode-pylance
  ms-toolsai.jupyter
  ms-toolsai.jupyter-keymap
  ms-azuretools.vscode-docker
  ms-vscode-remote.remote-wsl
  ms-vscode-remote.remote-containers
  redhat.vscode-yaml
  esbenp.prettier-vscode
  dbaeumer.vscode-eslint
  mtxr.sqltools
  innoverio.vscode-dbt-power-user
  mechatroner.rainbow-csv
  GrapeCity.gc-excelviewer
  ms-vscode.makefile-tools
  eamodio.gitlens
  mhutchie.git-graph
  christian-kohler.path-intellisense
  streetsidesoftware.code-spell-checker
  streetsidesoftware.code-spell-checker-portuguese-brazilian
  kevinrose.vsc-python-indent
  njpwerner.autodocstring
  oderwat.indent-rainbow
  PKief.material-icon-theme
  GitHub.copilot
  GitHub.copilot-chat
  charliermarsh.ruff
  tamasfe.even-better-toml
)

for ext in "${extensions[@]}"; do
  code --install-extension "$ext" --force
done

echo "✅ Extensões instaladas!"
VSC

  chmod +x "$HOME/vscode_extensions_data.sh"
  ok "Script de extensões salvo em ~/vscode_extensions_data.sh"
}

# =============================================================================
# SUMÁRIO FINAL
# =============================================================================
print_summary() {
  echo -e "\n${BOLD}${GREEN}"
  cat <<'EOF'
╔══════════════════════════════════════════════════════════════╗
║          ✅  SETUP COMPLETO! RESUMO DO QUE FOI INSTALADO     ║
╚══════════════════════════════════════════════════════════════╝
EOF
  echo -e "${NC}"

  echo -e "${CYAN}SHELL${NC}"
  echo "  • Zsh + Oh-My-Zsh + Powerlevel10k + plugins"
  echo -e "\n${CYAN}LINGUAGENS${NC}"
  echo "  • Python 3.12 (pyenv) | Node.js LTS (nvm) | Rust"
  echo -e "\n${CYAN}DADOS & ANÁLISE${NC}"
  echo "  • NumPy, Pandas, Polars, PyArrow, DuckDB"
  echo "  • Scikit-learn, XGBoost, LightGBM, PyTorch (CPU)"
  echo "  • Matplotlib, Seaborn, Plotly, Altair"
  echo "  • JupyterLab (com extensões LSP, Git, formatter)"
  echo -e "\n${CYAN}ENGENHARIA DE DADOS${NC}"
  echo "  • dbt-core, dbt-postgres, dbt-bigquery"
  echo "  • Prefect, Apache Airflow"
  echo "  • Great Expectations, Pandera"
  echo "  • PySpark, Boto3, Google BigQuery"
  echo -e "\n${CYAN}BANCOS DE DADOS${NC}"
  echo "  • PostgreSQL, Redis, SQLite3, DuckDB CLI"
  echo -e "\n${CYAN}INFRAESTRUTURA${NC}"
  echo "  • Docker + Docker Compose"
  echo "  • wsl.conf com systemd habilitado"
  echo -e "\n${CYAN}CLI & PRODUTIVIDADE${NC}"
  echo "  • fzf, ripgrep, bat, lsd, delta, bottom, fd, dust"
  echo "  • tmux (com config), git (com delta)"
  echo -e "\n${CYAN}ESTRUTURA DE PASTAS${NC}"
  echo "  • ~/data-projects/{notebooks,data,scripts,reports,models}"
  echo -e "\n${CYAN}PRÓXIMOS PASSOS${NC}"
  echo "  1. source ~/.zshrc   (ou reinicie o terminal)"
  echo "  2. Execute ~/vscode_extensions_data.sh (instalar extensões)"
  echo "  3. Copie o conteúdo de ~/wslconfig_tip.txt → Windows .wslconfig"
  echo "  4. jupyter lab  (acesse http://localhost:8888)"
  echo ""
}

# =============================================================================
# MAIN
# =============================================================================
main() {
  banner
  check_wsl

  echo -e "${BOLD}Este script irá instalar um ambiente completo de analista de dados.${NC}"
  echo -e "Tempo estimado: ${YELLOW}30–60 minutos${NC} dependendo da internet.\n"

  if ! confirm "Deseja continuar?"; then
    echo "Cancelado."; exit 0
  fi

  # Módulos — comente os que não quiser
  setup_system
  setup_shell
  setup_python
  setup_python_packages
  setup_node
  setup_rust
  setup_docker
  setup_databases
  setup_productivity
  setup_jupyter
  setup_folders
  setup_wsl_config
  setup_vscode_list

  print_summary
}

main "$@"
