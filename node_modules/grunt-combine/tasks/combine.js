/*
 * grunt-combine
 * https://github.com/mcgaryes/grunt-combine
 * https://github.com/gruntjs/grunt/
 *
 * Copyright (c) 2013 Eric McGary
 * Licensed under the MIT license.
 *
 * @main grunt-combine
 */
module.exports = function(grunt) {

    "use strict";

    var _ = require("underscore");
    var fs = require('fs');

    var starttime = (new Date()).getTime();
    var processedFiles = 0;
    var processed = 0;
    var tokens;
    var input = [];
    var fileContents = [];
    var output;
    var outputIsPath;
    var done;
    var timer;
    var cwd;

    /**
     * Main task kick-off functionality
     *
     * @for grunt-combine
     * @method registerMultiTask
     */
    grunt.registerMultiTask('combine', 'Combine files with token based search and replace functionality.', function() {

        // set vars
        done = this.async();
        cwd = this.data.cwd;
        output = this.data.output;
        outputIsPath = output.charAt(output.length - 1) === '/';
        tokens = this.data.tokens;
        input = [];
        fileContents = [];

        // user input is an array - treat output as a path
        if(_.isArray(this.data.input)) {
            input = this.data.input;
            if(!outputIsPath) {
                grunt.fail.warn('With multiple inputs the output must be a folder.');
            }
        } else {
            input[0] = this.data.input;
        }

        // load the input file as text
        _.each(input, function(elem, index) {
            // check to make sure that we have everything that we need before continuing
            if(_.isUndefined(elem)) {
                grunt.fail.warn('You must specify an input/output.');
            }

            var path = cwd ? cwd + elem : elem;

            fs.readFile(path, 'utf8', function(e, data) {
                if(e) {
                    grunt.fail.warn('There was an error processing the input file.');
                }

                // run through each of the replacements and load the files if needed. Replace the
                // replacement with the files contents if it happens to be a file
                grunt.log.writeln('Processing Input: ' + (elem).cyan);
                fileContents[index] = data;

                // now process all of out replacements
                processed = 0;
                processTokens(index);
            });
        });

        // timeout the task if we've taken too long
        // @TODO: Should this be another prop that the dev can pass?
        timer = setTimeout(function() {
            grunt.fail.warn('The task has timed out.');
        }, 10000);

        /**
         * Processes all of the passed replacements
         * @for grunt-combine
         * @method processReplacements
         */
        var processTokens = function(inputIndex) {

            _.each(tokens, function(token, index) {
                // determain whether or not this is a file reference or a string
                if(token.file) {

                    // read the file and reset replacement to what was loaded
                    fs.readFile(token.file, 'utf8', function(e, data) {
                        if(e) {
                            grunt.fail.warn("There was an error processing the replacement '" + token.file + "' file.");
                        }
                        tokens[index].contents = data;
                        processTokenCompleteCallback();
                    });

                } else if(token.string) {
                    // we didn't need to load a file
                    tokens[index].contents = token.string;
                    processTokenCompleteCallback();
                } else {
                    processTokenCompleteCallback();
                }

            }, this);
        };

        /**
         * Process completion callback. When all replacements have been processed the actual
         * combining of files takes place.
         * @for grunt-combine
         * @method processTokenCompleteCallback
         */
        var processTokenCompleteCallback = function() {
            processed++;
            if(processed === tokens.length) {
                findAndReplaceTokens();
            }
        };

        /**
         * Looks for the specified token and replaces it with the next replacement
         * in the replacements array.
         * @for grunt-combine
         * @method findAndReplaceTokens
         */
        var findAndReplaceTokens = function() {
            _.each(fileContents, function(fileContent, index) {
                var f = fileContent;
                _.each(tokens, function(token) {
                    if(token.contents !== undefined) {

                        // replace all occurances of the token
                        var pattern = token.token;
                        var re = new RegExp(pattern, "gm");
                        f = f.replace(re, token.contents);

                    } else {
                        grunt.log.writeln("Replacement failed for token '" + token.token + "'.");
                    }
                });
                fileContents[index] = f;
                writeOutput(index);
            });

        };

        /**
         * Writes the processed input file to the specified output name.
         * @for grunt-combine
         * @method findAndReplaceTokens
         */
        var writeOutput = function(inputIndex) {

            var inputPath = input[inputIndex].split("/");
            inputPath = inputPath[inputPath.length - 1];
            var path = outputIsPath ? output + inputPath : output;

            // write the input string to the output file name
            grunt.log.writeln('Writing Output: ' + (path).cyan);
            fs.writeFile(path, fileContents[inputIndex], 'utf8', function(err) {
                //console.log(fileContents[inputIndex]);
                if(err) {
                    clearTimeout(timer);
                    grunt.fail.warn("Could not write output '" + output + "' file.");
                }
                processedFiles++;
                if(processedFiles === fileContents.length) {
                    processedFiles = 0;
                    fileContents = [];

                    var endtime = (new Date()).getTime();
                    grunt.log.writeln('Combine task completed in ' + ((endtime - starttime) / 1000) + ' seconds');
                    clearTimeout(timer);

                    done();
                }
            });
        };
    });

};