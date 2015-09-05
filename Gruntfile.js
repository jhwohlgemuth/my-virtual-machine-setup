module.exports = function(grunt) {
    'use strict';
    grunt.initConfig({
        encryptedDirectory: 'vault',
        encryptedExtension: '.protected',

        /**
         * Clear files and folders
         * @see {@link https://github.com/gruntjs/grunt-contrib-clean}
         **/
        clean: {
            plain:  [
                '<%= encryptedDirectory %>/*',
                '!<%= encryptedDirectory %>/*<%= encryptedExtension %>',
                '!<%= encryptedDirectory %>/README.md'
            ],
            cipher: [
                '<%= encryptedDirectory %>/*<%= encryptedExtension %>'
            ]
        },

        /**
         * Encrypt and decrypt files located in the vault directory (performed in place)
         * @see {@link https://github.com/openhoat/grunt-contrib-crypt}
         **/
        crypt:{
            options: {
                key: grunt.cli.options.key || 'password'
            },
            files: [
                {
                    dir: '<%= encryptedDirectory %>',
                    include: '**/!(README.md|README.MD)',
                    encryptedExtension: '<%= encryptedExtension %>'
                }
            ]
        },

        /**
         * Plugin built on top of replace, for performing search and replace on files.
         * @see {@link https://github.com/jharding/grunt-sed}
         **/
        sed: {
            mongo: {
                path: 'Vagrantfile',
                pattern: 'inline: [$]install_mongo',
                replacement: 'inline: $install_mongo'
            },
            redis: {
                path: 'Vagrantfile',
                pattern: 'inline: [$]install_.*',
                replacement: 'inline: $install_redis'
            },
            couch: {
                path: 'Vagrantfile',
                pattern: 'inline: [$]install_mongo',
                replacement: 'inline: $install_couch'
            }
        }
    });
    grunt.task.loadNpmTasks('grunt-contrib-clean');
    grunt.task.loadNpmTasks('grunt-contrib-crypt');
    grunt.task.loadNpmTasks('grunt-sed');
    grunt.registerTask('lock',    ['encrypt', 'clean:plain']);
    grunt.registerTask('unlock',  ['decrypt', 'clean:cipher']);
};