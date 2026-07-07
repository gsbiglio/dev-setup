# dev-setup

> Minimal, idempotent Ansible setup to reproduce my macOS development environment.

Run it on a brand-new Mac (or an existing one) and get all your apps, CLIs and
config in place. It's safe to re-run: every task only changes what's needed, so
if something fails you just run it again.

## Features

- One command to provision a fresh macOS machine
- Idempotent and re-runnable (powered by Ansible + Homebrew)
- A single file to declare what you want installed (`group_vars/all.yml`)
- Python versions, project deps and global CLIs via [`uv`](https://docs.astral.sh/uv/)
- Shell `PATH` wired up for `zsh` (Warp-friendly)
- Minimal Neovim config (Treesitter + Pyright + Ruff)

## Requirements

- macOS (Apple Silicon or Intel)
- Xcode Command Line Tools (`xcode-select --install` if missing)
- Internet connection

`bootstrap.sh` checks for Command Line Tools, installs Homebrew and Ansible, then
runs the playbook.

## Usage

On a brand-new machine:

```bash
git clone https://github.com/<your-username>/dev-setup.git
cd dev-setup
chmod +x bootstrap.sh
./bootstrap.sh
```

On an already-configured machine (re-run safely):

```bash
./bootstrap.sh
```

After the first run, open a new terminal (or `source ~/.zshrc`) so your shell
picks up the updated `PATH`.

## What it installs

Edit `group_vars/all.yml` to add or remove packages.

| Category | Packages |
|----------|----------|
| Apps (cask) | Chrome, WhatsApp, Docker Desktop, Linear, Cursor, Spotify, NordLayer, Pritunl, Notion, DBeaver, AltTab, Rectangle, Tad, Ollama |
| CLI (formula) | uv, PostgreSQL, Neovim, AWS CLI, Databricks CLI, [OpenCode](https://opencode.ai/) |
| uv global tools | ruff, bump-my-version, pre-commit |
| Python (uv) | 3.9, 3.10, 3.11, 3.12, 3.13, 3.14.5 |
| Shell | `PATH` block in `~/.zshrc` (Warp-compatible) |
| Neovim | Minimal config with Treesitter, Pyright and Ruff |

## Project structure

```text
├── bootstrap.sh          # installs Homebrew + Ansible, then runs the playbook
├── playbook.yml          # idempotent tasks
├── group_vars/all.yml    # package lists (edit here)
├── files/nvim/init.lua   # Neovim config
├── inventory.ini         # localhost only
└── requirements.yml      # community.general collection
```

## Notes

- **OpenCode**: installed via `brew install anomalyco/tap/opencode` ([opencode.ai](https://opencode.ai/)).
- **AWS / Databricks CLI**: managed through Homebrew (`awscli`, `databricks/tap/databricks`).
- **Third-party taps**: Homebrew 6+ requires trusting tap formulae before install.
  The playbook runs `brew trust --formula` for Databricks and OpenCode automatically.
- **Python**: managed entirely with `uv` — versions via `uv python install`, global CLIs via
  `uv tool install`, and project deps via `uv sync` / `uv add`.
- **bumpversion**: installed via [`bump-my-version`](https://github.com/callowayproject/bump-my-version)
  (the maintained successor of `bump2version`); the binary is still `bumpversion`.

## Manual steps (can't be automated)

Some things must be done by hand the first time:

- Complete the Xcode Command Line Tools installer if prompted on first run
  (`xcode-select --install`)
- Grant Accessibility permissions to Rectangle and AltTab
  (*System Settings → Privacy & Security → Accessibility*)
- Sign in to Cursor, Linear, Spotify, NordLayer, Pritunl, Notion, WhatsApp and Chrome
- Generate or copy your SSH/GPG keys
- Start Docker Desktop and accept its terms

## Acknowledgments

- Inspired by [fedejaure/dev-setup](https://github.com/fedejaure/dev-setup) —
  thanks to [Federico Jaureguialzo](https://github.com/fedejaure) for the idea
  and the reference implementation.
- [Homebrew](https://brew.sh/) and the [Ansible `community.general`](https://github.com/ansible-collections/community.general) collection.

## License

Distributed under the MIT License. See [`LICENSE`](LICENSE) for details.
