{View} = require 'atom-space-pen-views'
path = require 'path'
fs = require 'fs-plus'
temp = require 'temp'
archive = require 'ls-archive'

module.exports = class GzOpenerView extends View
  @content: (editor) ->
    fn = path.basename(editor.getPath())
    @div class: 'gz-opener', =>
      @h3 fn
      @button outlet: "btn", class: "btn", "open"

  initialize: (editor) ->
    @file = editor.getPath()
    @btn.on 'click', =>
      @openFile()

  openFile: ->
    archive.readGzip @file, (error, contents) =>
      if error?
        @logError("Error reading #{@file}", error)
      else
        temp.mkdir 'atom-', (error, tempDirPath) =>
          if error?
            @logError("Error creating temp directory: #{tempDirPath}", error)
          else
            tempFilePath = path.join(tempDirPath, path.basename(@file).slice(0, -3))
            # console.log('temp file: ', tempFilePath)
            fs.writeFile tempFilePath, contents, (error) =>
              if error?
                @logError("Error writing to #{tempFilePath}", error)
              else
                atom.workspace.open(tempFilePath)

  logError: (message, error) ->
    console.error(message, error.stack ? error)
