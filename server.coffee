express = require('express')
app = express()
request = require('superagent')
app.use express.static('public')

getData = (resource_type, req, res) ->
  url = 'https://todoist.com/API/v7/sync'
  if req.query.token == ''
    return res.end JSON.stringify({})
  request
    .get(url)
    .query(
      token: req.query.token
      resource_types: "[\"#{resource_type}\"]"
      sync_token: '*'
    )
    .end (err, response) ->
      if err || !response.ok
        res.end JSON.stringify(err: err)
      else
        res.end JSON.stringify(results: response.body)
  
app.get '/projects', (req, res) ->
  getData 'projects', req, res
  
app.get '/items', (req, res) ->
  getData 'items', req, res

app.listen 3000, ->
  console.log 'Listening on port 3000!'
  return
