'use babel';

import archive from 'ls-archive';
import fs from 'fs-plus';
import path from 'path';
import temp from 'temp';

function logError(message, error) {
  console.error(message, error.stack ? error.stack : error);
}

export default function(file) {
  archive.readGzip(file, (error, contents) => {
    if (error) {
      return logError(`Error reading ${file}`, error);
    }

    temp.mkdir('atom-', (error, tempDirPath) => {
      if (error) {
        return logError(`Error creating temp directory: ${tempDirPath}`, error);
      }

      let base = path.basename(file);
      if (base.endsWith('.gz')) {
        base = base.slice(0, -3);
      }
      const tempFilePath = path.join(tempDirPath, base);
      // console.log('temp file: ', tempFilePath)
      fs.writeFile(tempFilePath, contents, error => {
        if (error) {
          return logError(`Error writing to ${tempFilePath}`, error);
        }

        atom.workspace.open(tempFilePath);
      });
    });
  });
};
