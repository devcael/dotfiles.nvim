#!/usr/bin/env bash
# =============================================================================
# Neovim Dotfiles - Setup Script
# Suporte: Debian / Ubuntu (e derivados) · Arch Linux (e derivados)
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Log file
# -----------------------------------------------------------------------------
LOG_FILE="/tmp/nvim-setup-$(date +%Y%m%d-%H%M%S).log"
# Garante que o log existe antes de qualquer redirecionamento
touch "$LOG_FILE"

log()  { echo "[$(date '+%H:%M:%S')] $*" >> "$LOG_FILE"; }
logv() { echo "$*" >> "$LOG_FILE"; }  # raw, sem timestamp

# Exibe as últimas N linhas do log quando algo falha
show_log_tail() {
  local lines="${1:-20}"
  echo ""
  echo -e "${YELLOW}  ── Últimas $lines linhas do log ──${RESET}"
  tail -n "$lines" "$LOG_FILE" | sed 's/^/  /'
  echo -e "${CYAN}  Log completo: $LOG_FILE${RESET}"
}

# Intercepta erros não tratados
trap 'echo -e "\n${RED}  Script interrompido por erro inesperado.${RESET}"; show_log_tail 30; exit 1' ERR

# -----------------------------------------------------------------------------
# Cores e helpers
# -----------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

ok()   { echo -e "${GREEN}  [OK]${RESET} $*";    log "OK:   $*"; }
skip() { echo -e "${YELLOW}  [SKIP]${RESET} $* (já instalado)"; log "SKIP: $*"; }
info() { echo -e "${CYAN}  [INFO]${RESET} $*";  log "INFO: $*"; }
warn() { echo -e "${YELLOW}  [WARN]${RESET} $*"; log "WARN: $*"; }
fail() { echo -e "${RED}  [ERRO]${RESET} $*";   log "ERRO: $*"; show_log_tail 20; exit 1; }

header() {
  echo ""
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "${BOLD}${BLUE}  $*${RESET}"
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  log "=== $* ==="
}

# Registro do que foi instalado/pulado para resumo final
INSTALLED=()
SKIPPED=()
FAILED=()
FAILED_LOGS=()  # guarda trecho do log por falha

track_ok()   { INSTALLED+=("$1"); ok "$1"; }
track_skip() { SKIPPED+=("$1"); skip "$1"; }
track_fail() {
  local name="$1"
  local reason="${2:-ver log}"
  FAILED+=("$name")
  FAILED_LOGS+=("$name :: $reason")
  warn "Falha ao instalar: $name ($reason)"
  log "FAIL: $name — $reason"
}

# -----------------------------------------------------------------------------
# Spinner para operações longas
# -----------------------------------------------------------------------------
SPINNER_PID=""

