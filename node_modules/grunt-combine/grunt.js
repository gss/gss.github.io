/*
 * grunt-combine
 */
module.exports = function(grunt) {

  "use strict";

  // Project configuration.
  grunt.initConfig({
    test: {
      files: ['test/**/*.js']
    },
    lint: {
      files: ['grunt.js', 'tasks/**/*.js', 'test/**/*.js']
    },
    watch: {
      files: '<config:lint.files>',
      tasks: 'default'
    },
    jshint: {
      options: {
        curly: true,
        eqeqeq: true,
        immed: true,
        latedef: true,
        newcap: true,
        noarg: true,
        sub: true,
        undef: true,
        boss: true,
        eqnull: true,
        node: true,
        es5: true
      },
      globals: {}
    },
    combine: {
      identical: {
        input: "test/inputs/input_d.txt",
        output: "test/outputs/output_d.txt",
        tokens: [{
          token: "{{identical}}",
          string: "bar"
        }]
      },
      single: {
        input: "test/inputs/input_a.txt",
        output: "test/outputs/output_a.txt",
        tokens: [{
          token: "<%!fox%>",
          file: "test/files/fox.txt"
        }, {
          token: "{{quick}}",
          file: "test/files/quick.html"
        }, {
          token: "{{dog}}",
          file: "test/files/dog.css"
        }, {
          token: "{{brown}}",
          string: "brown"
        }]
      },
      multiple: {
        input: ["test/inputs/input_b.txt", "test/inputs/input_c.txt"],
        output: "test/outputs/",
        tokens: [{
          token: "{{fox}}",
          file: "test/files/fox.txt"
        }, {
          token: "{{hairy}}",
          string: "hairy"
        }]
      }
    }
  });

  // Load local tasks.
  grunt.loadTasks('tasks');

  // Default task.
  grunt.registerTask('default', ['lint', 'combine:single', 'combine:multiple','combine:identical', 'test']);

};