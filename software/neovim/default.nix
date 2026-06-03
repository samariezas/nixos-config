{
  pkgs,
  lib,
  ...
}:
let
  jwrap = import ./jwrap.nix;
  neovim-packages = with pkgs; [
    ripgrep
    jdt-language-server
    rust-analyzer
    clang-tools
    haskell-language-server
    nixd
    nixfmt
    lua-language-server
    cmake-language-server
    zls_0_14
    omnisharp-roslyn

    (python3.withPackages (
      p: with p; [
        python-lsp-server
        python-lsp-jsonrpc
        python-lsp-black
        python-lsp-ruff
        pyls-isort
        pyls-flake8
        flake8
        isort
        black
      ]
    ))
  ];
  neovim-plugins = with pkgs.vimPlugins; [
    nvim-treesitter.withAllGrammars
    undotree
    vim-fugitive
    nvim-lspconfig
    nvim-cmp
    cmp-nvim-lsp
    luasnip # Needed for LSP to work properly

    # with config
    (jwrap.mkConfigedPlugin telescope-nvim ''
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
      vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
      vim.keymap.set('n', '<leader>pas', builtin.live_grep, {})
    '')
    (jwrap.mkConfigedPlugin harpoon2 ''
      local harpoon = require('harpoon')
      harpoon:setup()
      vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end)
      vim.keymap.set('n', '<leader>e', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      vim.keymap.set('n', '<leader>t', function() harpoon:list():select(1) end)
      vim.keymap.set('n', '<leader>y', function() harpoon:list():select(2) end)
      vim.keymap.set('n', '<leader>u', function() harpoon:list():select(3) end)
      vim.keymap.set('n', '<leader>i', function() harpoon:list():select(4) end)
    '')
    (jwrap.mkConfigedPlugin onedark-nvim ''
      local od = require('onedark')
      od.setup {
        style = 'warmer'
      }
    '')
    (jwrap.mkConfigedPlugin midnight-nvim "vim.cmd([[ colorscheme midnight ]])")
  ];
  nvim-wrapped = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
    withPython3 = true;
    luaRcContent = lib.strings.concatStrings (
      [
        (builtins.readFile ./init.lua)
        "\n\n-------- PLUGIN CONFIGS: --------\n\n"
      ]
      ++ jwrap.getPluginLuaConfigs neovim-plugins
    );
    plugins = jwrap.normalizePlugins neovim-plugins;
    runtimeDeps = neovim-packages;
  };
  nvim-wrapped-wrapped =
    pkgs.runCommand "nvim"
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
        meta.mainProgram = "nvim";
      }
      ''
        mkdir -p $out/bin
        install -m +x ${nvim-wrapped}/bin/nvim $out/bin/nvim
        wrapProgram $out/bin/nvim \
            --prefix PATH : ${lib.makeBinPath neovim-packages}
      '';
in
{
  environment.systemPackages = [
    nvim-wrapped-wrapped
  ];
}