spinner_start() {
  local msg="$1"
  local frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
  (
    local i=0
    while true; do
      printf "\r  ${CYAN}%s${RESET}  %s..." "${frames[$i]}" "$msg"
      i=$(( (i+1) % ${#frames[@]} ))
      sleep 0.1
    done
  ) &
  SPINNER_PID=$!
  disown "$SPINNER_PID" 2>/dev/null || true
}

spinner_stop() {
  if [[ -n "$SPINNER_PID" ]] && kill -0 "$SPINNER_PID" 2>/dev/null; then
    kill "$SPINNER_PID" 2>/dev/null || true
    wait "$SPINNER_PID" 2>/dev/null || true
  fi
  SPINNER_PID=""
  printf "\r\033[K"   # limpa a linha do spinner
}

# Wrapper: roda comando com spinner, tudo vai pro log
run_spin() {
  local msg="$1"; shift
  log "RUN: $*"
  spinner_start "$msg"
  local exit_code=0
  "$@" >> "$LOG_FILE" 2>&1 || exit_code=$?
  spinner_stop
  return $exit_code
}

# -----------------------------------------------------------------------------
# Utilitários de verificação
# -----------------------------------------------------------------------------
command_exists() { command -v "$1" &>/dev/null; }

version_gte() {
  printf '%s\n%s\n' "$2" "$1" | sort -V -C
}

DISTRO_FAMILY=""

detect_distro() {
  if command_exists apt-get; then
    DISTRO_FAMILY="debian"
  elif command_exists pacman; then
    DISTRO_FAMILY="arch"
  else
    fail "Distro não suportada. Requer apt-get (Debian/Ubuntu) ou pacman (Arch)."
  fi
  log "DISTRO_FAMILY: $DISTRO_FAMILY"
}

require_sudo() {
  if [[ $EUID -eq 0 ]]; then
    SUDO=""
  elif command_exists sudo; then
    SUDO="sudo"
    info "Permissões sudo serão necessárias."
  else
    fail "sudo não encontrado e não está rodando como root."
  fi
}

apt_install() {
  log "apt-get install: $*"
  $SUDO apt-get install -y --no-install-recommends "$@" >> "$LOG_FILE" 2>&1
}

pacman_install() {
  log "pacman -S: $*"
  $SUDO pacman -S --noconfirm --needed "$@" >> "$LOG_FILE" 2>&1
}

# Mapeamento de nomes de pacotes: chave=nome debian, valor=nome arch
declare -A _ARCH_PKG_MAP=(
  [build-essential]="base-devel"
  [python3-pip]="python-pip"
  [libfuse2]="fuse2"
  [fuse]="fuse2"
  [apt-transport-https]=""           # não existe no arch
  [software-properties-common]=""    # não existe no arch
  [openjdk-17-jdk]="jdk17-openjdk"
  [libgtk-3-dev]="gtk3"
  [libblkid-dev]="util-linux"
  [liblzma-dev]="xz"
  [libglu1-mesa]="glu"
  [ninja-build]="ninja"
)

# Resolve nome do pacote para a distro atual
resolve_pkg() {
  local pkg="$1"
  if [[ "$DISTRO_FAMILY" == "arch" ]]; then
    echo "${_ARCH_PKG_MAP[$pkg]:-$pkg}"
  else
    echo "$pkg"
  fi
}

# Instala pacote usando o gerenciador da distro
pkg_install() {
  if [[ "$DISTRO_FAMILY" == "arch" ]]; then
    pacman_install "$@"
  else
    apt_install "$@"
  fi
}

# Verifica se pacote já está instalado
pkg_installed() {
  if [[ "$DISTRO_FAMILY" == "arch" ]]; then
    pacman -Q "$1" &>/dev/null 2>&1
  else
    dpkg -s "$1" &>/dev/null 2>&1
  fi
}

# Extrai a última mensagem de erro do log (útil para track_fail)
last_log_error() {
  grep -i 'error\|unable\|failed\|E:' "$LOG_FILE" | tail -3 | tr '\n' ' '
}

# -----------------------------------------------------------------------------
# Verificações iniciais
# -----------------------------------------------------------------------------
echo ""
echo -e "${BOLD}${BLUE}  Neovim Dotfiles — Setup${RESET}"
echo -e "  Log: ${CYAN}$LOG_FILE${RESET}"
echo ""

detect_distro
require_sudo

if [[ -f /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  info "Distro: ${PRETTY_NAME:-unknown}"
  log "Distro: ${PRETTY_NAME:-unknown}"
fi

# -----------------------------------------------------------------------------
# Flags de componentes opcionais
# -----------------------------------------------------------------------------
WITH_GO=false
WITH_JAVA=false
WITH_FLUTTER=false
WITH_COPILOT=false
WITH_SDKMAN=false
WITH_WAKATIME=false

for arg in "$@"; do
  case "$arg" in
    --with-go)       WITH_GO=true ;;
    --with-java)     WITH_JAVA=true ;;
    --with-flutter)  WITH_FLUTTER=true ;;
    --with-copilot)  WITH_COPILOT=true ;;
    --with-sdkman)   WITH_SDKMAN=true ;;
    --with-wakatime) WITH_WAKATIME=true ;;
    --all)
      WITH_GO=true; WITH_JAVA=true; WITH_FLUTTER=true
      WITH_COPILOT=true; WITH_SDKMAN=true; WITH_WAKATIME=true
      ;;
    --help|-h)
      echo ""
      echo -e "${BOLD}Uso:${RESET} ./install.sh [opções]"
      echo ""
      echo "  --with-go        Go + ferramentas"
      echo "  --with-java      Java JDK 17 + Maven"
      echo "  --with-flutter   Flutter + Dart SDK"
      echo "  --with-copilot   GitHub Copilot (vim plugin)"
      echo "  --with-sdkman    SDKMAN (multi-versão Java)"
      echo "  --with-wakatime  Aviso de configuração WakaTime"
      echo "  --all            Tudo acima"
      echo "  --help           Esta ajuda"
      echo ""
      echo "Sem flags: instala apenas os requisitos obrigatórios."
      echo ""
      exit 0
      ;;
    *)
      warn "Argumento desconhecido: $arg (use --help)"
      ;;
  esac
