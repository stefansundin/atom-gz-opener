{View} = require 'atom-space-pen-views'
path = require 'path'
openFile = require './openfile'

module.exports = class GzOpenerView extends View
  @content: (editor) ->
    fn = path.basename(editor.getPath())
    @div class: 'gz-opener', =>
      @h3 fn
      @button outlet: "btn", class: "btn", "open"

  initialize: (editor) ->
    @file = editor.getPath()
    @btn.on 'click', =>
      openFile(@file)

