var inquirer = require('inquirer');
module.exports = function(grunt) {
    'use strict';
    require('load-grunt-tasks')(grunt); //Plugin for loading external task files
    grunt.initConfig({
        address: {
            web: '10.10.10.10',
            db:  '10.10.10.11'
        },
        ports: {
            mongo: '27017',
            redis: '6379',
            commander: '8081',
            couch: '5984'
        },
        regex: 'path: \'bin\/install_.*[.]sh',
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
         * Open files in browsers for review
         * @see {@link https://github.com/jsoverson/grunt-open}
         **/
        open: {
            futon: {
                path: 'http://localhost:<%= ports.couch %>/_utils/',
                app: 'Chrome'
            }
        },

        /**
         * Plugin built on top of replace, for performing search and replace on files.
         * @see {@link https://github.com/jharding/grunt-sed}
         **/
        sed: {
            mongodb: {
                path: 'Vagrantfile',
                pattern: '<%= regex %>',
                replacement: 'path: \'bin\/install_mongodb.sh'
            },
            redis: {
                path: 'Vagrantfile',
                pattern: '<%= regex %>',
                replacement: 'path: \'bin\/install_redis.sh'
            },
            couchdb: {
                path: 'Vagrantfile',
                pattern: '<%= regex %>',
                replacement: 'path: \'bin\/install_couchdb.sh'
            }
        },

        /**
         * Plugin for executing shell commands.
         * @see {@link https://github.com/jharding/grunt-exec}
         **/
        exec: {
            couch: 'ssh -f -L localhost:5984:127.0.0.1:5984 vagrant@<%= address.db %> -N',
            npmjs: ''
        }
    });
    grunt.registerTask('setup', function(){
        var done = this.async();
        inquirer.prompt([
            {
                type: "list",
                name: "datastore",
                message: "Which datastore do you want to use?",
                choices: [
                    "MongoDB",
                    "redis",
                    "CouchDB"
                ]
            }
        ], function(answer) {
            grunt.task.run(['sed:' + answer.datastore.toLowerCase()]);
            done(true);
        });
    });
    grunt.registerTask('lock',    ['encrypt', 'clean:plain']);
    grunt.registerTask('unlock',  ['decrypt', 'clean:cipher']);
};