done

# -----------------------------------------------------------------------------
# 1. Dependências base do sistema
# -----------------------------------------------------------------------------
header "1/8 — Dependências base do sistema"

info "Atualizando lista de pacotes..."
if [[ "$DISTRO_FAMILY" == "arch" ]]; then
  run_spin "Atualizando pacman" $SUDO pacman -Sy --noconfirm
else
  run_spin "Atualizando apt" $SUDO apt-get update -qq
fi

BASE_PKGS=(
  git curl wget unzip tar gzip
  build-essential ca-certificates gnupg
  apt-transport-https
  python3 python3-pip
  xclip xsel
  fuse libfuse2
)

# software-properties-common é útil mas não crítico — instala separado para
# não travar o loop principal em distros onde está indisponível
OPTIONAL_SYS_PKGS=(software-properties-common)

for pkg in "${BASE_PKGS[@]}"; do
  local_pkg=$(resolve_pkg "$pkg")
  if [[ -z "$local_pkg" ]]; then
    info "$pkg não aplicável nesta distro — pulando."
    log "SKIP_DISTRO: $pkg"
    continue
  fi
  if pkg_installed "$local_pkg"; then
    track_skip "$local_pkg"
  else
    run_spin "Instalando $local_pkg" pkg_install "$local_pkg" \
      && track_ok "$local_pkg" \
      || track_fail "$local_pkg" "$(last_log_error)"
  fi
done

for pkg in "${OPTIONAL_SYS_PKGS[@]}"; do
  local_pkg=$(resolve_pkg "$pkg")
  if [[ -z "$local_pkg" ]]; then
    log "SKIP_DISTRO_OPT: $pkg"
    continue
  fi
  if pkg_installed "$local_pkg"; then
    track_skip "$local_pkg"
  else
    run_spin "Instalando $local_pkg (opcional)" pkg_install "$local_pkg" \
      && track_ok "$local_pkg" \
      || { warn "$local_pkg não pôde ser instalado — não é crítico, continuando."; log "SKIP_OPT: $local_pkg"; }
  fi
done

# -----------------------------------------------------------------------------
# 2. Neovim
# -----------------------------------------------------------------------------
header "2/8 — Neovim"

NVIM_MIN="0.9.0"
NVIM_APPIMAGE_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"
NVIM_INSTALL_DIR="/usr/local/bin"

install_neovim() {
  info "Baixando Neovim (latest stable)..."
  local tmp_nvim
  tmp_nvim=$(mktemp)
  run_spin "Baixando Neovim" curl -fsSL "$NVIM_APPIMAGE_URL" -o "$tmp_nvim"
  chmod +x "$tmp_nvim"
  $SUDO mv "$tmp_nvim" "$NVIM_INSTALL_DIR/nvim"
  track_ok "neovim ($(nvim --version | head -1))"
}

if command_exists nvim; then
  NVIM_VER=$(nvim --version | head -1 | grep -oP '\d+\.\d+\.\d+' | head -1)
  if version_gte "$NVIM_VER" "$NVIM_MIN"; then
    track_skip "neovim ($NVIM_VER)"
  else
    warn "Neovim $NVIM_VER < mínimo $NVIM_MIN — atualizando..."
    install_neovim
  fi
else
  install_neovim
fi

