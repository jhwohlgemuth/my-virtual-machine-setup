var inquirer = require('inquirer');
module.exports = function(grunt) {
    'use strict';
    grunt.initConfig({
        address: {
            web: '10.10.10.10',
            db:  '10.10.10.11'
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
            ssh: 'ssh -f -L localhost:5984:127.0.0.1:5984 vagrant@<%= address.db %> -N',
            npm: ''
        }
    });
    grunt.task.loadNpmTasks('grunt-contrib-clean');
    grunt.task.loadNpmTasks('grunt-contrib-crypt');
    grunt.task.loadNpmTasks('grunt-sed');
    grunt.task.loadNpmTasks('grunt-exec');
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