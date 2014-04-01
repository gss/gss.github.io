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
    
    # jekyll    
    jekyll:
      dev:
        options:
          config: '_config.yml'
          serve: false
    
    connect:
      dev:
        options:
          port: 4000
          base: "./_site"
          open: true
          keepalive: true

    # Automated recompilation and testing when developing
    watch:
      build:
        files: ['**/*.coffee', '**/*.html', '**/*.md', '**/*.css', '!_site/**/*']
        tasks: ['build']

  # Grunt plugins used for building
  @loadNpmTasks 'grunt-contrib-coffee'
  @loadNpmTasks('grunt-contrib-connect')
  @loadNpmTasks('grunt-jekyll')
  
  #@loadNpmTasks 'grunt-exec'
  @loadNpmTasks 'grunt-contrib-uglify'

  # Grunt plugins used for testing
  @loadNpmTasks 'grunt-contrib-watch'

  # Our local tasks
  @registerTask 'build', ['coffee', 'jekyll']
  
  @registerTask 'serve', ['build','connect']

  #@registerTask 'test', 

  @registerTask 'default', ['build']
