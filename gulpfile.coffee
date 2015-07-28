gulp = require 'gulp'
gutil = require 'gulp-util'
uglify = require 'gulp-uglify'
concat = require 'gulp-concat'
livereload = require 'gulp-livereload'
lr = require 'tiny-lr'
server = lr
sass = require 'gulp-sass'
coffee = require 'gulp-coffee'
rename = require 'gulp-rename'

jsSources = [
    'components/scripts/scriptsOne.js'
    'components/scripts/scriptsTwo.js'
]

coffeeSources = [
    'components/coffee/*.coffee'
]

sassSources = [
    'components/sass/*.scss'
]

swallowError = (error) ->
    console.error error.toString()
    this.emit 'end'

gulp.task 'js', ->
    gulp.src jsSources
        .pipe uglify()
        .pipe concat 'scripts.js'
        .pipe gulp.dest 'js'

gulp.task 'sass', ->
    gulp.src(sassSources)
        .pipe(sass()
            .on('error', sass.logError))
        .pipe gulp.dest('css')

gulp.task 'watch', ->
    gulp.watch coffeeSources[0], ['coffee']
    gulp.watch sassSources, ['sass']

gulp.task 'coffee', ->
    gulp.src coffeeSources[0]
    .pipe coffee
        bare: true
    .on 'error', swallowError
    .pipe gulp.dest 'js'
    .pipe uglify()
    .pipe rename 'scripts.min.js'
    .pipe gulp.dest 'js'


gulp.task 'default', ->
    gulp.start 'coffee'
    gulp.start 'sass'