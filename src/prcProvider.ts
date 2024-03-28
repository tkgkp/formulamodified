import * as vscode from 'vscode';

export class PrcDocumentSymbolProvider implements vscode.DocumentSymbolProvider {
   provideDocumentSymbols(document: vscode.TextDocument, token: vscode.CancellationToken): vscode.ProviderResult<vscode.SymbolInformation[]> {
      const symbols: vscode.SymbolInformation[] = [];
      const text = document.getText();
      const regex = /proc (\w+).*?end proc/gs;

      let match;
      while (match = regex.exec(text)) {
         const procName = match[1];
         const start = document.positionAt(match.index);
         const end = document.positionAt(match.index + match[0].length);
         const range = new vscode.Range(start, end);

         symbols.push(new vscode.SymbolInformation(procName, vscode.SymbolKind.Function, range));
      }

      return symbols;
   }
}
