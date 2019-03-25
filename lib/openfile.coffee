archive = require 'ls-archive'
fs = require 'fs-plus'
path = require 'path'
temp = require 'temp'

logError = (message, error) ->
  console.error(message, error.stack ? error)

module.exports = (file) ->
  archive.readGzip file, (error, contents) =>
    if error?
      logError("Error reading #{file}", error)
    else
      temp.mkdir 'atom-', (error, tempDirPath) =>
        if error?
          logError("Error creating temp directory: #{tempDirPath}", error)
        else
          base = path.basename(file)
          if base.endsWith('.gz')
            base = base.slice(0, -3)
          tempFilePath = path.join(tempDirPath, base)
          # console.log('temp file: ', tempFilePath)
          fs.writeFile tempFilePath, contents, (error) =>
            if error?
              logError("Error writing to #{tempFilePath}", error)
            else
              atom.workspace.open(tempFilePath)
