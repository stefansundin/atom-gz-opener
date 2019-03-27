'use babel';

import { View } from 'atom-space-pen-views';
import path from 'path';
import openFile from './openfile';

export default class GzOpenerView extends View {
  static content(editor) {
    const fn = path.basename(editor.getPath());
    this.div({class: 'gz-opener'}, () => {
      this.h3(fn);
      this.button({outlet: 'btn', class: 'btn'}, 'open');
    });
  }

  initialize(editor) {
    this.file = editor.getPath();
    this.btn.on('click', () => {
      openFile(this.file);
    });
  }
};
