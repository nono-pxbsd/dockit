<?php
/**
 * Script pour importer les types d'images depuis un theme.yml
 * Usage: php import-theme-image-types.php <theme_name>
 */

if ($argc < 2) {
    echo "ERROR: Usage: php import-theme-image-types.php <theme_name>\n";
    exit(1);
}

$themeName = $argv[1];

// Supprimer les notices PHP
error_reporting(E_ALL & ~E_NOTICE & ~E_WARNING);
ini_set("display_errors", 0);

require_once("/var/www/html/config/config.inc.php");

try {
    $themeYmlPath = _PS_ROOT_DIR_ . "/themes/{$themeName}/config/theme.yml";

    if (!file_exists($themeYmlPath)) {
        echo "ERROR: theme.yml not found at {$themeYmlPath}\n";
        exit(1);
    }

    // Lire et parser le fichier YAML (PrestaShop 8.x a Symfony Yaml component)
    if (!class_exists('Symfony\Component\Yaml\Yaml')) {
        echo "ERROR: Symfony Yaml component not available\n";
        exit(1);
    }

    $themeConfig = \Symfony\Component\Yaml\Yaml::parseFile($themeYmlPath);

    if (!isset($themeConfig['global_settings']['image_types'])) {
        echo "ERROR: No image_types found in theme.yml\n";
        exit(1);
    }

    $imageTypes = $themeConfig['global_settings']['image_types'];
    $imported = 0;
    $skipped = 0;

    foreach ($imageTypes as $name => $config) {
        // Vérifier si le type d'image existe déjà
        $existingId = ImageType::getByNameNType($name);

        if ($existingId) {
            $skipped++;
            continue;
        }

        // Créer le nouveau type d'image
        $imageType = new ImageType();
        $imageType->name = $name;
        $imageType->width = $config['width'];
        $imageType->height = $config['height'];

        // Configurer les scopes (products, categories, manufacturers, suppliers)
        $imageType->products = in_array('products', $config['scope']) ? 1 : 0;
        $imageType->categories = in_array('categories', $config['scope']) ? 1 : 0;
        $imageType->manufacturers = in_array('manufacturers', $config['scope']) ? 1 : 0;
        $imageType->suppliers = in_array('suppliers', $config['scope']) ? 1 : 0;
        $imageType->stores = in_array('stores', $config['scope']) ? 1 : 0;

        if ($imageType->add()) {
            $imported++;
        }
    }

    echo "SUCCESS: Imported {$imported} image types, skipped {$skipped} existing ones\n";
    exit(0);

} catch (Exception $e) {
    echo "ERROR: " . $e->getMessage() . "\n";
    exit(1);
}
