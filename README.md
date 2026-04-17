# Neovim Dotfiles

Configuração completa de Neovim com suporte a múltiplas linguagens, debugging, LSP, Copilot e ferramentas de desenvolvimento.

---

## Requisitos do Sistema

| Ferramenta | Versão | Obrigatório |
|-----------|--------|-------------|
| Neovim | `0.9+` | Sim |
| Git | Qualquer | Sim |
| ripgrep (`rg`) | Qualquer | Sim (Telescope live grep) |
| Node.js + npm | LTS | Sim (JS/TS debugging e plugins) |
| Go | `1.21+` | Se usar Go |
| Java (JDK) | `11+` | Se usar Java/Spring Boot |
| Dart + Flutter SDK | Stable | Se usar Flutter/Dart |
| Python | `3.8+` | Recomendado |

---

## Instalação

### 1. Clonar o repositório

```bash
git clone <repo-url> ~/.config/nvim
```

### 2. Instalar ripgrep

Necessário para o Telescope live grep funcionar.

```bash
# Debian/Ubuntu
sudo apt install ripgrep

# macOS
brew install ripgrep

# Arch Linux
sudo pacman -S ripgrep

# Windows (scoop)
scoop install ripgrep
```

> Referência: https://github.com/BurntSushi/ripgrep#installation

### 3. Instalar pacotes npm globais

Necessário para TypeScript, JavaScript e Vue funcionarem.

```bash
npm install -g typescript @vue/typescript-plugin
```

### 4. (Opcional) Instalar Copilot

```bash
git clone https://github.com/github/copilot.vim.git \
  ~/.config/nvim/pack/github/start/copilot.vim
```

Após instalar, autentique dentro do Neovim:

```
:Copilot auth
```

### 5. Abrir o Neovim

O **lazy.nvim** (gerenciador de plugins) é instalado automaticamente na primeira execução. Os plugins serão baixados e instalados automaticamente.

```bash
nvim
```

### 6. Instalar servidores LSP e DAP

O Mason gerencia a instalação dos servidores. Após abrir o Neovim:

```
:Mason
```

Os servidores configurados são instalados automaticamente via `mason-lspconfig`.

---

## Linguagens Suportadas

### Go

| Recurso | Status | Ferramenta |
|---------|--------|------------|
| LSP | ✅ | `gopls` |
| Syntax Highlighting | ✅ | Treesitter (`go`, `gomod`, `gowork`, `gosum`) |
| Formatter | ✅ | `gofumpt` (via gopls) |
| Linter | ✅ | `staticcheck` (via gopls) |
| Debug (DAP) | ✅ | `delve` |
| Test runner | ✅ | `go.nvim` |
| Code lens | ✅ | gopls |
| Inlay hints | ✅ | gopls |

**Dependência extra:**

```bash
# go e delve instalados automaticamente via Mason
```

---

### Java / Spring Boot

| Recurso | Status | Ferramenta |
|---------|--------|------------|
| LSP | ✅ | `jdtls` |
| Formatter | ✅ | Eclipse formatter (jdtls) |
| Linter | ✅ | Built-in (jdtls) |
| Debug (DAP) | ✅ | `jdtls` debug adapter |
| JUnit (testes) | ✅ | jdtls |
| Code lens | ✅ | jdtls |
| Spring Boot runner | ✅ | Custom (via Maven) |
| Multi-versão Java | ✅ | SDKMAN / config manual |

**Dependências extras:**

```bash
# JDK 11+
sudo apt install openjdk-17-jdk

# Maven (para projetos Spring Boot)
sudo apt install maven
```

> Suporte a múltiplas versões de Java via SDKMAN ou configuração manual no `.nvim-go.json`.

---

### TypeScript / JavaScript

| Recurso | Status | Ferramenta |
|---------|--------|------------|
| LSP | ✅ | `vtsls` |
| Syntax Highlighting | ✅ | Treesitter (`typescript`, `tsx`, `javascript`) |
| Formatter | ✅ | LSP (vtsls) |
| Linter | ✅ | LSP diagnostics |
| Debug (DAP) | ✅ | `pwa-node`, `node2` |
| Debug browser | ✅ | Chrome / Edge debug adapter |

