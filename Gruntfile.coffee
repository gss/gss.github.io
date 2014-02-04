module.exports = ->
  # Project configuration
  @initConfig
    pkg: @file.readJSON 'package.json'

    # CoffeeScript compilation
    coffee:
      src:
        options:
          bare: true
        expand: true
        src: ['js/*.coffee']
        ext: '.js'

    ###
    exec:
      main_install:
        command: './node_modules/.bin/component install'
      main_build:
        command: './node_modules/.bin/component build -o browser -n interpolator -c'
      vulcanize:
        command: './node_modules/.bin/vulcanize --csp -o preorder/merged.html preorder/index.html'
    ###

    # JavaScript minification for the browser
    uglify:
      options:
        report: 'min'
      src:
        files:
          './js/script.min.js': ['./js/script.js']

    # Automated recompilation and testing when developing
    watch:
      files: ['**/*.coffee', '**/*.html']
      tasks: ['build']

  # Grunt plugins used for building
  @loadNpmTasks 'grunt-contrib-coffee'
  #@loadNpmTasks 'grunt-exec'
  @loadNpmTasks 'grunt-contrib-uglify'

  # Grunt plugins used for testing
  @loadNpmTasks 'grunt-contrib-watch'

  # Our local tasks
  @registerTask 'build', ['coffee']

  #@registerTask 'test', 

  @registerTask 'default', ['build']
