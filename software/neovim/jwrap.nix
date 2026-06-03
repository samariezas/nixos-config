let
  hasLuaConfig = plugin: plugin ? luacfg;
  getLuaConfig = plugin: plugin.luacfg;
in
{
  mkConfigedPlugin = plugin: luacfg: {
    inherit plugin;
    name = plugin.name;
    luacfg =
      assert !(hasLuaConfig plugin);
      luacfg;
  };
  normalizePlugins =
    plugins: builtins.map (plugin: if hasLuaConfig plugin then plugin.plugin else plugin) plugins;
  getPluginLuaConfigs =
    plugins:
    let
      configurablePlugins = builtins.filter hasLuaConfig plugins;
    in
    builtins.map (plugin: "\n --- ${plugin.name} ---\n\n" + getLuaConfig plugin) configurablePlugins;
}
