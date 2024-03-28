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
exports.depozytListProvider = void 0;
const vscode = __importStar(require("vscode"));
const fs = __importStar(require("fs"));
const path = __importStar(require("path"));
const fileUtils = __importStar(require("./modifiedFileUtil"));
class depozytListProvider {
    workspaceRoot;
    _onDidChangeTreeData = new vscode.EventEmitter();
    onDidChangeTreeData = this._onDidChangeTreeData.event;
    constructor(workspaceRoot) {
        this.workspaceRoot = workspaceRoot;
    }
    refresh() {
        this._onDidChangeTreeData.fire(undefined);
    }
    getTreeItem(element) {
        return element;
    }
    getFilesInDirectory(dir) {
        const config = vscode.workspace.getConfiguration('formulamodified');
        const depozytPath = config.get('depozytPath');
        function hasModifiedFilesInDirectory(directory, compareDirectory) {
            const files = fs.readdirSync(directory);
            for (const file of files) {
                const filePath = path.join(directory, file);
                const compareFilePath = path.join(compareDirectory, file);
                const stat = fs.statSync(filePath);
                if (stat && stat.isDirectory()) {
                    if (hasModifiedFilesInDirectory(filePath, compareFilePath)) {
                        return true;
                    }
                }
                else {
                    let fileContent1 = fs.readFileSync(filePath, 'utf-8');
                    let fileContent2 = fs.existsSync(compareFilePath) ? fs.readFileSync(compareFilePath, 'utf-8') : null;
                    if (fileContent1 !== fileContent2) {
                        return true;
                    }
                }
            }
            return false;
        }
        if (depozytPath) {
            let results = [];
            let workspaceFolder = vscode.workspace.workspaceFolders ? vscode.workspace.workspaceFolders[0].uri.fsPath : undefined;
            if (!workspaceFolder) {
                return results;
            }
            else {
                fs.readdirSync(dir).forEach(file => {
                    const filePath = path.join(dir, file);
                    let formulaPath = fileUtils.formulaPath(filePath);
                    const normalizePath = (path) => path.replace(/\\\\/g, "\\").toLowerCase();
                    const dirNormalized = normalizePath(dir);
                    const depozytPathNormalized = depozytPath ? normalizePath(depozytPath) : "";
                    const workspaceFolderNormalized = workspaceFolder ? normalizePath(workspaceFolder) : "";
                    const compareDir = workspaceFolder ? dirNormalized.replace(depozytPathNormalized, workspaceFolderNormalized) : dir;
                    const comparePath = path.join(compareDir, file);
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
                    }
                    else if (stat && !stat.isDirectory()) {
                        let fileContent1 = fs.readFileSync(filePath, 'utf-8').replace(/\s/g, '');
                        let fileContent2 = fs.existsSync(comparePath) ? fs.readFileSync(comparePath, 'utf-8').replace(/\s/g, '') : null;
                        if (fileContent1 !== fileContent2 || !fileContent2) {
                            let treeItem = new vscode.TreeItem(vscode.Uri.file(filePath), vscode.TreeItemCollapsibleState.None);
                            if (fs.existsSync(modifiedPathNormalized)) {
                                treeItem.iconPath = new vscode.ThemeIcon("layers"); // Dodaj ikonę pliku z modyfikacją
                            }
                            else {
                                treeItem.iconPath = new vscode.ThemeIcon("file"); // Dodaj ikonę pliku
                            }
                            results.push(treeItem);
                        }
                    }
                    // }
                });
                return results;
            }
        }
        else {
            vscode.window.showInformationMessage('Brak ścieżki do depozytu w konfiguracji rozszerzenia.');
            return [];
        }
    }
    async getChildren(element) {
        if (!this.workspaceRoot) {
            vscode.window.showInformationMessage('No files in empty workspace');
            return Promise.resolve([]);
        }
        if (element && element.resourceUri) {
            return this.getFilesInDirectory(element.resourceUri.fsPath);
        }
        else {
            return this.getFilesInDirectory(this.workspaceRoot);
        }
    }
}
exports.depozytListProvider = depozytListProvider;
//# sourceMappingURL=depozytList.js.map