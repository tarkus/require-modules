fs   = require 'fs'
path = require 'path'
_    = require 'lodash'

env = process.env.NODE_DEV || 'development'

options =
  detect_env: true

require_tree = (dir) ->

  modules = {}

  for filename in fs.readdirSync(dir)
    module_name = filename.split(".")[0]
    modules[module_name.replace("-", "_")] = require "#{dir}/#{filename}"

  modules

module.exports = (dir, _options) ->
  args = Array::slice.call arguments

  if typeof _options is 'object'
    _options = _.merge options, args.pop()
  else
    _options = options

  modules = []
  dirs = args.length

  args.forEach (dir) ->

    required = { _env: env }

    if dir and dir.charAt(0) isnt "/"
      dir = path.join path.dirname(module.parent.filename), dir

    for name, content of require_tree "#{dir}"
      required[name] = content
      continue unless _options.detect_env
      required[name] = content['all'] if content['all']
      required[name] = _.merge content['all'], content[env] if content[env]

    modules.push required

  if dirs is 1 then modules.pop() else modules

