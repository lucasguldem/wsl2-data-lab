<div align="center">

```
██████╗  █████╗ ████████╗ █████╗     ██╗      █████╗ ██████╗
██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗    ██║     ██╔══██╗██╔══██╗
██║  ██║███████║   ██║   ███████║    ██║     ███████║██████╔╝
██║  ██║██╔══██║   ██║   ██╔══██║    ██║     ██╔══██║██╔══██╗
██████╔╝██║  ██║   ██║   ██║  ██║    ███████╗██║  ██║██████╔╝
╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝    ╚══════╝╚═╝  ╚═╝╚═════╝
```

# 🐧 WSL2 Data Lab — Setup Completo para Analistas de Dados

**Ambiente profissional de análise de dados no Windows via WSL2, instalado com um único script.**

[![Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?style=flat-square&logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Python](https://img.shields.io/badge/Python-3.12-3776AB?style=flat-square&logo=python&logoColor=white)](https://www.python.org/)
[![Docker](https://img.shields.io/badge/Docker-Engine-2496ED?style=flat-square&logo=docker&logoColor=white)](https://www.docker.com/)
[![JupyterLab](https://img.shields.io/badge/JupyterLab-4.x-F37626?style=flat-square&logo=jupyter&logoColor=white)](https://jupyterlab.readthedocs.io/)
[![dbt](https://img.shields.io/badge/dbt-core-FF694B?style=flat-square&logo=dbt&logoColor=white)](https://www.getdbt.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-4169E1?style=flat-square&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

</div>

---

## 📋 Índice

- [O que é este projeto?](#-o-que-é-este-projeto)
- [Pré-requisitos](#-pré-requisitos)
- [Instalando o WSL2](#-instalando-o-wsl2)
  - [Windows 10/11 Pro ou Enterprise](#windows-1011-pro-ou-enterprise)
  - [Windows 11 Home](#windows-11-home)
- [Executando o Script](#-executando-o-script)
- [O que é instalado](#-o-que-é-instalado)
  - [Módulo 01 — Sistema Base](#módulo-01--sistema-base)
  - [Módulo 02 — Shell (Zsh + Oh-My-Zsh + Powerlevel10k)](#módulo-02--shell-zsh--oh-my-zsh--powerlevel10k)
  - [Módulo 03 — Python 3.12 via pyenv](#módulo-03--python-312-via-pyenv)
  - [Módulo 04 — Pacotes Python para Dados](#módulo-04--pacotes-python-para-dados)
  - [Módulo 05 — Node.js via nvm](#módulo-05--nodejs-via-nvm)
  - [Módulo 06 — Rust + Ferramentas CLI Modernas](#módulo-06--rust--ferramentas-cli-modernas)
  - [Módulo 07 — Docker Engine](#módulo-07--docker-engine)
  - [Módulo 08 — Bancos de Dados](#módulo-08--bancos-de-dados)
  - [Módulo 09 — Produtividade CLI](#módulo-09--produtividade-cli)
  - [Módulo 10 — JupyterLab](#módulo-10--jupyterlab)
  - [Módulo 11 — Estrutura de Pastas](#módulo-11--estrutura-de-pastas)
  - [Módulo 12 — Configuração WSL2](#módulo-12--configuração-wsl2)
  - [Módulo 13 — Extensões VS Code](#módulo-13--extensões-vs-code)
- [Aliases e Funções Úteis](#-aliases-e-funções-úteis)
- [Configuração VS Code](#-configuração-vs-code)
- [Estrutura do Repositório](#-estrutura-do-repositório)
- [Checklist Pós-Instalação](#-checklist-pós-instalação)
- [Solução de Problemas](#-solução-de-problemas)
- [Contribuindo](#-contribuindo)

---

## 🎯 O que é este projeto?

Este repositório contém um script de automação (`setup_wsl2_analista.sh`) que transforma um WSL2 recém-instalado em um **ambiente completo e profissional de análise de dados** — com todas as ferramentas que analistas, engenheiros de dados e cientistas de dados usam no dia a dia.

### Por que usar?

- ✅ **Uma linha de comando** instala tudo — sem precisar seguir dezenas de tutoriais
- ✅ **Idempotente** — pode ser executado novamente sem quebrar o que já foi instalado
- ✅ **Modular** — comente as seções que não precisar no `main()`
- ✅ **Produção-ready** — as mesmas ferramentas usadas por times de dados em grandes empresas
- ✅ **Documentado** — cada módulo explica o que faz e por quê

> **⏱ Tempo estimado:** 30 a 60 minutos dependendo da velocidade da internet.

---

## 💻 Pré-requisitos

| Requisito | Versão mínima | Notas |
|-----------|--------------|-------|
| Windows | 10 (build 19041) ou 11 | Qualquer edição |
| RAM | 8 GB | 16 GB recomendado |
| Disco livre | 20 GB | Para WSL2 + ferramentas |
| Conexão | Internet estável | Para baixar pacotes |
| VS Code | Qualquer versão recente | Recomendado, não obrigatório |

---

## 🪟 Instalando o WSL2

### Windows 10/11 Pro ou Enterprise

1. Abra o **PowerShell como Administrador** (clique com o botão direito no menu Iniciar → "Terminal do Windows (Admin)")

2. Execute o comando:
   ```powershell
   wsl --install -d Ubuntu-24.04
   ```

3. **Reinicie o computador** quando solicitado.

4. Após reiniciar, o Ubuntu abrirá automaticamente e pedirá para criar um **usuário e senha** (a senha não aparece na tela — isso é normal!).

### Windows 11 Home

O Windows 11 Home pode exigir instalação manual do WSL2:

1. Acesse: [https://github.com/microsoft/WSL/releases](https://github.com/microsoft/WSL/releases)
2. Baixe o arquivo `.msi` mais recente
3. Execute o instalador
4. Abra o PowerShell como Administrador e execute:
   ```powershell
   wsl --install
   ```
5. Reinicie o computador.

> 💡 **Dica:** Anote sua senha do Linux em algum lugar seguro. Ela é necessária para instalar programas com `sudo`.

---

## 🚀 Executando o Script

Com o WSL2 instalado e o Ubuntu aberto, execute os seguintes comandos:

```bash
# 1. Baixe o script
wget -O setup.sh https://raw.githubusercontent.com/seu-usuario/wsl2-data-lab/main/setup_wsl2_analista.sh

# 2. Dê permissão de execução
chmod +x setup.sh

# 3. Execute
./setup.sh
```

Quando perguntar `Deseja continuar? [s/N]`, digite **`s`** e pressione Enter.

> **Não feche o terminal** durante a instalação. O script exibirá o progresso de cada etapa.

---

## 📦 O que é instalado

### Módulo 01 — Sistema Base

Atualiza o Ubuntu e instala as ferramentas essenciais de compilação e utilitários:

```
build-essential  curl  wget  git  unzip  zip  tar
ca-certificates  gnupg  lsb-release  jq  tree
htop  ncdu  tmux  libssl-dev  libffi-dev  libpq-dev
```

---

### Módulo 02 — Shell (Zsh + Oh-My-Zsh + Powerlevel10k)

Substitui o shell padrão (`bash`) por uma experiência moderna e produtiva:

| Componente | O que faz |
|-----------|-----------|
| **Zsh** | Shell com recursos avançados de autocompletar |
| **Oh-My-Zsh** | Framework de configuração do Zsh |
| **Powerlevel10k** | Tema visual que mostra git status, Python version, tempo de execução e mais |
| **zsh-autosuggestions** | Sugere comandos enquanto você digita (baseado no histórico) |
| **zsh-syntax-highlighting** | Colore comandos em tempo real (verde = válido, vermelho = inválido) |
| **zsh-completions** | Completar avançado com Tab |

O arquivo `~/.zshrc` é configurado automaticamente com todos os plugins e aliases.

---

### Módulo 03 — Python 3.12 via pyenv

Instala o **pyenv** para gerenciar múltiplas versões do Python sem conflitos, e define o Python **3.12.3** como padrão global.

```bash
# Verificar versão instalada
python --version   # Python 3.12.3

# Listar versões disponíveis
pyenv versions

# Instalar outra versão (opcional)
pyenv install 3.11.9
pyenv global 3.11.9
```

---

### Módulo 04 — Pacotes Python para Dados

Instala mais de 30 bibliotecas organizadas por categoria:

#### 🔢 Núcleo de Dados
| Pacote | Uso |
|--------|-----|
| `numpy` | Arrays multidimensionais e matemática vetorizada |
| `pandas` | Manipulação e análise de DataFrames |
| `polars` | Alternativa ao Pandas, mais rápida para grandes volumes |
| `pyarrow` | Formato columnar para dados (base do Parquet) |

#### 📊 Visualização
| Pacote | Uso |
|--------|-----|
| `matplotlib` | Gráficos estáticos fundamentais |
| `seaborn` | Gráficos estatísticos sobre Matplotlib |
| `plotly` | Gráficos interativos para dashboards |
| `altair` | Visualizações declarativas baseadas em Vega-Lite |
| `bokeh` | Gráficos interativos para web |

#### 🤖 Machine Learning
| Pacote | Uso |
|--------|-----|
| `scikit-learn` | Algoritmos clássicos de ML (RF, SVM, KNN, etc.) |
| `xgboost` | Gradient boosting de alto desempenho |
| `lightgbm` | Gradient boosting mais rápido (Microsoft) |
| `torch` + `torchvision` | Deep Learning (PyTorch, CPU) |

#### 📐 Estatística
| Pacote | Uso |
|--------|-----|
| `scipy` | Funções científicas e estatísticas |
| `statsmodels` | Modelos estatísticos e testes de hipótese |

#### 🗄️ SQL e Bancos de Dados
| Pacote | Uso |
|--------|-----|
| `sqlalchemy` | ORM e conexão com bancos |
| `psycopg2-binary` | Driver PostgreSQL |
| `pymysql` | Driver MySQL/MariaDB |
| `duckdb` | Banco analítico in-process |

#### ☁️ Big Data e Cloud
| Pacote | Uso |
|--------|-----|
| `pyspark` | Apache Spark via Python |
| `boto3` | AWS SDK (S3, Redshift, etc.) |
| `google-cloud-bigquery` | Google BigQuery |

#### 🔄 ELT e Orquestração
| Pacote | Uso |
|--------|-----|
| `dbt-core` | Transformações SQL declarativas |
| `dbt-postgres` | Adaptador dbt para PostgreSQL |
| `dbt-bigquery` | Adaptador dbt para BigQuery |
| `prefect` | Orquestração moderna de pipelines |
| `apache-airflow` | Orquestração de workflows (DAGs) |

#### ✅ Qualidade de Dados
| Pacote | Uso |
|--------|-----|
| `great-expectations` | Validação e documentação de dados |
| `pandera` | Validação de schemas de DataFrames |

#### 🌐 APIs e Web
| Pacote | Uso |
|--------|-----|
| `requests` | Requisições HTTP simples |
| `httpx` | Cliente HTTP assíncrono |
| `fastapi` | Framework de APIs moderno |
| `uvicorn` | Servidor ASGI para FastAPI |

#### 🛠️ Utilitários
`python-dotenv` · `pydantic` · `rich` · `typer` · `tqdm` · `openpyxl` · `loguru` · `black` · `ruff` · `mypy` · `pytest`

---

### Módulo 05 — Node.js via nvm

Instala o **nvm** (Node Version Manager) e o Node.js LTS, além de pacotes globais úteis:

```
yarn  ·  pnpm  ·  ts-node  ·  typescript  ·  prettier  ·  eslint  ·  http-server
```

---

### Módulo 06 — Rust + Ferramentas CLI Modernas

Instala o **Rust** e uma coleção de ferramentas que substituem os comandos Unix clássicos com versões mais rápidas e visuais:

| Novo | Substitui | O que melhora |
|------|-----------|--------------|
| `lsd` | `ls` | Listagem com ícones coloridos e árvore de diretórios |
| `bat` | `cat` | Leitura de arquivos com syntax highlighting e número de linha |
| `ripgrep` (`rg`) | `grep` | Busca de texto até 10x mais rápida |
| `fd` | `find` | Busca de arquivos com sintaxe intuitiva |
| `bottom` (`btm`) | `top` / `htop` | Monitor de sistema visual e interativo |
| `dust` | `du` | Visualização de uso de disco em árvore |
| `delta` | `diff` | Diffs do git coloridos e com lado a lado |
| `tokei` | `cloc` | Contagem de linhas de código por linguagem |
| `hyperfine` | `time` | Benchmarking de comandos com estatísticas |

---

### Módulo 07 — Docker Engine

Instala o **Docker CE** e o **Docker Compose Plugin** pelo repositório oficial da Docker:

```bash
# Testar instalação
docker run hello-world

# Exemplos úteis para dados
docker run -e POSTGRES_PASSWORD=senha -p 5432:5432 -d postgres
docker run -p 6379:6379 -d redis
```

> ⚠️ O usuário é adicionado ao grupo `docker` automaticamente. Reinicie o terminal para usar `docker` sem `sudo`.

---

### Módulo 08 — Bancos de Dados

Instala e configura quatro bancos de dados localmente:

| Banco | Porta padrão | Uso principal |
|-------|-------------|---------------|
| **PostgreSQL 16** | 5432 | Banco relacional robusto, padrão de mercado |
| **Redis** | 6379 | Cache em memória, filas, pub/sub |
| **DuckDB CLI** | — | Análise analítica em arquivos CSV/Parquet |
| **SQLite3** | — | Banco leve em arquivo, ideal para projetos locais |

```bash
# Conectar ao PostgreSQL
psql -U postgres

# Conectar ao Redis
redis-cli

# Abrir DuckDB
duckdb meu_banco.db

# Analisar CSV direto com SQL
duckdb :memory: "SELECT * FROM read_csv_auto('dados.csv') LIMIT 10"
```

---

### Módulo 09 — Produtividade CLI

| Ferramenta | O que é | Como usar |
|-----------|---------|----------|
| **fzf** | Fuzzy finder interativo | `Ctrl+R` (histórico), `Ctrl+T` (arquivos) |
| **tmux** | Multiplexador de terminal | `tmux new -s trabalho` |
| **delta** | Diff bonito para git | Configurado automaticamente no `.gitconfig` |

Configurações globais do git aplicadas:
```
init.defaultBranch = main
core.autocrlf = input
core.pager = delta
delta.side-by-side = true
```

---

### Módulo 10 — JupyterLab

Instala e configura o JupyterLab com extensões para um fluxo de trabalho completo:

| Extensão | Função |
|---------|--------|
| `jupyterlab-lsp` | Autocompletar inteligente (Language Server Protocol) |
| `python-lsp-server` | Backend LSP para Python |
| `jupyterlab_code_formatter` | Formata código com Black e isort ao salvar |
| `jupyterlab-git` | Interface visual para git dentro do Jupyter |
| `jupyterlab-drawio` | Criação de diagramas inline |

```bash
# Iniciar JupyterLab (use o alias)
jlab

# Ou especificando o diretório
jlab ~/data-projects
```

---

### Módulo 11 — Estrutura de Pastas

Cria a estrutura padrão de projetos de dados em `~/data-projects/`:

```
~/data-projects/
├── notebooks/          # Análises exploratórias (.ipynb)
├── data/
│   ├── raw/            # Dados brutos (não versionar!)
│   ├── processed/      # Dados tratados e limpos
│   └── external/       # Dados de fontes externas
├── scripts/            # Scripts ETL e automações (.py)
├── reports/            # Outputs finais (PDF, HTML, imagens)
├── dashboards/         # Apps Streamlit/Dash
├── models/             # Artefatos de ML treinados (.pkl, .pt)
└── template_projeto.ipynb   # Notebook base para novos projetos
```

Um `.gitignore` global é configurado automaticamente para ignorar arquivos de dados, ambientes virtuais e checkpoints do Jupyter.

---

### Módulo 12 — Configuração WSL2

Configura o arquivo `/etc/wsl.conf` para otimizar o comportamento do WSL2:

```ini
[boot]
systemd = true        # Habilita systemd (serviços automáticos)

[network]
hostname = data-lab   # Nome do host da máquina Linux

[automount]
options = "metadata,umask=22,fmask=11"
```

**⚠️ Importante:** Crie também o arquivo `.wslconfig` no Windows para limitar o uso de recursos:

```ini
# Salve em: C:\Users\<SeuUsuário>\.wslconfig
[wsl2]
memory=8GB
processors=4
swap=4GB
localhostForwarding=true
```

> Ajuste os valores de `memory` e `processors` conforme sua máquina.

---

### Módulo 13 — Extensões VS Code

Gera o script `~/vscode_extensions_data.sh` com mais de 20 extensões para instalar no VS Code:

```bash
# Executar para instalar todas as extensões
bash ~/vscode_extensions_data.sh
```

| Extensão | Função |
|---------|--------|
| `ms-python.python` | Suporte completo ao Python |
| `ms-toolsai.jupyter` | Notebooks Jupyter no VS Code |
| `ms-vscode-remote.remote-wsl` | Conectar VS Code ao Linux |
| `ms-azuretools.vscode-docker` | Gerenciar containers Docker |
| `eamodio.gitlens` | Super poderes para Git |
| `innoverio.vscode-dbt-power-user` | Interface para projetos dbt |
| `mechatroner.rainbow-csv` | Visualizar CSV com colunas coloridas |
| `charliermarsh.ruff` | Linter Python ultrarrápido |
| `GitHub.copilot` | IA para autocompletar código |

---

## ⚡ Aliases e Funções Úteis

O `.zshrc` é configurado com aliases prontos para o dia a dia:

### Python / Dados
```bash
py          # python3
pip         # pip3
jn          # jupyter notebook
jl          # jupyter lab
act         # source .venv/bin/activate
venv        # Cria e ativa .venv no diretório atual
```

### Git
```bash
gs          # git status
ga          # git add .
gc "msg"    # git commit -m "msg"
gp          # git push
gl          # git log --oneline --graph --decorate
```

### Docker
```bash
dps         # docker ps
dimg        # docker images
dprune      # docker system prune -f
```

### dbt
```bash
dbt-run     # dbt run
dbt-test    # dbt test
```

### Funções
```bash
mkcd nome/  # Cria e entra na pasta
csvhead arq # Mostra os nomes das colunas de um CSV
```

---

## 🎨 Configuração VS Code

O arquivo `settings.json` inclui configurações otimizadas para desenvolvimento com Python e dados:

- **Fonte:** JetBrains Mono Nerd Font com ligaduras ativadas
- **Terminal:** Zsh como shell padrão integrado
- **Tema:** OM Theme (Dracula Italic) + Material Icon Theme
- **Formatação:** automática ao salvar, colar e digitar
- **Git:** auto-fetch ativado
- **Associações de arquivo:** Python, Jupyter, Java, Maven

Para usar o `settings.json`, copie-o para:
```
# Windows (via VS Code Remote WSL)
%APPDATA%\Code\User\settings.json

# Linux (dentro do WSL2)
~/.config/Code/User/settings.json
```

> **Nota:** A fonte JetBrains Mono Nerd Font precisa ser instalada separadamente no Windows. Baixe em [nerdfonts.com](https://www.nerdfonts.com/font-downloads).

---

## 📁 Estrutura do Repositório

```
wsl2-data-lab/
├── setup_wsl2_analista.sh      # Script principal de instalação
├── settings.json               # Configurações do VS Code
├── wsl2_data_lab_guide.html    # Guia visual interativo (abrir no navegador)
├── docs/
│   └── WSL2_DataAnalyst_Iniciantes.pdf   # Apresentação completa para iniciantes
└── README.md
```

---

## ✅ Checklist Pós-Instalação

Após o script terminar, execute estes passos:

- [ ] **Reiniciar o terminal**
  ```bash
  exec zsh
  ```

- [ ] **Configurar nome e email do Git**
  ```bash
  git config --global user.name "Seu Nome"
  git config --global user.email "seu@email.com"
  ```

- [ ] **Criar o `.wslconfig` no Windows** (veja [Módulo 12](#módulo-12--configuração-wsl2))

- [ ] **Testar o JupyterLab**
  ```bash
  jl
  # Acesse http://localhost:8888 no navegador
  ```

- [ ] **Instalar extensões do VS Code**
  ```bash
  bash ~/vscode_extensions_data.sh
  ```

- [ ] **Testar o Docker**
  ```bash
  docker run hello-world
  ```

- [ ] **Testar o DuckDB**
  ```bash
  duckdb :memory: "SELECT 42 AS resposta"
  ```

- [ ] **Criar seu primeiro projeto**
  ```bash
  cd ~/data-projects
  mkdir meu-projeto && cd meu-projeto
  venv          # Cria .venv e ativa
  cp ../template_projeto.ipynb .
  jl            # Abre JupyterLab
  ```

---

## 🔧 Solução de Problemas

### Shell não mudou para Zsh após a instalação
```bash
chsh -s $(which zsh)
# Feche e reabra o terminal
```

### Docker: "permission denied"
```bash
# O usuário ainda não está no grupo docker na sessão atual
newgrp docker
# Ou feche e reabra o terminal
```

### pyenv: comando não encontrado
```bash
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
# Adicione essas linhas ao ~/.zshrc se não estiverem lá
```

### JupyterLab: "porta já em uso"
```bash
jupyter lab --port 8889
```

### PostgreSQL não inicia
```bash
# Com systemd habilitado (wsl.conf correto):
sudo systemctl start postgresql

# Sem systemd:
sudo service postgresql start
```

### WSL2 consumindo muita memória
Crie ou edite `C:\Users\<SeuUsuário>\.wslconfig`:
```ini
[wsl2]
memory=8GB
swap=4GB
```
Reinicie o WSL2: `wsl --shutdown` no PowerShell, depois reabra o Ubuntu.

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Para contribuir:

1. Faça um **fork** do repositório
2. Crie uma branch para sua feature:
   ```bash
   git checkout -b feat/nova-ferramenta
   ```
3. Faça suas alterações e commit:
   ```bash
   git commit -m "feat: adiciona suporte ao Polars 1.x"
   ```
4. Abra um **Pull Request** descrevendo o que foi alterado

### O que pode ser melhorado
- Suporte a outras distros Linux (Fedora, Arch)
- Módulo opcional para GPU (CUDA no WSL2)
- Configuração automática de chaves SSH para GitHub/GitLab
- Integração com Databricks CLI e Azure CLI

---

<div align="center">

**Feito com 🐧 para analistas de dados que usam Windows**

Se este projeto te ajudou, deixe uma ⭐ no repositório!

</div>