# -----------------------------------------------------------------------------
# 3. ripgrep
# -----------------------------------------------------------------------------
header "3/8 — ripgrep"

if command_exists rg; then
  track_skip "ripgrep ($(rg --version | head -1))"
else
  info "Instalando ripgrep..."
  if run_spin "Instalando ripgrep" pkg_install ripgrep; then
    track_ok "ripgrep ($(rg --version | head -1))"
  elif [[ "$DISTRO_FAMILY" == "debian" ]]; then
    warn "apt falhou — tentando via GitHub releases..."
    log "Fallback: ripgrep via GitHub"
    RG_TAG=$(curl -fsSL https://api.github.com/repos/BurntSushi/ripgrep/releases/latest \
      | grep '"tag_name"' | grep -oP '\d+\.\d+\.\d+' | head -1)
    RG_URL="https://github.com/BurntSushi/ripgrep/releases/latest/download/ripgrep_${RG_TAG}_amd64.deb"
    TMP_RG=$(mktemp --suffix=.deb)
    run_spin "Baixando ripgrep ${RG_TAG}" curl -fsSL "$RG_URL" -o "$TMP_RG"
    $SUDO dpkg -i "$TMP_RG" >> "$LOG_FILE" 2>&1 && track_ok "ripgrep $RG_TAG" \
      || track_fail "ripgrep" "$(last_log_error)"
    rm -f "$TMP_RG"
  else
    track_fail "ripgrep" "$(last_log_error)"
  fi
fi

# -----------------------------------------------------------------------------
# 4. Node.js LTS
# -----------------------------------------------------------------------------
header "4/8 — Node.js + npm"

NODE_MIN="18"

install_nodejs() {
  if [[ "$DISTRO_FAMILY" == "arch" ]]; then
    run_spin "Instalando Node.js" pacman_install nodejs npm
    track_ok "node.js ($(node --version))"
  else
    info "Adicionando repositório NodeSource (LTS)..."
    run_spin "Configurando repositório NodeSource" \
      bash -c 'curl -fsSL https://deb.nodesource.com/setup_lts.x | '"$SUDO"' bash -'
    run_spin "Instalando Node.js" apt_install nodejs
    track_ok "node.js ($(node --version))"
  fi
}

if command_exists node; then
  NODE_VER=$(node --version | grep -oP '\d+' | head -1)
  if [[ "$NODE_VER" -ge "$NODE_MIN" ]]; then
    track_skip "node.js ($(node --version))"
  else
    warn "Node.js v$NODE_VER < mínimo v$NODE_MIN — atualizando..."
    install_nodejs
  fi
else
  install_nodejs
fi

# -- npm prefix no home do usuário (evita necessidade de sudo para install -g) --
header "4.1 — npm prefix (sem sudo)"

NPM_GLOBAL_DIR="$HOME/.npm-global"
CURRENT_NPM_PREFIX=$(npm config get prefix 2>/dev/null || echo "")

if [[ "$CURRENT_NPM_PREFIX" == "$NPM_GLOBAL_DIR" ]]; then
  track_skip "npm prefix ($NPM_GLOBAL_DIR)"
else
  info "Configurando npm prefix em $NPM_GLOBAL_DIR..."
  mkdir -p "$NPM_GLOBAL_DIR"
  npm config set prefix "$NPM_GLOBAL_DIR" >> "$LOG_FILE" 2>&1

  NPM_PATH_LINE="export PATH=\"\$PATH:$NPM_GLOBAL_DIR/bin\""
  for rc in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
    if [[ -f "$rc" ]] && ! grep -q "$NPM_GLOBAL_DIR/bin" "$rc"; then
      echo "$NPM_PATH_LINE" >> "$rc"
      log "Adicionado ao PATH em $rc"
    fi
  done
  export PATH="$PATH:$NPM_GLOBAL_DIR/bin"
  track_ok "npm prefix → $NPM_GLOBAL_DIR"
fi

# -- Pacotes npm globais --
header "4.2 — Pacotes npm globais (TypeScript / Vue LSP)"

NPM_PKGS=("typescript" "@vue/typescript-plugin")

