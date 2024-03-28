import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';

export class formulaModifiedProvider implements vscode.DefinitionProvider {
   public async provideDefinition(
   document: vscode.TextDocument, position: vscode.Position, token: vscode.CancellationToken):
   Promise<vscode.Definition | undefined> {
      const range = document.getWordRangeAtPosition(position, /exec\('.+','.+?'.*?\)/);
      if (range) {
         const match = document.getText(range).match(/exec\('(.+)','(.+?)'.*?\)/);

         if (match) {
            const functionName = match[1];
            const fileName = match[2];

            const definitions = this.findModifiedDefinition(functionName, fileName);

            if (definitions) {
               return definitions;
            }
         }
      }
   }

   async findModifiedDefinition(functionName: string, fileName: string) {
      const workspaceFolders = vscode.workspace.workspaceFolders;

      if (workspaceFolders) {
         const workspaceRoot = workspaceFolders[0].uri.fsPath; // Pobierz ścieżkę do głównego folderu przestrzeni roboczej


         // Funkcja do przeszukiwania katalogów
         function findFiles(directoryPath: string, fileName: string): string[] {
            let results: string[] = [];

            fs.readdirSync(directoryPath).forEach((dirContent) => {
               dirContent = path.resolve(directoryPath, dirContent);

               const stat = fs.statSync(dirContent);

               if (stat && stat.isDirectory()) {
                  results = results.concat(findFiles(dirContent, fileName));
               } else if (path.basename(dirContent) === fileName&& directoryPath.toLowerCase().includes('fml')) {
                     results.push(dirContent);
               }
            });

            return results;
         }


         // Użyj funkcji findFiles do wyszukiwania plików pasujących do wzorca
         const files = findFiles(workspaceRoot, fileName + '.fml');
         const modifiedFiles = findFiles(workspaceRoot, fileName + '.m.fml');


         //const allFiles = findFiles(workspaceRoot, fileName + '.m.fml');

         const allFiles = modifiedFiles.concat(files);

         // Przeszukaj pliki w poszukiwaniu definicji funkcji
         let definitions: vscode.Location[] = [];
         for (const file of allFiles) {
            const document = await vscode.workspace.openTextDocument(file);
            const text = document.getText();
            const regex = new RegExp(`^\\\\${functionName}\\b`, 'm');
            const match = text.match(regex);

            if (match) {
               const line = text.substring(0, match.index).split('\n').length - 1;
               const range = new vscode.Range(line, 0, line, match[0].length);
               definitions.push({ uri: vscode.Uri.file(file), range });
            }
         }
         return definitions;
      }
   }
}