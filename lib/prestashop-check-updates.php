<?php
/**
 * Script pour détecter les mises à jour de modules PrestaShop via l'API Addons
 * Utilise les services PrestaShop officiels (Symfony + AdminModuleDataProvider)
 *
 * Output format: name|displayName|currentVersion|availableVersion
 */

error_reporting(0);
ini_set("display_errors", 0);

require_once("/var/www/html/config/config.inc.php");

try {
    // Initialiser le kernel Symfony pour accéder aux services
    global $kernel;
    if (!isset($kernel)) {
        require_once(_PS_ROOT_DIR_ . "/app/AppKernel.php");
        $kernel = new AppKernel("prod", false);
        $kernel->boot();
    }

    $container = $kernel->getContainer();

    // Récupérer le service AdminModuleDataProvider
    $moduleProvider = $container->get("prestashop.core.admin.data_provider.module_interface");

    if (!$moduleProvider) {
        echo "ERROR:Cannot access module provider service";
        exit(1);
    }

    // Récupérer les modules installés
    $installedModules = Module::getModulesInstalled();

    // Récupérer le catalogue depuis Addons API
    $catalogModules = $moduleProvider->getCatalogModules();

    // Identifier les mises à jour disponibles
    foreach ($installedModules as $installed) {
        $moduleName = $installed["name"];
        $moduleObj = Module::getInstanceByName($moduleName);

        if (!$moduleObj) {
            continue;
        }

        $currentVersion = $moduleObj->version;
        $displayName = $moduleObj->displayName;

        // Vérifier si le module existe dans le catalogue
        if (isset($catalogModules[$moduleName])) {
            $catalog = $catalogModules[$moduleName];

            // Vérifier si une mise à jour est disponible
            if (isset($catalog->version_available) &&
                version_compare($catalog->version_available, $currentVersion, ">")) {

                // Format: name|displayName|currentVersion|availableVersion
                echo $moduleName . "|" .
                     $displayName . "|" .
                     $currentVersion . "|" .
                     $catalog->version_available . "\n";
            }
        }
    }
} catch (Exception $e) {
    echo "ERROR:" . $e->getMessage();
    exit(1);
}
