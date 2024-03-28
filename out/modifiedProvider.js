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
exports.formulaModifiedProvider = void 0;
const vscode = __importStar(require("vscode"));
const path = __importStar(require("path"));
const fs = __importStar(require("fs"));
class formulaModifiedProvider {
    async provideDefinition(document, position, token) {
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
    async findModifiedDefinition(functionName, fileName) {
        const workspaceFolders = vscode.workspace.workspaceFolders;
        if (workspaceFolders) {
            const workspaceRoot = workspaceFolders[0].uri.fsPath; // Pobierz ścieżkę do głównego folderu przestrzeni roboczej
            // Funkcja do przeszukiwania katalogów
            function findFiles(directoryPath, fileName) {
                let results = [];
                fs.readdirSync(directoryPath).forEach((dirContent) => {
                    dirContent = path.resolve(directoryPath, dirContent);
                    const stat = fs.statSync(dirContent);
                    if (stat && stat.isDirectory()) {
                        results = results.concat(findFiles(dirContent, fileName));
                    }
                    else if (path.basename(dirContent) === fileName && directoryPath.toLowerCase().includes('fml')) {
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
            let definitions = [];
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
exports.formulaModifiedProvider = formulaModifiedProvider;
//# sourceMappingURL=modifiedProvider.js.map