for pkg in "${NPM_PKGS[@]}"; do
  # npm list -g pode falhar se o prefix foi reconfigurado agora; usamos which como fallback
  local_bin=$(npm config get prefix)/bin
  pkg_bin="${pkg##*/}"   # extrai nome sem @scope para binários simples
  if npm list -g --depth=0 "$pkg" >> "$LOG_FILE" 2>&1; then
    track_skip "npm: $pkg"
  else
    log "npm install -g $pkg"
    run_spin "npm install -g $pkg" npm install -g "$pkg" \
      && track_ok "npm: $pkg" \
      || track_fail "npm: $pkg" "$(last_log_error)"
  fi
done

# -----------------------------------------------------------------------------
# 5. Go (opcional)
# -----------------------------------------------------------------------------
header "5/8 — Go"

GO_MIN="1.21"

install_go() {
  info "Buscando versão mais recente do Go..."
  GO_VERSION=$(curl -fsSL "https://go.dev/dl/?mode=json" 2>/dev/null \
    | python3 -c "import sys,json; print(json.load(sys.stdin)[0]['version'])" 2>/dev/null \
    || echo "go1.22.0")
  GO_URL="https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz"
  TMP_GO=$(mktemp -d)

  run_spin "Baixando $GO_VERSION" curl -fsSL "$GO_URL" -o "$TMP_GO/go.tar.gz"
  run_spin "Extraindo $GO_VERSION" bash -c "$SUDO rm -rf /usr/local/go && $SUDO tar -C /usr/local -xzf $TMP_GO/go.tar.gz"
  rm -rf "$TMP_GO"

  GOPATH_LINE='export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin'
  for rc in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
    if [[ -f "$rc" ]] && ! grep -q '/usr/local/go/bin' "$rc"; then
      echo "$GOPATH_LINE" >> "$rc"
    fi
  done
  export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
  track_ok "go ($GO_VERSION)"
}

if $WITH_GO; then
  if command_exists go; then
    GO_VER=$(go version | grep -oP '\d+\.\d+' | head -1)
    if version_gte "$GO_VER" "$GO_MIN"; then
      track_skip "go ($(go version | awk '{print $3}'))"
    else
      warn "Go $GO_VER < mínimo $GO_MIN — atualizando..."
      install_go
    fi
  else
    install_go
  fi
else
  info "Go pulado. Use --with-go para instalar."
fi

# -----------------------------------------------------------------------------
# 6. Java JDK 17 + Maven (opcional)
# -----------------------------------------------------------------------------
header "6/8 — Java JDK 17 + Maven"

if $WITH_JAVA; then
  if command_exists java; then
    JAVA_VER=$(java -version 2>&1 | grep -oP '\d+' | head -1)
    if [[ "$JAVA_VER" -ge 11 ]]; then
      track_skip "java (versão $JAVA_VER)"
    else
      warn "Java $JAVA_VER < 11 — instalando JDK 17..."
      _java_pkg=$(resolve_pkg openjdk-17-jdk)
      run_spin "Instalando $_java_pkg" pkg_install "$_java_pkg" \
        && track_ok "$_java_pkg" \
        || track_fail "$_java_pkg" "$(last_log_error)"
    fi
  else
    info "Instalando OpenJDK 17..."
    _java_pkg=$(resolve_pkg openjdk-17-jdk)
    run_spin "Instalando $_java_pkg" pkg_install "$_java_pkg" \
      && track_ok "$_java_pkg" \
      || track_fail "$_java_pkg" "$(last_log_error)"
  fi

  if command_exists mvn; then
    track_skip "maven ($(mvn --version | head -1))"
  else
    run_spin "Instalando Maven" pkg_install maven \
      && track_ok "maven" \
      || track_fail "maven" "$(last_log_error)"
  fi

  if $WITH_SDKMAN; then
    if [[ -d "$HOME/.sdkman" ]]; then
      track_skip "sdkman"
    else
      run_spin "Instalando SDKMAN" bash -c 'curl -fsSL "https://get.sdkman.io" | bash' \
        && track_ok "sdkman" \
        || track_fail "sdkman" "$(last_log_error)"
      info "Para ativar: source \"\$HOME/.sdkman/bin/sdkman-init.sh\""
    fi
  fi
