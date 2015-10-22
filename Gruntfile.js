var inquirer = require('inquirer');
module.exports = function(grunt) {
    'use strict';
    require('load-grunt-tasks')(grunt); //Plugin for loading external task files
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
            ],
            box: ['box']
        },

        /**
         * Encrypt and decrypt files located in the encrypted directory (performed in place)
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
        }
    });
    grunt.registerTask('lock',   ['encrypt', 'clean:plain']);
    grunt.registerTask('unlock', ['decrypt', 'clean:cipher']);
};