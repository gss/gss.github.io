module.exports = ->

  @initConfig
    pkg: @file.readJSON 'package.json'

    browserify:
      options:
        alias: [
          'src/signup-form.coffee:signup-form'
          'src/view.coffee:signup-form-view'
          'src/view-model.coffee:signup-form-view-model'
        ]
        transform: [
          'coffeeify'
        ]
        browserifyOptions:
          extensions: '.coffee'
        verbose: true
      compile:
        src: 'src/**/*.coffee'
        dest: 'index.js'

    clean:
      spec:
        src: ['spec/**/*.js']

    coffee:
      spec:
        options:
          bare: true
        expand: true
        cwd: 'spec'
        src: ['**/*.coffee']
        dest: 'spec'
        ext: '.js'

    connect:
      server:
        options:
          port: 8000
          base: '.'


    mocha_phantomjs:
      all:
        options:
          urls: [
            'http://localhost:8000/spec/runner.html'
          ]

    watch:
      scripts:
        files: [
          'src/**/*.coffee'
        ]
        tasks: [
          'build'
        ]


  @loadNpmTasks 'grunt-browserify'
  @loadNpmTasks 'grunt-contrib-clean'
  @loadNpmTasks 'grunt-contrib-coffee'
  @loadNpmTasks 'grunt-contrib-connect'
  @loadNpmTasks 'grunt-contrib-watch'
  @loadNpmTasks 'grunt-mocha-phantomjs'


  @registerTask 'build', ['browserify']
  @registerTask 'test', ['build', 'coffee', 'connect', 'mocha_phantomjs', 'clean']
