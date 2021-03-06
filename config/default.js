const routes = require('./routes.json')

module.exports = {
  allowedLanguages: ['es', 'fr'],
  google: {
    ga: process.env.ga || 'UA-XXXXXXXX-1'
  },
  tumblr: {
    on: process.env.tumblr_on ? process.env.tumblr_on === 'true' : true,
    oauth: {
      consumer_key :  process.env.tumblr_key,
      consumer_secret :  process.env.tumblr_secret,
    },
    blog: process.env.tumblr_blog || 'babelpde.tumblr.com'
  },
  news: {
    limit: 3,
    templates: {'fr': 'nouvelles','es': 'noticias','cat': 'noticies'},
    templates_front_page: {'en': 'news_fp','es': 'home','fr': 'home'}
  },
  is_mi_grano_de_arena: process.env.mi_grano_de_arena ? process.env.mi_grano_de_arena === 'true' : false,
  routes,
  layout: 'babel'
}

module.exports.routes = routes
