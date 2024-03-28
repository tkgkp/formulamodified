"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SymbolListProvider = void 0;
const vscode = __importStar(require("vscode"));
const fs = __importStar(require("fs"));
const fileUtils = __importStar(require("./modifiedFileUtil"));
class SymbolListProvider {
    _onDidChangeTreeData = new vscode.EventEmitter();
    onDidChangeTreeData = this._onDidChangeTreeData.event;
    decorationType;
    constructor() {
        const config = vscode.workspace.getConfiguration('formulamodified');
        const sidebarHighlightColor = config.get('sidebarHighlightColor');
        this.decorationType = vscode.window.createTextEditorDecorationType({
            backgroundColor: sidebarHighlightColor,
            border: 'none',
            isWholeLine: true,
            overviewRulerColor: 'darkred',
            overviewRulerLane: vscode.OverviewRulerLane.Right,
        });
    }
    refresh() {
        this._onDidChangeTreeData.fire(null);
    }
    async getTreeItem(element) {
        const line = await this.getLineOfSymbol(element);
        return {
            label: element,
            collapsibleState: vscode.TreeItemCollapsibleState.None,
            iconPath: new vscode.ThemeIcon('symbol-variable'),
            command: {
                command: 'revealLine',
                title: '',
                arguments: [{ lineNumber: line, at: 'top' }]
            },
        };
    }
    async getLineOfSymbol(symbol) {
        const editor = vscode.window.activeTextEditor;
        if (editor) {
            const text = editor.document.getText();
            const regex = editor.document.languageId === 'prc' ? /^proc\s+([a-zA-Z0-9_]+)/gm : /^\\([a-zA-Z0-9_]+)$/gm;
            let match;
            const symbols = [];
            while ((match = regex.exec(text)) !== null) {
                symbols.push({
                    name: match[1],
                    range: new vscode.Range(editor.document.positionAt(match.index), editor.document.positionAt(match.index + match[0].length))
                });
            }
            for (let docSymbol of symbols) {
                if (docSymbol.name === symbol) {
                    return docSymbol.range.start.line;
                }
            }
        }
        return 0;
    }
    // const editor = vscode.window.activeTextEditor;
    // if (editor) {
    //     const document = editor.document;
    //     for (let line = 0; line < document.lineCount; line++) {
    //         const lineText = document.lineAt(line).text;
    //         const regex = new RegExp(`\\\\${symbol}$`);
    //         if (regex.test(lineText)) {
    //             return line;
    //         }
    //     }
    // }
    // return 0;
    //}
    getChildren(element) {
        // Tutaj możesz zwrócić listę symboli spełniających Twój warunek
        // Na przykład, zwróć listę symboli z otwartego dokumentu
        return new Promise((resolve) => {
            const funkcje = [];
            const decorations = [];
            const editor = vscode.window.activeTextEditor;
            const modifiedFilePath = editor ? fileUtils.formulaPath(editor.document.uri.fsPath) : undefined;
            if (editor) {
                const FilePath = modifiedFilePath?.modifiedFilePath;
                if (FilePath && fs.existsSync(FilePath)) {
                    vscode.workspace.openTextDocument(FilePath)
                        .then(correspondingDocument => {
                        const fileContent = correspondingDocument.getText();
                        const functionPattern = editor.document.languageId === 'prc' ? /^proc\s+([a-zA-Z0-9_]+)/gm : /^\\([a-zA-Z0-9_]+)$/gm;
                        let match;
                        while (match = functionPattern.exec(fileContent)) {
                            funkcje.push(match[1]);
                        }
                        if (editor) {
                            const text = editor.document.getText();
                            const regex = editor.document.languageId === 'prc' ? /^proc\s+([a-zA-Z0-9_]+)/gm : /^\\([a-zA-Z0-9_]+)$/gm;
                            let match;
                            const symbols = [];
                            while ((match = regex.exec(text)) !== null) {
                                symbols.push({
                                    name: match[1],
                                    range: new vscode.Range(editor.document.positionAt(match.index), editor.document.positionAt(match.index + match[0].length))
                                });
                            }
                            for (let i = 0; i < symbols.length; i++) {
                                let docSymbol = symbols[i];
                                if (funkcje.includes(docSymbol.name)) {
                                    let endPosition;
                                    if (i < symbols.length - 1) {
                                        endPosition = symbols[i + 1].range.start.translate(-1, 0);
                                    }
                                    else {
                                        endPosition = editor.document.positionAt(text.length);
                                    }
                                    let decoration = {
                                        range: new vscode.Range(docSymbol.range.start, endPosition),
                                        hoverMessage: docSymbol.name
                                    };
                                    decorations.push(decoration);
                                }
                            }
                            editor.setDecorations(this.decorationType, decorations);
                        }
                        resolve(funkcje);
                    }, error => {
                        console.error('Błąd podczas otwierania dokumentu:', error);
                        resolve(funkcje);
                    });
                }
                else {
                    resolve(funkcje);
                }
            }
            else {
                resolve(funkcje);
            }
        });
    }
}
exports.SymbolListProvider = SymbolListProvider;
//# sourceMappingURL=symbolList.js.map