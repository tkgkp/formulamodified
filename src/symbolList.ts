import * as vscode from 'vscode';
import * as path from 'path';

export class SymbolListProvider implements vscode.TreeDataProvider<string> {

    private _onDidChangeTreeData: vscode.EventEmitter<string | null> = new vscode.EventEmitter<string | null>();
    readonly onDidChangeTreeData: vscode.Event<string | null> = this._onDidChangeTreeData.event;

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
            const symbols = await vscode.commands.executeCommand<vscode.DocumentSymbol[]>('vscode.executeDocumentSymbolProvider', editor.document.uri);
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

    getChildren(element?: string): Thenable<string[]> {
        // Tutaj możesz zwrócić listę symboli spełniających Twój warunek
        // Na przykład, zwróć listę symboli z otwartego dokumentu
        return new Promise((resolve) => {
            const funkcje: string[] = [];
            const decorations: vscode.DecorationOptions[] = [];
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
                            vscode.commands.executeCommand<vscode.DocumentSymbol[]>('vscode.executeDocumentSymbolProvider', editor.document.uri)
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
                    } else {
                      resolve(funkcje);
                    }
            } else {
                resolve(funkcje);
            }
        });
    }

    getCorrespondingFilePath(currentFilePath: string): string | null {
    // Jeśli nazwa pliku zawiera zapis '.m.', zwróć null
    const fileName = path.basename(currentFilePath);

    // Jeśli nazwa pliku zawiera zapis '.m.' lub 'cli', zwróć null
    if (fileName.includes('.m.') || !currentFilePath.includes('.fml')) {
        return null;
    }
    // Tutaj wprowadź logikę do znalezienia ścieżki do pliku korespondującego z aktualnie otwartym plikiem
    // Na przykład, jeśli chcesz odczytać plik .test.ts dla pliku .ts, możesz to zrobić tak:
    return currentFilePath.replace('\\merit\\', '\\modified\\').replace('.fml','.m.fml');
    }
}