**Dependências extras:**

```bash
npm install -g typescript @vue/typescript-plugin
```

---

### Vue.js

| Recurso | Status | Ferramenta |
|---------|--------|------------|
| LSP | ✅ | `volar` + `@vue/typescript-plugin` |
| Syntax Highlighting | ✅ | Treesitter (`vue`) |
| Formatter | ✅ | LSP (volar) |
| Linter | ✅ | LSP diagnostics |
| Debug (DAP) | ✅ | Chrome debug (Vite/webpack) |
| Auto-close tags | ✅ | `nvim-ts-autotag` |

**Dependências extras:**

```bash
npm install -g @vue/typescript-plugin
```

---

### Dart / Flutter

| Recurso | Status | Ferramenta |
|---------|--------|------------|
| LSP | ✅ | `dartls` (flutter-tools) |
| Formatter | ✅ | `dartfmt` |
| Linter | ✅ | Built-in (dartls) |
| Debug (DAP) | ✅ | Dart / Flutter debug adapter |
| Hot reload | ✅ | flutter-tools.nvim |
| Hot restart | ✅ | flutter-tools.nvim |
| Device selector | ✅ | flutter-tools.nvim |
| Flavor support | ✅ | dev, staging, production |
| Web build | ✅ | flutter-tools.nvim |
| Pub get/upgrade | ✅ | flutter-tools.nvim |
| Flutter test | ✅ | flutter-tools.nvim |

**Dependências extras:**

```bash
# Instalar Flutter SDK
# https://docs.flutter.dev/get-started/install

# Verificar instalação
flutter doctor
```

---

### Lua

| Recurso | Status | Ferramenta |
|---------|--------|------------|
| LSP | ✅ | `lua_ls` |
| Syntax Highlighting | ✅ | Treesitter (`lua`) |
| Formatter | ✅ | LSP (lua_ls) |
| Linter | ✅ | LSP diagnostics |

> `lua_ls` é instalado automaticamente via Mason.

---

### HTML / CSS

| Recurso | Status | Ferramenta |
|---------|--------|------------|
| Syntax Highlighting | ✅ | Treesitter (`html`, `css`) |
| Auto-close tags | ✅ | `nvim-ts-autotag` |

---

## Plugins Instalados

### LSP & Completion

| Plugin | Função |
|--------|--------|
| `nvim-lspconfig` | Framework de configuração LSP |
| `mason.nvim` | Instalador de LSP/DAP/formatters |
| `mason-lspconfig.nvim` | Integração Mason ↔ lspconfig |
| `nvim-cmp` | Engine de completion |
| `LuaSnip` | Engine de snippets |
| `friendly-snippets` | Snippets prontos |
| `lspkind-nvim` | Ícones no completion |

### Treesitter

| Plugin | Função |
|--------|--------|
| `nvim-treesitter` | Syntax highlighting avançado e parsing |

### Debugging (DAP)

| Plugin | Função |
|--------|--------|
| `nvim-dap` | Debug Adapter Protocol |
| `nvim-dap-ui` | Interface visual de debug |
| `nvim-dap-go` | Debug para Go |
| `nvim-nio` | Biblioteca async (dep. dap-ui) |

### Navegação & Busca

| Plugin | Função |
|--------|--------|
| `telescope.nvim` | Fuzzy finder |
| `telescope-ui-select.nvim` | UI do telescope para `vim.ui.select` |
| `neo-tree.nvim` | Árvore de arquivos |
| `harpoon` (v2) | Navegação rápida entre arquivos |

### Ferramentas por Linguagem

| Plugin | Função |
|--------|--------|
| `go.nvim` | Ferramentas de desenvolvimento Go |
| `nvim-jdtls` | Suporte Java / jdtls |
| `flutter-tools.nvim` | Ferramentas Flutter / Dart |

### IA

| Plugin | Função |
|--------|--------|
| `copilot.vim` | GitHub Copilot |
| `CopilotChat.nvim` | Chat com Copilot no editor |

