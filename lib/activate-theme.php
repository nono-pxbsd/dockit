<?php
/**
 * Script pour activer un thème PrestaShop
 * Usage: php activate-theme.php <theme_directory>
 */

if ($argc < 2) {
    echo "ERROR: Usage: php activate-theme.php <theme_directory>\n";
    exit(1);
}

$themeDirectory = $argv[1];

// Supprimer les notices PHP
error_reporting(E_ALL & ~E_NOTICE & ~E_WARNING);
ini_set("display_errors", 0);

require_once("/var/www/html/config/config.inc.php");

try {
    // Vérifier que le thème existe
    $themePath = _PS_ROOT_DIR_ . "/themes/{$themeDirectory}";
    if (!is_dir($themePath)) {
        echo "ERROR: Theme directory not found: {$themePath}\n";
        exit(1);
    }

    // Vérifier que theme.yml existe
    $themeYmlPath = "{$themePath}/config/theme.yml";
    if (!file_exists($themeYmlPath)) {
        echo "ERROR: theme.yml not found at {$themeYmlPath}\n";
        exit(1);
    }

    // Lire le theme.yml
    if (!class_exists('Symfony\Component\Yaml\Yaml')) {
        echo "ERROR: Symfony Yaml component not available\n";
        exit(1);
    }

    $themeConfig = \Symfony\Component\Yaml\Yaml::parseFile($themeYmlPath);
    $themeName = $themeConfig['name'] ?? $themeDirectory;

    // Initialiser le kernel Symfony si nécessaire
    global $kernel;
    if (!isset($kernel)) {
        require_once(_PS_ROOT_DIR_ . "/app/AppKernel.php");
        $kernel = new AppKernel("prod", false);
        $kernel->boot();
    }

    // Méthode simple : mettre à jour directement la configuration
    Configuration::updateValue('PS_THEME_NAME', $themeName);

    // Mettre à jour dans la table shop
    $shop = new Shop(1);
    $shop->theme_name = $themeName;
    $shop->theme_directory = $themeDirectory;
    $shop->update();

    // Régénérer le cache du thème
    Tools::clearSmartyCache();
    Tools::clearXMLCache();
    Media::clearCache();

    echo "SUCCESS: Theme '{$themeName}' ({$themeDirectory}) activated successfully\n";
    exit(0);

} catch (Exception $e) {
    echo "ERROR: " . $e->getMessage() . "\n";
    exit(1);
}
