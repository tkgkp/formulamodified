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
exports.FileExplorerProvider = void 0;
const path = __importStar(require("path"));
const fs = __importStar(require("fs"));
const vscode = __importStar(require("vscode"));
class FileExplorerProvider {
    directoryPath1;
    directoryPath2;
    constructor(directoryPath1, directoryPath2) {
        this.directoryPath1 = directoryPath1;
        this.directoryPath2 = directoryPath2;
    }
    getChildren(_) {
        return Promise.resolve(this.getMatchingFiles());
    }
    getTreeItem(element) {
        return new vscode.TreeItem(element);
    }
    getMatchingFiles() {
        const matchingFiles = [];
        const filesInDir1 = this.getFilesInDirectory(this.directoryPath1);
        const filesInDir2 = this.getFilesInDirectory(this.directoryPath2);
        for (const file of filesInDir1) {
            if (filesInDir2.includes(file.replace('.', '.m.'))) {
                matchingFiles.push(`* ${file}`);
            }
        }
        return matchingFiles;
    }
    getFilesInDirectory(directoryPath) {
        const files = [];
        const directoryContents = fs.readdirSync(directoryPath);
        for (const item of directoryContents) {
            const itemPath = path.join(directoryPath, item);
            const stats = fs.statSync(itemPath);
            if (stats.isDirectory()) {
                files.push(...this.getFilesInDirectory(itemPath)); // Rekurencyjnie odczytaj pliki z podkatalogu
            }
            else {
                files.push(item);
            }
        }
        return files;
    }
}
exports.FileExplorerProvider = FileExplorerProvider;
//# sourceMappingURL=fileExpProv.js.map