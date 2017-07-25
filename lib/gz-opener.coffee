Serializable = require 'serializable'
{Emitter, File} = require 'atom'
path = require 'path'
fs = require 'fs-plus'
openFile = require './openfile'

module.exports=
class GzOpener extends Serializable
  @activate: ->
    atom.workspace.addOpener (filePath='') ->
      if filePath.endsWith(".gz") and !filePath.endsWith(".tar.gz") and fs.isFileSync(filePath)
        new GzOpener(path: filePath)
        
    atom.commands.add 'atom-workspace',
      'gz-opener:decode': ->
          editor = atom.workspace.getActiveTextEditor()
          if (editor?)
            openFile(editor.getPath())


  constructor: ({path}) ->
    @file = new File(path)
    @emitter = new Emitter()

  serializeParams: ->
    path: @getPath()

  deserializeParams: (params={}) ->
    if fs.isFileSync(params.path)
      params
    else
      console.warn "Could not build view for path '#{params.path}' because that file no longer exists"

  getPath: ->
    @file.getPath()

  destroy: ->
    @emitter.emit 'did-destroy'

  onDidDestroy: (callback) ->
    @emitter.on 'did-destroy', callback

  getViewClass: -> require './view'

  getTitle: ->
    if @getPath()?
      path.basename(@getPath())
    else
      'untitled'

  getURI: -> @getPath()

  isEqual: (other) ->
    other instanceof GzOpener and @getURI() is other.getURI()
