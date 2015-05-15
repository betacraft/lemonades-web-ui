// edited by akshay deo
'use strict';

module.exports = function (grunt) {

  // Load grunt tasks automatically, when needed
  require('jit-grunt')(grunt, {
    useminPrepare: 'grunt-usemin',
    ngtemplates: 'grunt-angular-templates',
    cdnify: 'grunt-google-cdn',
    protractor: 'grunt-protractor-runner',
    injector: 'grunt-asset-injector',
    buildcontrol: 'grunt-build-control',
    ngconstant: 'grunt-ng-constant'
  });

  // Configurable paths for the application
  var appConfig = {
    // configurable paths
    //client: require('./bower.json').appPath || 'client',
    app: require('./bower.json').appPath || 'app',
    dist: 'dist'
  };

  // Time how long tasks take. Can help when optimizing build times
  require('time-grunt')(grunt);

  // Define the configuration for all the tasks
  grunt.initConfig({
    // Project settings
    pkg: grunt.file.readJSON('package.json'),
    yeoman: appConfig,
    watch: {
      bower: {
        files: ['bower.json'],
        tasks: ['wiredep']
      },
      coffee: {
        files: [
          '<%= yeoman.app %>/scripts/**/*.{coffee,litcoffee,coffee.md}',
          '!<%= yeoman.app %>/scripts/**/*.spec.{coffee,litcoffee,coffee.md}'
        ],
        tasks: ['newer:coffee:dist']
      },
      styles: {
        files: ['<%= yeoman.app %>/styles/{,*/}*.css'],
        tasks: ['newer:copy:styles', 'autoprefixer']
      },
      jade: {
        files: ['<%= yeoman.app %>/views/{,*/}*.jade', '<%= yeoman.app %>/*.jade'],
        tasks: ['jade:server']
      },
      gruntfile: {
        files: ['Gruntfile.js']
      },
      livereload: {
        files: [
          '.tmp/{,*/}*.html',
          '<%= yeoman.app %>/styles/{,*/}*.css',
          '.tmp/scripts/{,*/}*.js',
          '<%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
        ],
        options: {
          livereload: true
        }

      }
    },

    jade: {
      options: {
        pretty: true
      },
      server: {
        files: [{
          expand: true,
          cwd: '<%= yeoman.app %>',
          dest: '.tmp',
          src: ['*.jade', 'views/{,*/}*.jade'],
          ext: '.html'
        }]
      },
      dist: {
        files: [{
          expand: true,
          cwd: '<%= yeoman.app %>',
          dest: '<%= yeoman.dist %>',
          src: ['views/{,*/}*.jade'],
          ext: '.html'
        }, {
          expand: true,
          cwd: '<%= yeoman.app %>',
          dest: '<%= yeoman.dist %>',
          src: ['*.jade'],
          ext: '.html'
        }]
      }
    },

    // The actual grunt server settings
    connect: {
      options: {
        port: 9000,
        // Change this to '0.0.0.0' to access the server from outside.
        hostname: 'localhost',
        livereload: 35729
      },
      livereload: {
        options: {
          open: true,
          middleware: function (connect) {
            return [
              connect.static('.tmp'),
              connect().use(
                '/bower_components',
                connect.static('./bower_components')
              ),
              connect().use(
                '/app/styles',
                connect.static('./app/styles')
              ),
              connect.static(appConfig.app)
            ];
          }
        }
      },
      dist: {
        options: {
          open: true,
          base: '<%= yeoman.dist %>'
        }
      }
    },


    // Make sure code styles are up to par and there are no obvious mistakes
    jshint: {
      options: {
        jshintrc: '.jshintrc',
        reporter: require('jshint-stylish')
      },
      all: [
        'Gruntfile.js',
        '.tmp/scripts/{,*/}*.js'
      ]
    },

    // Empties folders to start fresh
    clean: {
      dist: {
        files: [{
          dot: true,
          src: [
            '.tmp',
            '<%= yeoman.dist %>/*',
            '!<%= yeoman.dist %>/.git*',
            '!<%= yeoman.dist %>/.openshift',
            '!<%= yeoman.dist %>/Procfile'
          ]
        }]
      },
      server: '.tmp'
    },

    // Add vendor prefixed styles
    autoprefixer: {
      options: {
        browsers: ['last 1 version']
      },
      server: {
        options: {
          map: true
        },
        files: [{
          expand: true,
          cwd: '.tmp/styles/',
          src: '{,*/}*.css',
          dest: '.tmp/styles/'
        }]
      },
      dist: {
        files: [{
          expand: true,
          cwd: '.tmp/styles/',
          src: '{,*/}*.css',
          dest: '.tmp/styles/'
        }]
      }
    },

    // Automatically inject Bower components into the app
    wiredep: {
      app: {
        src: ['.tmp/index.html'],
        ignorePath: /\.\.\//
      }
    },

    // Renames files for browser caching purposes
    filerev: {
      dist: {
        src: [
          '<%= yeoman.dist %>/scripts/{,*/}*.js',
          '<%= yeoman.dist %>/styles/{,*/}*.css',
          '<%= yeoman.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}',
          '<%= yeoman.dist %>/styles/fonts/*'
        ]
      }
    },

    // Compiles CoffeeScript to JavaScript
    coffee: {
      options: {
        sourceMap: true,
        sourceRoot: ''
      },
      server: {
        files: [{
          expand: true,
          cwd: '<%= yeoman.app %>',
          src: [
            'scripts/app.coffee',
            'scripts/**/*.coffee'
            //'!{app,components}/**/*.spec.coffee'
          ],
          dest: '.tmp',
          ext: '.js'
        }]
      },
      dist: {
        files: [{
          expand: true,
          cwd: '<%= yeoman.app %>',
          src: [
            'scripts/app.coffee',
            'scripts/**/*.coffee'
            //'!{app,components}/**/*.spec.coffee'
          ],
          dest: '.tmp',
          ext: '.js'
        }]
      }
    },

    // Reads HTML for usemin blocks to enable smart builds that automatically
    // concat, minify and revision files. Creates configurations in memory so
    // additional tasks can operate on them
    useminPrepare: {
      html: ['<%= yeoman.dist %>/index.html'],
      options: {
        dest: '<%= yeoman.dist %>',
        flow: {
          html: {
            steps: {
              js: ['concat', 'uglifyjs'],
              css: ['cssmin']
            },
            post: {}
          }
        }
      }
    },

    // Performs rewrites based on filerev and the useminPrepare configuration
    usemin: {
      html: ['<%= yeoman.dist %>/{,*/}*.html',
        '<%= yeoman.dist %>/views/{,*/}*.html'],
      css: ['<%= yeoman.dist %>/{,*/}*.css'],
      options: {
        assetsDirs: [
          '<%= yeoman.dist %>',
          '<%= yeoman.dist %>/images',
          '<%= yeoman.dist %>/styles'
        ]
      }
    },

    htmlmin: {
      dist: {
        options: {
          collapseWhitespace: true,
          conservativeCollapse: true,
          collapseBooleanAttributes: true,
          removeCommentsFromCDATA: true,
          removeOptionalTags: true
        },
        files: [{
          expand: true,
          cwd: '<%= yeoman.dist %>',
          src: ['*.html', 'views/{,*/}*.html'],
          dest: '<%= yeoman.dist %>'
        }]
      }
    },

    //// The following *-min tasks produce minified files in the dist folder
    cssmin: {
      options: {
        root: '<%= yeoman.app %>'
      },
      dist: {
        files: [{
          '<%= yeoman.dist %>/styles/main.css': [
            '<%= yeoman.app %>/styles/flatty.css',
            '<%= yeoman.app %>/styles/bootstrapOverwrite.css',
            '<%= yeoman.app %>/styles/custom.css',
            '<%= yeoman.app %>/styles/font.css'
          ]
        },
          {
            '<%= yeoman.dist %>/styles/vendor.css': [
              'bower_components/bootstrap/dist/css/bootstrap.min.css',
              'bower_components/ngtoast/dist/ngToast.min.css',
              'bower_components/ngtoast/dist/ngToast-animations.min.css'
            ]
          }]
      }
    },

    // The following *-min tasks produce minified files in the dist folder
    imagemin: {
      dist: {
        files: [{
          expand: true,
          cwd: '<%= yeoman.app %>/images',
          src: '{,*/}*.{png,jpg,jpeg,gif}',
          dest: '<%= yeoman.dist %>/images'
        }]
      }
    },

    svgmin: {
      dist: {
        files: [{
          expand: true,
          cwd: '<%= yeoman.app %>/images',
          src: '{,*/}*.svg',
          dest: '<%= yeoman.dist %>/images'
        }]
      }
    },

    // Allow the use of non-minsafe AngularJS files. Automatically makes it
    // minsafe compatible so Uglify does not destroy the ng references
    ngAnnotate: {
      dist: {
        files: [{
          expand: true,
          cwd: '.tmp/concat/scripts',
          src: 'app.js',
          dest: '.tmp/concat/scripts'
        }]
      }
    },

    cdn: {
      options: {
        /** @required - root URL of your CDN (may contains sub-paths as shown below) */
        cdn: 'http://cdn.groupup.in',
        /** @optional  - if provided both absolute and relative paths will be converted */
        flatten: true
      },
      dist: {
        /** @required  - gets sources here, may be same as dest  */
        cwd: '<%= yeoman.dist %>',
        /** @required  - puts results here with respect to relative paths  */
        dest: '<%= yeoman.dist %>',
        /** @required  - files to process */
        src: ['index.html', 'styles/*.css', 'views/*.html']
      }
    },

    // Replace Google CDN references
    cdnify: {
      dist: {
        html: ['<%= yeoman.dist %>/*.html']
      }
    },

    // Copies remaining files to places other tasks can use
    copy: {
      dist: {
        files: [{
          expand: true,
          dot: true,
          cwd: '<%= yeoman.app %>',
          dest: '<%= yeoman.dist %>',
          src: [
            '*.{ico,png,txt}',
            '.htaccess',
            'images/{,*/}*.{webp}',
            'fonts/**/*',
            'views/{,*/}*.html',
          ]
        }, {
          expand: true,
          cwd: '.tmp/images',
          dest: '<%= yeoman.dist %>/images',
          src: ['generated/*']
        }, {
          expand: true,
          dot: true,
          cwd: '.tmp',
          dest: '<%= yeoman.dist %>',
          src: [
            '*.html',
            'views/{,*/}*.html'
          ]
        }]
      },
      styles: {
        expand: true,
        cwd: '<%= yeoman.app %>/styles',
        dest: '.tmp/styles/',
        src: ['*.css']
      }
    },

    // Run some tasks in parallel to speed up the build process
    concurrent: {
      server: [
        'coffee',
        'jade',
      ],
      test: [
        'coffee',
        'jade',
      ],
      debug: {
        tasks: [
          'nodemon',
          'node-inspector'
        ],
        options: {
          logConcurrentOutput: true
        }
      },
      dist: [
        'coffee',
        'copy:styles',
        'jade',
        'imagemin',
        'svgmin'
      ]
    },


    uglify: {
      options: {
        sourceMap: true
      },
      generated: {
        files: [
          {
            dest: '<%= yeoman.dist %>/scripts/app.js',
            src: ['.tmp/concat/scripts/app.js']
          },
          {
            dest: '<%= yeoman.dist %>/scripts/vendor.js',
            src: ['.tmp/concat/scripts/vendor.js']
          }
        ]
      }
    },
    concat: {
      generated: {
        files: [
          {
            dest: '.tmp/concat/scripts/app.js',
            src: [
              '.tmp/scripts/{,*/}*.js'
            ]
          },
          {
            dest: '.tmp/concat/scripts/vendor.js',
            src: [
              'bower_components/jquery/dist/jquery.js',
              'bower_components/es5-shim/es5-shim.js',
              'bower_components/angular/angular.js',
              'bower_components/json3/lib/json3.js',
              'bower_components/bootstrap/dist/js/bootstrap.js',
              'bower_components/angular-resource/angular-resource.js',
              'bower_components/angular-cookies/angular-cookies.js',
              'bower_components/angular-animate/angular-animate.js',
              'bower_components/angular-sanitize/angular-sanitize.js',
              'bower_components/angular-route/angular-route.js',
              'bower_components/waypoints/waypoints.js',
              'bower_components/SHA-1/sha1.js',
              'bower_components/angulartics/src/angulartics.js',
              'bower_components/angulartics/src/angulartics-ga.js',
              'bower_components/angular-google-plus/dist/angular-google-plus.js',
              'bower_components/ngtoast/dist/ngToast.js',
              'bower_components/angular-intercom/angular-intercom.js',
              'bower_components/angular-easyfb/angular-easyfb.js',
              'bower_components/html5shiv/dist/html5shiv.js',
              'bower_components/respond/dest/respond.src.js',
              'bower_components/angular-seo/angular-seo.js',
              'bower_components/angular-loading-bar/build/loading-bar.js',
              'bower_components/angular-bootstrap/ui-bootstrap.js',
              'bower_components/ngInfiniteScroll/build/ng-infinite-scroll.js'
            ]
          }
        ]
      }
    },

    ngconstant: {
      options: {
        name: 'lemonades.config',
        wrap: '"use strict";\n\n{%= __ngModule %}',
        space: '  '
      },
      development: {
        options: {
          dest: '.tmp/scripts/shared/config.js'
        },
        constants: {
          config: {
            name: 'dev',
            baseUrl: 'http://localhost:3000',
            intercomAppId: 'ywcp8ipz',
            fbAppId: '1614694728745231'
          }
        }
      },
      production: {
        options: {
          dest: '.tmp/scripts/shared/config.js'
        },
        constants: {
          config: {
            url:'http://www.groupup.in',
            name: 'production',
            baseUrl: 'http://lemonades.elasticbeanstalk.com',
            intercomAppId: 'nasq14dx',
            fbAppId: '1608020712745966'
          }
        }
      }
    }

  });


  grunt.registerTask('serve', function (target) {
    if (target === 'dist') {
      return grunt.task.run(['build', 'connect:dist:keepalive']);
    }

    if (target === 'debug') {
      return grunt.task.run([
        'injector',
        'wiredep',
        'autoprefixer',
        'concurrent:debug'
      ]);
    }

    grunt.task.run([
      'clean:server',
      'wiredep',
      'ngconstant:development',
      'jade:server',
      'concurrent:server',
      'autoprefixer:server',
      'connect:livereload',
      'watch'
    ]);
  });

  grunt.registerTask('server', function () {
    grunt.log.warn('The `server` task has been deprecated. Use `grunt serve` to start a server.');
    grunt.task.run(['serve']);
  });

  grunt.registerTask('test', function (target) {
    if (target === 'server') {
      return grunt.task.run([
        'mochaTest'
      ]);
    }
  });

  grunt.registerTask('build', [
    'clean:dist',
    'wiredep',
    'useminPrepare',
    'ngconstant:production',
    'jade:dist',
    'coffee:dist',
    'concurrent:dist',
    'autoprefixer',
    'concat',
    'ngAnnotate',
    'copy:dist',
    'cdnify',
    'cssmin',
    'uglify',
    'filerev',
    'usemin',
    'htmlmin',
    'cdn:dist'
  ]);

  grunt.registerTask('default', [
    'newer:jshint',
    'test',
    'build'
  ]);
};
