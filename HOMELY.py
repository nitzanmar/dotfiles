from homely.files import mkdir, symlink
from homely.install import installpkg
from homely.ui import head, note
from homely.system import execute


# Install packages
PKGS = [
    #'awscli',
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
    'zsh',
    'zsh-completions',
    'zsh-autosuggestions',
    'zsh-syntax-highlighting',
    'zstd',
]

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
    ('kitty/kitty.conf', '~/.config/kitty.conf'),
]

with head('Linking config files'):
    for target, link in LINKS:
        symlink(target, link)

# Install oh-my-zsh
# cmd = 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended'
# cmd = 'chsh -s /bin/zsh'

# Install nvim plugins
with head('Configuring neovim'):
    # cerate python2 and python3 venvs for neovim and install neovim
    # details: https://github.com/deoplete-plugins/deoplete-jedi/wiki/Setting-up-Python-for-Neovim
    # python_path = a = execute(['which', 'python'], stdout=True, stderr=True)
    # (0, b'/Users/nizanmargalit/.pyenv/versions/3.7.4/bin/python\n', b'')

    # to install neovim package use pipinstall from homely

    note('Installing neovim plugins')
    cmd = ['nvim', '+PlugInstall', '+qa']
    execute(cmd)

