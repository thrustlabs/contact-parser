module.exports = (grunt) ->
  grunt.initConfig
    appDir: "."
    srcDir: "<%= appDir %>/src"
    testDir: "<%= appDir %>/spec"
    buildDir: "<%= appDir %>/tmp/build"
    outputDir: "<%= appDir %>/dist"

    coffee:
      options:
        bare: true
      all:
        files: [
          expand: true,
          src: ["<%= srcDir %>/**/*.coffee", "<%= testDir %>/**/*.coffee"]
          dest: "<%= buildDir %>"
          ext: ".js"
        ]


    watch:
      coffee:
        files: ["<%= srcDir %>/**/*.coffee", "<%= testDir %>/**/*.coffee"]
        tasks: ["js"]


    jasmine_node:
      options:
        forceExit: true,
        match: '.',
        matchall: false,
        extensions: 'js',
        specNameMatcher: 'spec',
        jUnit:
          report: true,
          savePath : "<%= buildDir %>/reports/jasmine/",
          useDotNotation: true,
          consolidate: true
      all: ["<%= buildDir %>/spec/"]

    clean:
      build: "<%= buildDir %>"
      output: "<%= outputDir %>"

    copy:
      js:
        files: [
          expand: true
          cwd: "<%= buildDir %>/src"
          src: ["**/*.js"]
          dest: "<%= outputDir %>"
        ]


  grunt.registerTask "js", ["coffee:all", "jasmine_node:all"]
  grunt.registerTask "default", ["clean", "js", "copy"]

  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-jasmine-node-new"
  grunt.loadNpmTasks "grunt-contrib-copy"
