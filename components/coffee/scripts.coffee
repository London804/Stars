_MAX_PARTICLES = 100
_PARTICLE_DECAY_RATE = 0.005
_screenHeight = window.innerHeight
_screenWidth = window.innerWidth
_canvas = document.getElementById 'canvas'
_context = _canvas.getContext '2d'

resizeCanvas = ->
  _screenHeight = window.innerHeight
  _screenWidth = window.innerWidth
  _canvas.width = _screenWidth
  _canvas.height = _screenHeight


  return

mousePosition = (event) ->
  _rect = _canvas.getBoundingClientRect()
  _cursorPosition = {
    x: event.clientX - rect.left
    y: event.clientY - rect.top
  }
  console.log _cursorPosition
  return


_clearCanvas = -> _context.clearRect 0, 0, _screenWidth, _screenHeight

_getRandomIntInRange = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min;

_getRandomInRange = (min, max) ->
  Math.random() * (max - min + 1) + min;

class Particle
  constructor: ->
    @x = _getRandomIntInRange 0, _screenWidth
    @y = _getRandomIntInRange 0, _screenHeight
    @size = _getRandomInRange 1.5, 2
    @lifeForce = 0
    @lifePeak = false
    @maxLifeForce = _getRandomInRange 0.45 , 1
    @velocity = [
      _getRandomInRange -1, 1
      _getRandomInRange -1, 1
      _getRandomInRange -1, 1
    ]

  draw: =>
    if @lifeForce <= 0 and @lifePeak
      @constructor()
    #changes
    if @lifePeak then @lifeForce -= _PARTICLE_DECAY_RATE
    else if !@lifePeak then @lifeForce += _PARTICLE_DECAY_RATE
    if @lifeForce >= @maxLifeForce then @lifePeak = true
    #If particle leaves screen, put them on the other side
    @x += @velocity[0]
    if @x > _screenWidth then @x = 0
    else if @x < 0 then @x = _screenWidth
    @y += @velocity[1]
    if @y > _screenHeight then @y = 0
    else if @y < 0 then @y = _screenHeight
    _context.beginPath()
    _context.arc @x, @y, @size, 0, 2 * Math.PI, false
    _context.fillStyle = "rgba(255, 255, 255, #{@lifeForce})"
    _context.fill()

class BlackHole
  constructor: (x = 0, y = 0) ->
    @x = x
    @y = y
    @size = 10

  draw: =>
    _context.beginPath()
    _context.fillStyle = "#804C1A"
    _context.fillRect @x, @y, @size, @size
    _context.fill()

_animate = ->
  _clearCanvas()
  # aHole.draw(x,y)
  for part in particles
# _clearParticle part
    part.draw()
  for hole in blackHoles
    hole.draw()

  requestAnimationFrame _animate

move = (event) ->
  x = event.clientX - 5.5
  y = event.clientY - 6
  # singleHole = new BlackHole(x,y)
  blackHoles.push(new BlackHole(x,y))
  # console.log "x: #{x}, y: #{y}"
  return


#INSTANTIATION
particles = []
blackHoles = []
#fill particle array with particles
for i in [0.._MAX_PARTICLES] by 1
  part = new Particle()
  particles.push part
resizeCanvas()
window.addEventListener 'resize', resizeCanvas, false
_canvas.addEventListener 'click', (event) -> move event, false
_animate()



