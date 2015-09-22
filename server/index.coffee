express = require 'express'
exphbs = require 'express-handlebars'
device = require 'express-device'
favicon = require 'express-favicon'
compression = require 'compression'
config = require 'config'
_ = require 'lodash'
deviceHelpers = require './helpers/device-helpers'
app = express()

env = process.env.NODE_ENV || 'development'
port = process.env.PORT || 6100

exphbsConf = exphbs.create(
  #helpers: hbshelpers
  extname: '.hbs', 
  viewsDir: 'server/views/'
  layoutsDir: 'server/views/layouts/dist'
  partialsDir: ['server/views/']
)
app.engine('.hbs', exphbsConf.engine)
app.set 'views', "#{__dirname}/views/"
app.set 'view engine', '.hbs' 



app.use (req, res, next ) ->
  console.log "req", req.path
  if req.query.q
    ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress
    console.log "ip->", ip
    console.log "req.host", req.host
    console.log "req.parmas", req.params
    console.log "req.query", req.query
    console.log "req.path", req.path
  next()
  
app.use device.capture() # describes waht type of device the user is using: Desktop/mobile/tablet/etc   
deviceHelpers(app)

app.use '/assets', express.static("client/assets", {maxAge: 31536000 * 1000}) #cache for 1 year
app.use '/assets', express.static("client/dist", {maxAge: 31536000 * 1000}) #cache for 1 year
app.use favicon("#{process.cwd()}/client/assets/favicon.ico") 

app.use compression()

server = app.listen port, ->
  console.log "Listening on #{port}"

server.addListener("connection", (stream) ->
  stream.setTimeout(4000) #4 secs
)

process.on('SIGTERM', ->
  console.log("Received SIGTERM")
  server.close( ->
    console.log("Closed out remaining connections.")
    process.exit(0)
  )
)

#this is a middleware language validator. any request other than the valid get 404
app.use '/:language/', (req, res, next ) ->
  console.log "language validator", req.params
  console.log "_.contains(allowedLanguages, req.params.language)", _.contains(config.allowed_languages, req.params.language)
  if _.contains(config.allowed_languages, req.params.language)
    next()
  else
    res.send(404)

require("./routes")(app)

module.exports.app = app