from homely.files import mkdir, symlink
from homely.install import installpkg
from homely.ui import head, yesno


# Install packages
PKGS = [
    'awscli',
    'azure-cli',
    'ccls',
    'cmake',
    'coreutils',
    'ctags',
    'fzf',
    'gettext',
    'git',
    'ipmitool',
    'jq',
    'libevent',
    'libffi',
    'libyaml',
    'llvm',
    'ncurses',
    'neovim',
    'nmap',
    'openssl',
    'pyenv',
    'pyenv-virtualenv',
    'readline',
    'reattach-to-user-namespace',
    'screenfetch',
    'shellcheck',
    'sshpass',
    'tmux',
    'tree',
    'vim',
    'wget',
    'yarn',
    'zsh-autosuggestions',
    'zsh-syntax-highlighting',
    'zstd',
]

if yesno(name=None, prompt='Install packages?', default=False, recommended=True, noprompt=True):
    with head('Installing packages'):
        for pkg in PKGS:
            installpkg(pkg)


# Create dirs
DIRS = [
    '~/.config',
    '~/.config/nvim',
]

with head('Creating config dirs'):
    for _dir in DIRS:
        mkdir(_dir)

# Link config files
LINKS = [
    ('vim/.vimrc', '~/.vimrc'),
    ('nvim/init.vim', '~/.config/nvim/init.vim'),
    ('nvim/coc-settings.json', '~/.config/nvim/coc-settings.json'),
    ('zsh/.zshrc', '~/.zshrc'),
    ('git/.gitconfig', '~/.gitconfig'),
    ('git/.gitignore_global', '~/.gitignore_global'),
    ('tmux/.tmux.conf', '~/.tmux.conf'),
]

with head('Linking config files'):
    for target, link in LINKS:
        symlink(target, link)

# Installing oh-my-zsh
cmd = 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"'

