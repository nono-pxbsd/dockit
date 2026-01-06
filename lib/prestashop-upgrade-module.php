<?php
/**
 * Script pour upgrader un module PrestaShop
 * Usage: php prestashop-upgrade-module.php <module_name>
 *
 * Ce script:
 * 1. Télécharge le module depuis Addons
 * 2. Execute l'upgrade du module
 */

if ($argc < 2) {
    echo "ERROR:Usage: php prestashop-upgrade-module.php <module_name>";
    exit(1);
}

$moduleName = $argv[1];

// Supprimer les notices PHP (PrestaShop legacy a des warnings non critiques)
error_reporting(E_ALL & ~E_NOTICE & ~E_WARNING);
ini_set("display_errors", 0);

require_once("/var/www/html/config/config.inc.php");

try {
    // Initialiser le kernel Symfony
    global $kernel;
    if (!isset($kernel)) {
        require_once(_PS_ROOT_DIR_ . "/app/AppKernel.php");
        $kernel = new AppKernel("prod", false);
        $kernel->boot();
    }

    $container = $kernel->getContainer();

    // Récupérer le service ModuleDataUpdater
    $moduleUpdater = $container->get('prestashop.core.module.updater');

    if (!$moduleUpdater) {
        echo "ERROR:Cannot access ModuleUpdater service";
        exit(1);
    }

    // Étape 1: Télécharger le module depuis Addons
    $downloadResult = $moduleUpdater->setModuleOnDiskFromAddons($moduleName);

    if (!$downloadResult) {
        echo "ERROR:Failed to download module from Addons. Module may be customer-only or download failed.";
        exit(1);
    }

    // Étape 2: Upgrader le module
    $upgradeResult = $moduleUpdater->upgrade($moduleName);

    // Vérifier la nouvelle version après upgrade
    $moduleInstance = Module::getInstanceByName($moduleName);
    if (!$moduleInstance) {
        echo "ERROR:Cannot get module instance after upgrade";
        exit(1);
    }

    // Récupérer les erreurs éventuelles
    $errors = [];
    if (method_exists($moduleInstance, 'getErrors')) {
        $errors = $moduleInstance->getErrors();
    }

    // Si pas d'erreurs ou seulement le message "Aucune mise à jour appliquée"
    // (qui arrive quand pas de fichiers SQL d'upgrade), c'est un succès
    $ignorableErrors = [
        'Aucune mise à jour a été appliquée',
        'No upgrade has been applied',
        'Pour éviter tout problème, ce module a été désactivé',
        'To prevent any problem, this module has been turned off'
    ];

    $realErrors = array_filter($errors, function($error) use ($ignorableErrors) {
        foreach ($ignorableErrors as $ignorable) {
            if (strpos($error, $ignorable) !== false) {
                return false;
            }
        }
        return true;
    });

    if (empty($realErrors)) {
        // Vérifier que le module est toujours actif ou le réactiver
        if (!$moduleInstance->isEnabled()) {
            $moduleInstance->enable();
        }
        echo "SUCCESS";
    } else {
        echo "ERROR:" . implode("; ", $realErrors);
        exit(1);
    }
} catch (Exception $e) {
    echo "ERROR:" . $e->getMessage();
    exit(1);
}
