import * as vscode from 'vscode';
import * as fs from 'fs';
import * as fileUtils from './modifiedFileUtil';

export class SymbolListProvider implements vscode.TreeDataProvider<string> {

    private _onDidChangeTreeData: vscode.EventEmitter<string | null> = new vscode.EventEmitter<string | null>();
    readonly onDidChangeTreeData: vscode.Event<string | null> = this._onDidChangeTreeData.event;
    private decorationType: vscode.TextEditorDecorationType;

    constructor() {
        const config = vscode.workspace.getConfiguration('formulamodified');
        const sidebarHighlightColor = config.get('sidebarHighlightColor') as string | undefined;
        this.decorationType = vscode.window.createTextEditorDecorationType({
            backgroundColor: sidebarHighlightColor,
            border: 'none',
            isWholeLine: true,
            overviewRulerColor: 'darkred',
            overviewRulerLane: vscode.OverviewRulerLane.Right,
        });
    }

    refresh(): void {
        this._onDidChangeTreeData.fire(null);
    }

    async getTreeItem(element: string): Promise<vscode.TreeItem> {
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

    async getLineOfSymbol(symbol: string): Promise<number> {
        const editor = vscode.window.activeTextEditor;
        if (editor) {
            const text = editor.document.getText();
            const regex = editor.document.languageId === 'prc' ? /^proc\s+([a-zA-Z0-9_]+)/gm : /^\\([a-zA-Z0-9_]+)$/gm;
            let match;
            const symbols = [];

            while ((match = regex.exec(text)) !== null) {
                symbols.push({
                    name: match[1],
                    range: new vscode.Range(
                        editor.document.positionAt(match.index),
                        editor.document.positionAt(match.index + match[0].length),
                    )
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

    getChildren(element?: string): Thenable<string[]> {
        // Tutaj możesz zwrócić listę symboli spełniających Twój warunek
        // Na przykład, zwróć listę symboli z otwartego dokumentu
        return new Promise((resolve) => {
            const funkcje: string[] = [];
            const decorations: vscode.DecorationOptions[] = [];
            const editor = vscode.window.activeTextEditor;
            const modifiedFilePath = editor ? fileUtils.formulaPath(editor.document.uri.fsPath) : undefined;

            if (editor) {
                const FilePath =  modifiedFilePath?.modifiedFilePath;

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
                                const regex =editor.document.languageId === 'prc' ? /^proc\s+([a-zA-Z0-9_]+)/gm : /^\\([a-zA-Z0-9_]+)$/gm;
                                let match;
                                const symbols = [];

                                while ((match = regex.exec(text)) !== null) {
                                    symbols.push({
                                        name: match[1],
                                        range: new vscode.Range(
                                            editor.document.positionAt(match.index),
                                            editor.document.positionAt(match.index + match[0].length)
                                        )
                                    });
                                }

                                for (let i = 0; i < symbols.length; i++) {
                                    let docSymbol = symbols[i];
                                    if (funkcje.includes(docSymbol.name)) {
                                        let endPosition;
                                        if (i < symbols.length - 1) {
                                            endPosition = symbols[i + 1].range.start.translate(-1,0);
                                        } else {
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
                    } else {
                      resolve(funkcje);
                    }
            } else {
                resolve(funkcje);
            }
        });
    }
}