else
  info "Java pulado. Use --with-java para instalar."
fi

# -----------------------------------------------------------------------------
# 7. Flutter + Dart (opcional)
# -----------------------------------------------------------------------------
header "7/8 — Flutter + Dart SDK"

FLUTTER_DIR="$HOME/development/flutter"

if $WITH_FLUTTER; then
  FLUTTER_DEPS=(libgtk-3-dev libblkid-dev liblzma-dev libglu1-mesa clang cmake ninja-build pkg-config)
  for dep in "${FLUTTER_DEPS[@]}"; do
    local_dep=$(resolve_pkg "$dep")
    [[ -z "$local_dep" ]] && { log "SKIP_DISTRO: $dep"; continue; }
    if pkg_installed "$local_dep"; then
      track_skip "$local_dep"
    else
      run_spin "Instalando $local_dep" pkg_install "$local_dep" \
        && track_ok "$local_dep" \
        || track_fail "$local_dep" "$(last_log_error)"
    fi
  done

  if command_exists flutter; then
    FLUTTER_VER=$(flutter --version 2>/dev/null | grep -oP 'Flutter \S+' | head -1 || echo "versão desconhecida")
    track_skip "flutter ($FLUTTER_VER)"
  else
    if [[ ! -d "$FLUTTER_DIR" ]]; then
      info "Clonando Flutter SDK (pode demorar)..."
      run_spin "Clonando Flutter SDK" \
        git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_DIR" --depth 1
    else
      info "Diretório $FLUTTER_DIR já existe — reutilizando."
    fi

    FLUTTER_PATH_LINE="export PATH=\"\$PATH:$FLUTTER_DIR/bin\""
    for rc in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
      if [[ -f "$rc" ]] && ! grep -q "$FLUTTER_DIR/bin" "$rc"; then
        echo "$FLUTTER_PATH_LINE" >> "$rc"
      fi
    done
    export PATH="$PATH:$FLUTTER_DIR/bin"

    run_spin "flutter precache" flutter precache >> "$LOG_FILE" 2>&1 || true
    FLUTTER_VER=$(flutter --version 2>/dev/null | grep -oP 'Flutter \S+' | head -1 || echo "instalado")
    track_ok "flutter ($FLUTTER_VER)"
  fi

  if command_exists dart; then
    track_skip "dart ($(dart --version 2>&1 | head -1))"
  else
    info "Dart vem bundled com Flutter — garanta Flutter no PATH."
  fi
else
  info "Flutter pulado. Use --with-flutter para instalar."
fi

# -----------------------------------------------------------------------------
# 8. GitHub Copilot (opcional)
# -----------------------------------------------------------------------------
header "8/8 — GitHub Copilot"

COPILOT_DIR="$HOME/.config/nvim/pack/github/start/copilot.vim"

if $WITH_COPILOT; then
  if [[ -d "$COPILOT_DIR" ]]; then
    track_skip "copilot.vim (já presente)"
  else
    mkdir -p "$(dirname "$COPILOT_DIR")"
    run_spin "Clonando copilot.vim" \
      git clone https://github.com/github/copilot.vim.git "$COPILOT_DIR" --depth 1 \
      && track_ok "copilot.vim" \
      || track_fail "copilot.vim" "$(last_log_error)"
    info "Após abrir o Neovim, rode: :Copilot auth"
  fi
else
  info "Copilot pulado. Use --with-copilot para instalar."
fi

# -----------------------------------------------------------------------------
# WakaTime (lembrete)
# -----------------------------------------------------------------------------
if $WITH_WAKATIME; then
  header "WakaTime"
  if [[ -f "$HOME/.wakatime.cfg" ]]; then
    track_skip "wakatime config (~/.wakatime.cfg já existe)"
  else
    warn "WakaTime: crie ~/.wakatime.cfg com seu api_key."
    info "Conteúdo:"
    echo "      [settings]"
    echo "      api_key = SUA-CHAVE-AQUI"
    info "Chave disponível em: https://wakatime.com/settings/api-key"
  fi
