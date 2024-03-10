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
const path = __importStar(require("path"));
class SymbolListProvider {
    _onDidChangeTreeData = new vscode.EventEmitter();
    onDidChangeTreeData = this._onDidChangeTreeData.event;
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
            const symbols = await vscode.commands.executeCommand('vscode.executeDocumentSymbolProvider', editor.document.uri);
            if (symbols) {
                for (let docSymbol of symbols) {
                    if (docSymbol.name === symbol) {
                        return docSymbol.range.start.line;
                    }
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
            if (editor) {
                const document = editor.document;
                const correspondingFilePath = this.getCorrespondingFilePath(document.uri.fsPath);
                if (correspondingFilePath) {
                    vscode.workspace.openTextDocument(correspondingFilePath)
                        .then(correspondingDocument => {
                        const fileContent = correspondingDocument.getText();
                        const functionPattern = /\\([a-zA-Z0-9_]+)$/gm;
                        let match;
                        while (match = functionPattern.exec(fileContent)) {
                            funkcje.push(match[1]);
                        }
                        // kolorowanie paska bocznego
                        const decorationType = vscode.window.createTextEditorDecorationType({
                            backgroundColor: 'rgba(255, 165, 0, 0.10)', // pomarańczowy kolor z 15% przezroczystości
                            border: 'none',
                            isWholeLine: true,
                            overviewRulerColor: 'darkred',
                            overviewRulerLane: vscode.OverviewRulerLane.Right,
                        });
                        const currentFileContent = editor.document.getText();
                        vscode.commands.executeCommand('vscode.executeDocumentSymbolProvider', editor.document.uri)
                            .then(symbols => {
                            if (symbols) {
                                symbols.forEach(symbol => {
                                    if (funkcje.includes(symbol.name)) {
                                        // Dodaj zakres symbolu do tablicy dekoracji
                                        decorations.push({ range: symbol.range, hoverMessage: symbol.name });
                                    }
                                });
                                editor.setDecorations(decorationType, decorations);
                            }
                        });
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
    getCorrespondingFilePath(currentFilePath) {
        // Jeśli nazwa pliku zawiera zapis '.m.', zwróć null
        const fileName = path.basename(currentFilePath);
        // Jeśli nazwa pliku zawiera zapis '.m.' lub 'cli', zwróć null
        if (fileName.includes('.m.') || !currentFilePath.includes('.fml')) {
            return null;
        }
        // Tutaj wprowadź logikę do znalezienia ścieżki do pliku korespondującego z aktualnie otwartym plikiem
        // Na przykład, jeśli chcesz odczytać plik .test.ts dla pliku .ts, możesz to zrobić tak:
        return currentFilePath.replace('\\merit\\', '\\modified\\').replace('.fml', '.m.fml');
    }
}
exports.SymbolListProvider = SymbolListProvider;
//# sourceMappingURL=symbolList.js.map