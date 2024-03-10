import * as  path from 'path';
import * as fs from 'fs';
import * as vscode from 'vscode';


export class FileExplorerProvider implements vscode.TreeDataProvider<string> {
    constructor(private directoryPath1: string, private directoryPath2: string) {}

    getChildren(_?: string): Thenable<string[]> {
        return Promise.resolve(this.getMatchingFiles());
    }

    getTreeItem(element: string): vscode.TreeItem | Thenable<vscode.TreeItem> {
        return new vscode.TreeItem(element);
    }

    private getMatchingFiles(): string[] {
        const matchingFiles: string[] = [];

        const filesInDir1 = this.getFilesInDirectory(this.directoryPath1);
        const filesInDir2 = this.getFilesInDirectory(this.directoryPath2);

        for (const file of filesInDir1) {
            if (filesInDir2.includes(file.replace('.','.m.'))) {
                matchingFiles.push(`* ${file}`);
            }
        }

        return matchingFiles;
    }

    private getFilesInDirectory(directoryPath: string): string[] {
        const files: string[] = [];

        const directoryContents = fs.readdirSync(directoryPath);

        for (const item of directoryContents) {
            const itemPath = path.join(directoryPath, item);
            const stats = fs.statSync(itemPath);

            if (stats.isDirectory()) {
                files.push(...this.getFilesInDirectory(itemPath)); // Rekurencyjnie odczytaj pliki z podkatalogu
            } else {
                files.push(item);
            }
        }

        return files;
    }

    // Pozostałe metody implementacji drzewa eksploratora
}