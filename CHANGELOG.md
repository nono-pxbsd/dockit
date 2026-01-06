# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-01-06

### Added
- Initial project structure with bin/, lib/, templates/
- PrestaShop environment generator (`prestashop-env`)
- Docker Compose configuration for PrestaShop stack
- Multi-version PrestaShop support (1.7.x to 9.x)
- Basic CLI interface (`dockit`)
- **Module auto-update system**: New CLI tool `prestashop-module-update` to automatically detect and update PrestaShop modules via Addons API
- **Auto mode**: `--auto` / `-y` flag for non-interactive environment setup
- **PHP extensions manager**: Interactive selection of PHP extensions with fzf, using mlocati/docker-php-extension-installer
- **Theme auto-detection**: Automatically selects correct theme (classic for 1.7.x, hummingbird for 8.x+)
- **Extended environment variables**: Added PHP_EXTENSIONS, THEME_NAME, UID/GID, database and admin credentials to .env
- **implode() helper**: New utility function for joining array elements

### Changed
- **PrestaShop download**: Now downloads from GitHub source tags instead of release packages
- **Docker setup**: Switched to Apache with PHP-FPM proxy configuration for better performance
- **PHP Docker image**: Now uses install-php-extensions for cleaner extension management

### Fixed
- **Docker permissions**: Added UID/GID support to all containers to prevent permission issues
- **sed escaping**: Fixed special character handling in environment variable generation
- **Log paths**: Corrected log directory paths for mailpit and node containers
