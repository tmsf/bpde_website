_ = require 'lodash'
config = require 'config'
routes = config.routes
allowedLanguages = config.allowed_languages
newsTemplates = config.news.templates
TumblrHelper = require '../helpers/tumblr'
LanguageId = require '../helpers/language'

module.exports.index = (req, res) ->
  language = if _.contains(allowedLanguages, req.params.language) then req.params.language else 'es'
  if !(_.contains(allowedLanguages, req.params.language)) #this is a helper to sanitise the urls.
    res.redirect(301, "/#{language}/")

module.exports.get = (req, res) ->
  language = if _.contains(allowedLanguages, req.params.language) then req.params.language else 'es'
  opts =  {layout: config.layout, tumblr_on: config.tumblr.on, is_mi_grano_de_arena: false, locals: res.locals, ga: config.google.ga}  
  _.extend(opts, LanguageId(language))
  
  content = req.params.content
  
  if _.contains(routes[language], content)
    template = "#{language}/#{content}"
    opts.status = 200
  else
    template = "#{language}/error"
    opts.status = 404
    
  res.status(opts.status).render(template, opts)