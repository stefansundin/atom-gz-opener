'use babel';

import Serializable from 'serializable';
import { Emitter, File } from 'atom';
import path from 'path';
import fs from 'fs-plus';
import openFile from './openfile';

export default class GzOpener extends Serializable {
  static activate() {
    atom.workspace.addOpener(function(filePath) {
      if (filePath.endsWith('.gz') && !filePath.endsWith('.tar.gz') && fs.isFileSync(filePath)) {
        return new GzOpener({path: filePath});
      }
    });

    atom.commands.add('atom-workspace', {
      'gz-opener:decompress'() {
        const editor = atom.workspace.getActiveTextEditor();
        if (editor) {
          return openFile(editor.getPath());
        }
      }
    });
  }

  constructor({path}) {
    super()
    this.file = new File(path);
    this.emitter = new Emitter();
  }

  serializeParams() {
    return {
      path: this.getPath(),
    };
  }

  deserializeParams(params) {
    if (!fs.isFileSync(params.path)) {
      return console.warn(`Could not build view for path '${params.path}' because that file no longer exists`);
    }
    return params;
  }

  getPath() {
    return this.file.getPath();
  }

  destroy() {
    return this.emitter.emit('did-destroy');
  }

  onDidDestroy(callback) {
    return this.emitter.on('did-destroy', callback);
  }

  getViewClass() {
    return require('./view');
  }

  getTitle() {
    if (this.getPath()) {
      return path.basename(this.getPath());
    }
    return 'untitled';
  }

  getURI() {
    return this.getPath();
  }

  isEqual(other) {
    return (other instanceof GzOpener) && (this.getURI() === other.getURI());
  }
};
