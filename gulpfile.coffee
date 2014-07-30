gulp            = require('gulp')
gulpLoadPlugins = require('gulp-load-plugins')
plugins         = gulpLoadPlugins()
browserSync     = require 'browser-sync'
reload          = browserSync.reload;

paths =
  scripts: 'coffee/**/*.coffee'
  styles:  'sass/**/*.scss'
  images:  'imgs/**/*'

onError = (err) ->
  console.log err

# Static server
gulp.task 'browser-sync', () ->
  browserSync(
    server:
      baseDir: "./")

# misc cleaning tasks
gulp.task 'clean-styles', () ->
  return gulp.src('build/styles', {read: false})
    .pipe(plugins.clean())

gulp.task 'clean-images', () ->
  return gulp.src('build/images', {read: false})
    .pipe(plugins.clean())

gulp.task 'clean-scripts', () ->
  return gulp.src('build/scripts', {read: false})
    .pipe(plugins.clean())


gulp.task 'styles', ['clean-styles'], () ->

  config =
    css: 'build/styles'
    sass: paths.sass
    comments: false

  styles = gulp.src(paths.styles)
    .pipe(plugins.plumber({
      errorHandler: onError
    }))
    .pipe(plugins.compass(config))
    .pipe(plugins.autoprefixer())
    .pipe(plugins.rename({ suffix: '.min' }))
    .pipe(plugins.minifyCss())
    .pipe(gulp.dest(config.css))
    .pipe(reload({stream:true}));

  styles.on 'error', () ->
    console.log err

  return styles


gulp.task 'images', ['clean-images'], () ->
  return gulp.src(paths.images)
    .pipe(plugins.imagemin({optimizationLevel: 5}))
    .pipe(plugins.rename({ extname: '.png' }))
    .pipe(gulp.dest('build/imgs'))


gulp.task 'scripts', ['clean-scripts'], () ->
  gulp.src(paths.scripts)
    .pipe(plugins.sourcemaps.init())
      .pipe(plugins.coffee())
      .pipe(plugins.uglify())
      .pipe(plugins.concat('all.min.js'))
    .pipe(plugins.sourcemaps.write())
    .pipe(gulp.dest('build/js'))
    .pipe(browserSync.reload({stream:true, once: true}))


gulp.task 'default', ['watch']

gulp.task 'build', ['scripts', 'styles', 'images']

gulp.task 'watch', ['scripts', 'styles', 'images', 'browser-sync'], () ->
  gulp.watch paths.styles, ['styles']
  gulp.watch paths.scripts, ['scripts']
  gulp.watch paths.images, ['images']