### Edição

| Plugin | Função |
|--------|--------|
| `nvim-autopairs` | Fecha automaticamente parênteses/colchetes |
| `nvim-ts-autotag` | Fecha automaticamente tags HTML/JSX |

### Git

| Plugin | Função |
|--------|--------|
| `vim-fugitive` | Integração completa com Git |

### Terminal

| Plugin | Função |
|--------|--------|
| `toggleterm.nvim` | Terminal flutuante |

### UI & Aparência

| Plugin | Função |
|--------|--------|
| `lualine.nvim` | Status line |
| `nvim-web-devicons` | Ícones de arquivos |
| `dressing.nvim` | Melhora inputs e selects |
| `nui.nvim` | Biblioteca de componentes UI |

### Produtividade

| Plugin | Função |
|--------|--------|
| `vim-wakatime` | Rastreamento de tempo (WakaTime) |

### Temas disponíveis

| Tema | Padrão |
|------|--------|
| `tokyodark.nvim` | ✅ (padrão) |
| `catppuccin` | |
| `kanagawa.nvim` | |
| `rose-pine` | |
| `neosolarized.nvim` | |
| `dark-purple.vim` | |
| `minimal.nvim` | |

---

## Keymaps Principais

> Leader key: `<Space>`

### Navegação

| Keymap | Ação |
|--------|------|
| `<C-h/j/k/l>` | Mover entre janelas |
| `gf` | Busca de arquivos (Telescope) |
| `<C-p>` | Busca de buffers (Telescope) |
| `<leader>fg` | Grep ao vivo (Telescope) |
| `<leader><C-p>` | Arquivos git (Telescope) |
| `<A-1>` ou `-` | Toggle árvore de arquivos |
| `<leader>nf` | Focar arquivo atual na árvore |

### Harpoon

| Keymap | Ação |
|--------|------|
| `<leader>a` | Adicionar arquivo ao harpoon |
| `he` | Abrir menu harpoon |
| `<C-m>` / `<C-n>` / `<C-b>` | Ir para arquivo 1/2/3 |
| `h1`–`h7` | Ir para arquivo 1–7 |

### LSP

| Keymap | Ação |
|--------|------|
| `gd` | Ir para definição |
| `K` | Hover (documentação) |
| `<leader>rn` | Renomear símbolo |
| `<A-CR>` | Code action |
| `<leader>vrr` | Referências |
| `<C-A-L>` | Formatar buffer |
| `[d` / `]d` | Próximo/anterior diagnóstico |

### DAP (Debug)

| Keymap | Ação |
|--------|------|
| `<F5>` | Continuar / Iniciar debug |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Breakpoint condicional |
| `<leader>du` | Toggle DAP UI |
| `<leader>dr` | Abrir REPL |

### Terminal

| Keymap | Ação |
|--------|------|
| `<C-\>` | Toggle terminal flutuante |

### Go

| Keymap | Ação |
|--------|------|
| `<leader>gr` | Run projeto |
| `<leader>gt` | Rodar testes |
| `<leader>gtf` | Testar função |
| `<leader>gf` | Formatar |
| `<leader>gi` | Imports |
| `<leader>gcov` | Coverage |

### Flutter

| Keymap | Ação |
|--------|------|
| `<F8>` | Flutter run interativo |
| `<leader>fr` | Hot reload |
| `<leader>fR` | Hot restart |
| `<leader>fc` | Clean |
| `<leader>fp` | Pub get |
| `<leader>ft` | Testes |

### Java / Spring Boot

| Keymap | Ação |
|--------|------|
| `<F9>` | Spring Boot run interativo |
| `<C-F9>` | Spring Boot quick run |
| `<C-F12>` | Spring Boot debug |
| `<C-A-o>` | Organizar imports |
| `crv` / `crc` / `crm` | Extrair variável/constante/método |

### Copilot

| Keymap | Ação |
|--------|------|
| `<leader>ec` | Habilitar Copilot |
| `<leader>dc` | Desabilitar Copilot |

---

## Comandos Customizados

