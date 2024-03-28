import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';
import * as fileUtils from './modifiedFileUtil';

export class depozytListProvider implements vscode.TreeDataProvider<vscode.TreeItem> {
    private _onDidChangeTreeData: vscode.EventEmitter<vscode.TreeItem | undefined> = new vscode.EventEmitter<vscode.TreeItem | undefined>();
    readonly onDidChangeTreeData: vscode.Event<vscode.TreeItem | undefined> = this._onDidChangeTreeData.event;

    constructor(private workspaceRoot: string) {}

    refresh(): void {
        this._onDidChangeTreeData.fire(undefined);
    }

    getTreeItem(element: vscode.TreeItem): vscode.TreeItem {
        return element;
    }

  private getFilesInDirectory(dir: string): vscode.TreeItem[] {
    const config = vscode.workspace.getConfiguration('formulamodified');
    const depozytPath = config.get('depozytPath') as string | undefined;

    function hasModifiedFilesInDirectory(directory: string, compareDirectory: string): boolean {
        const files = fs.readdirSync(directory);
        for (const file of files) {
            const filePath = path.join(directory, file);
            const compareFilePath = path.join(compareDirectory, file);
            const stat = fs.statSync(filePath);
            if (stat && stat.isDirectory()) {
                if (hasModifiedFilesInDirectory(filePath, compareFilePath)) {
                    return true;
                }
            } else {
                let fileContent1 = fs.readFileSync(filePath, 'utf-8');
                let fileContent2 = fs.existsSync(compareFilePath) ? fs.readFileSync(compareFilePath, 'utf-8') : null;
                if(fileContent1 !== fileContent2){
                    return true;
                }
            }
        }
        return false;
        }

    if (depozytPath) {
        let results: vscode.TreeItem[] = [];
        let workspaceFolder = vscode.workspace.workspaceFolders ? vscode.workspace.workspaceFolders[0].uri.fsPath : undefined;
        if (!workspaceFolder) {
            return results;
        } else {
           fs.readdirSync(dir).forEach(file => {
                const filePath = path.join(dir, file);
                let formulaPath = fileUtils.formulaPath(filePath);
                const normalizePath = (path: string) => path.replace(/\\\\/g, "\\").toLowerCase();
                const dirNormalized = normalizePath(dir);
                const depozytPathNormalized = depozytPath ? normalizePath(depozytPath) : "";
                const workspaceFolderNormalized = workspaceFolder ? normalizePath(workspaceFolder) : "";
                const compareDir = workspaceFolder ? dirNormalized.replace(depozytPathNormalized, workspaceFolderNormalized): dir;
                const comparePath = path.join(compareDir,file);
                const modifiedPathNormalized = formulaPath.modifiedFilePath;
                const stat = fs.statSync(filePath);

                // const extWer = ['fml', 'rpm', 'sql', 'xml', 'prc', 'htm','dsc'];
                // if (extWer.some(ext => filePath.includes(ext))) {
                    if (stat && stat.isDirectory() && (filePath.includes('merit') || filePath.includes('xpertis'))) {
                        if (hasModifiedFilesInDirectory(filePath, comparePath)) {
                            let treeItem = new vscode.TreeItem(vscode.Uri.file(filePath), vscode.TreeItemCollapsibleState.Collapsed);
                            treeItem.iconPath = new vscode.ThemeIcon("folder"); // Dodaj ikonę folderu
                            results.push(treeItem);
                        }
                    } else if (stat && !stat.isDirectory()) {
                        let fileContent1 = fs.readFileSync(filePath, 'utf-8').replace(/\s/g, '');
                        let fileContent2 = fs.existsSync(comparePath) ? fs.readFileSync(comparePath, 'utf-8').replace(/\s/g, '') : null;
                        if(fileContent1 !== fileContent2 || !fileContent2){
                            let treeItem = new vscode.TreeItem(vscode.Uri.file(filePath), vscode.TreeItemCollapsibleState.None);
                            if(fs.existsSync(modifiedPathNormalized)){
                                treeItem.iconPath = new vscode.ThemeIcon("layers"); // Dodaj ikonę pliku z modyfikacją
                            } else {
                            treeItem.iconPath = new vscode.ThemeIcon("file"); // Dodaj ikonę pliku
                            }
                            results.push(treeItem);
                        }
                    }
                // }
            });
            return results;
        }
    } else {
        vscode.window.showInformationMessage('Brak ścieżki do depozytu w konfiguracji rozszerzenia.');
        return [];
    }
}

async getChildren(element?: vscode.TreeItem): Promise<vscode.TreeItem[]> {
    if (!this.workspaceRoot) {
        vscode.window.showInformationMessage('No files in empty workspace');
        return Promise.resolve([]);
    }

    if (element && element.resourceUri) {
        return this.getFilesInDirectory(element.resourceUri.fsPath);
    } else {
        return this.getFilesInDirectory(this.workspaceRoot);
    }
}
}