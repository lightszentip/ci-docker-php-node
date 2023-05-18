# ci-docker-php-node

Images under: https://hub.docker.com/r/lightszentip/ci-docker-php-node

CI Docker container for gitlab ci and github runner

This Repository build each day the current version of the dockerfile for the php versions 7.4,8,8.1 and 8.2

The image can use in each gitlab-ci and github action pipeline to build php apps with composer and npm

The image has the following functions:



* Composer v2 https://getcomposer.org/
* LTS Node https://nodejs.org/en/
* Latest NPM Version
* PHP Version depend on image version