### Gerais

| Comando | Ação |
|---------|------|
| `:ReloadConfig` | Recarregar configuração Lua |
| `:Transparent` | Toggle fundo transparente |
| `:Format` | Formatar buffer |
| `:DevTools` | Abrir menu de ferramentas de desenvolvimento |
| `:DevStatus` | Status do projeto atual |
| `:DevEnv` | Configurar variáveis de ambiente |

### Go

| Comando | Ação |
|---------|------|
| `:GoRunProject` | Rodar projeto Go |
| `:GoCreateConfig` | Criar `.nvim-go.json` |
| `:GoListConfigs` | Listar configs de execução |

### Flutter

| Comando | Ação |
|---------|------|
| `:FlutterRun` | Run interativo |
| `:FlutterQuick` | Quick debug run |
| `:FlutterHotReload` | Hot reload |
| `:FlutterHotRestart` | Hot restart |
| `:FlutterBuild` | Build |
| `:FlutterClean` | Clean |
| `:FlutterPubGet` | Pub get |
| `:FlutterTest` | Testes |
| `:FlutterLaunchJson` | Gerar launch.json |

### Spring Boot

| Comando | Ação |
|---------|------|
| `:SpringBootRun` | Run interativo |
| `:SpringBootQuick` | Quick run |
| `:SpringBootDebug` | Debug |
| `:SpringBootLaunchJson` | Gerar launch.json |

---

## Detecção Automática de Projetos

A config detecta automaticamente o tipo de projeto baseado nos arquivos presentes:

| Arquivo detectado | Tipo de projeto |
|------------------|----------------|
| `pubspec.yaml` | Flutter |
| `analysis_options.yaml` | Dart |
| `pom.xml` | Maven / Spring Boot |
| `build.gradle` / `build.gradle.kts` | Gradle |
| `package.json` | Node.js |
| `go.mod` | Go |
| `Cargo.toml` | Rust |

---

## Variáveis de Ambiente

A config carrega automaticamente variáveis de ambiente dos arquivos:

- `.env`
- `.env.local`
- `.env.development`
- `.env.production`

---

## Estrutura de Arquivos

```
~/.config/nvim/
├── init.lua                     # Entry point
├── lazy-lock.json               # Versões fixas dos plugins
├── .neoconf.json                # Configurações neoconf
│
└── lua/
    ├── config/
    │   ├── editor.lua           # Configurações do editor
    │   ├── mappings.lua         # Keybindings globais
    │   ├── lazy.lua             # Setup do lazy.nvim
    │   ├── dev-tools.lua        # Menu de ferramentas de desenvolvimento
    │   ├── dap.lua              # Setup do DAP UI
    │   ├── dap/                 # Configs de debug por linguagem
    │   │   ├── dart.lua
    │   │   ├── flutter-runner.lua
    │   │   ├── go.lua
    │   │   ├── java.lua
    │   │   ├── javascript.lua
    │   │   └── spring-boot.lua
    │   └── lsp/
    │       ├── setup.lua        # Mason + LSP setup
    │       ├── commom.lua       # Config comum LSP
    │       └── servers/         # Config por servidor LSP
    │           ├── dart_ls.lua
    │           ├── gopls.lua
    │           ├── jdtls.lua
    │           ├── lua_ls.lua
    │           ├── tsserver.lua
    │           └── vuels.lua
    │
    ├── plugins/                 # Specs dos plugins (lazy.nvim)
    │   ├── lsp.lua
    │   ├── cmp.lua
    │   ├── treesitter.lua
    │   ├── telescope.lua
    │   ├── copilot.lua
    │   ├── copilot_chat.lua
    │   ├── dap.lua
    │   ├── go.lua
    │   ├── java.lua
    │   ├── flutter_tools.lua
    │   ├── harpoon.lua
    │   ├── neothree.lua
    │   ├── toggle_term.lua
    │   ├── fugitive.lua
    │   └── ...
    │
    └── resources/
        ├── utils.lua
        ├── theme_utils.lua
        ├── keymap_utils.lua
        └── exec_files.lua
```