fi

# -----------------------------------------------------------------------------
# Nerd Font
# -----------------------------------------------------------------------------
header "Nerd Font (ícones)"

FONT_DIR="$HOME/.local/share/fonts"

if fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd"; then
  track_skip "JetBrainsMono Nerd Font"
else
  info "Instalando JetBrainsMono Nerd Font..."
  mkdir -p "$FONT_DIR"
  FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
  TMP_FONT=$(mktemp -d)
  run_spin "Baixando JetBrainsMono Nerd Font" curl -fsSL "$FONT_URL" -o "$TMP_FONT/font.zip"
  run_spin "Extraindo fontes" unzip -q "$TMP_FONT/font.zip" -d "$TMP_FONT/fonts"
  find "$TMP_FONT/fonts" -name "*.ttf" -exec cp {} "$FONT_DIR/" \;
  run_spin "Atualizando cache de fontes" fc-cache -fv
  rm -rf "$TMP_FONT"
  track_ok "JetBrainsMono Nerd Font"
  warn "Reinicie o terminal e configure-o para usar 'JetBrainsMono Nerd Font'."
fi

# -----------------------------------------------------------------------------
# Verificação final
# -----------------------------------------------------------------------------
header "Verificação final"

if command_exists nvim; then
  ok "Neovim: $(nvim --version | head -1)"
else
  fail "Neovim não encontrado após instalação."
fi

LAZY_DIR="$HOME/.local/share/nvim/lazy/lazy.nvim"
if [[ -d "$LAZY_DIR" ]]; then
  ok "lazy.nvim: já inicializado"
else
  info "lazy.nvim será instalado automaticamente na primeira execução do Neovim."
fi

# -----------------------------------------------------------------------------
# Resumo
# -----------------------------------------------------------------------------
echo ""
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${BOLD}  RESUMO DA INSTALAÇÃO${RESET}"
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

if [[ ${#INSTALLED[@]} -gt 0 ]]; then
  echo -e "${GREEN}${BOLD}  Instalados (${#INSTALLED[@]}):${RESET}"
  for item in "${INSTALLED[@]}"; do
    echo -e "    ${GREEN}+${RESET} $item"
  done
fi

if [[ ${#SKIPPED[@]} -gt 0 ]]; then
  echo -e "${YELLOW}${BOLD}  Pulados / já presentes (${#SKIPPED[@]}):${RESET}"
  for item in "${SKIPPED[@]}"; do
    echo -e "    ${YELLOW}~${RESET} $item"
  done
fi

if [[ ${#FAILED[@]} -gt 0 ]]; then
  echo -e "${RED}${BOLD}  Falhas (${#FAILED[@]}):${RESET}"
  for item in "${FAILED_LOGS[@]}"; do
    echo -e "    ${RED}✗${RESET} $item"
  done
  echo ""
  echo -e "  ${CYAN}Para diagnóstico completo:${RESET}"
  echo -e "    cat $LOG_FILE"
  echo -e "    grep -A3 'FAIL\\|error\\|Error' $LOG_FILE"
fi

echo ""
echo -e "${BOLD}  Próximos passos:${RESET}"
echo -e "  1. Reinicie o terminal (ou: ${CYAN}source ~/.bashrc${RESET})"
echo -e "  2. Abra o Neovim: ${CYAN}nvim${RESET}"
echo -e "  3. Aguarde lazy.nvim instalar os plugins"
echo -e "  4. Instale os LSPs: ${CYAN}:Mason${RESET}"
if $WITH_COPILOT; then
  echo -e "  5. Autentique o Copilot: ${CYAN}:Copilot auth${RESET}"
fi
echo ""
echo -e "  ${CYAN}Log completo salvo em: $LOG_FILE${RESET}"
echo ""

log "=== Setup finalizado. Instalados=${#INSTALLED[@]} Pulados=${#SKIPPED[@]} Falhas=${#FAILED[@]} ==="

if [[ ${#FAILED[@]} -gt 0 ]]; then
  exit 1
fi
