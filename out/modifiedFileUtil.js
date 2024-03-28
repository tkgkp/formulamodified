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
exports.formulaPath = exports.createFile = exports.createOrOpenFile = exports.getPathAsUri = void 0;
const path = __importStar(require("path"));
const fs = __importStar(require("fs"));
const vscode = __importStar(require("vscode"));
function getPathAsUri({ filePath }) {
    const normalizedPath = path.resolve(filePath);
    const uri = 'file://' + normalizedPath.replace(/\\/g, '/');
    return uri;
}
exports.getPathAsUri = getPathAsUri;
async function createOrOpenFile({ filePath }) {
    const fullPath = path.resolve(filePath);
    const config = vscode.workspace.getConfiguration('formulamodified');
    const openFileInNewTab = config.get('openFileInNewTab');
    const openFileInNewPanel = config.get('openFileInNewPanel');
    let document;
    try {
        // Sprawdź, czy plik istnieje
        await fs.promises.access(fullPath, fs.constants.F_OK);
        // Plik istnieje - sprawdź, czy jest już otwarty
        const uri = vscode.Uri.file(fullPath);
        const openedEditor = vscode.window.visibleTextEditors.find(editor => editor.document.uri.fsPath === uri.fsPath);
        if (openedEditor) {
            // Plik jest już otwarty - przełącz na niego
            await vscode.window.showTextDocument(openedEditor.document, openedEditor.viewColumn);
        }
        else {
            // Plik nie jest otwarty - otwórz go w edytorze
            const document = await vscode.workspace.openTextDocument(uri);
            vscode.window.showTextDocument(document, { preview: !openFileInNewTab, viewColumn: openFileInNewPanel ? vscode.ViewColumn.Beside : vscode.ViewColumn.Active, preserveFocus: false });
        }
        return document;
    }
    catch (error) {
        // Plik nie istnieje - zapytaj użytkownika, czy chce go utworzyć
        const answer = await vscode.window.showInformationMessage(`Plik ${filePath} nie istnieje. Czy chcesz go utworzyć?`, 'Tak', 'Anuluj');
        if (answer === 'Tak') {
            try {
                // Utwórz plik
                await fs.promises.writeFile(filePath, '');
                // Otwórz plik w edytorze
                const document = await vscode.workspace.openTextDocument(fullPath);
                vscode.window.showTextDocument(document, { preview: !openFileInNewTab, viewColumn: openFileInNewPanel ? vscode.ViewColumn.Beside : vscode.ViewColumn.Active, preserveFocus: false });
                return document;
            }
            catch (error) {
                // Obsłuż błąd podczas tworzenia pliku
                console.error(error);
            }
        }
    }
}
exports.createOrOpenFile = createOrOpenFile;
async function createFile(filePath) {
    try {
        // Utwórz plik
        await fs.promises.writeFile(filePath, '');
        console.log(`Plik ${filePath} został utworzony.`);
    }
    catch (error) {
        console.error(`Wystąpił błąd podczas tworzenia pliku ${filePath}:`, error);
    }
}
exports.createFile = createFile;
function formulaPath(filePath) {
    const normalizePath = (path) => path.replace(/\\\\/g, "\\").toLowerCase();
    const currentFilePath = normalizePath(filePath);
    const currentFileName = normalizePath(path.basename(currentFilePath));
    const config = vscode.workspace.getConfiguration('formulamodified');
    const depozytPath = normalizePath(config.get('depozytPath') || "");
    const workspaceFolder = normalizePath(vscode.workspace.workspaceFolders ? vscode.workspace.workspaceFolders[0].uri.fsPath : "");
    let modifiedFileName = currentFileName;
    let modifiedFilePath = currentFilePath;
    let baseFileName = currentFileName;
    let baseFilePath = currentFilePath;
    let depozytFileName = currentFileName;
    let depozytFilePath = currentFilePath;
    if (depozytPath !== "" && currentFilePath.includes(depozytPath)) {
        baseFileName = currentFileName;
        baseFilePath = currentFilePath.replace(depozytPath, workspaceFolder);
    }
    else if (currentFileName.includes('.m.')) {
        baseFileName = currentFileName.replace('.m.', '.');
        if (currentFilePath.includes('\\xpertis\\')) {
            baseFilePath = currentFilePath.replace('\\modified\\xpertis\\', '\\xpertis\\');
        }
        else {
            baseFilePath = currentFilePath.replace('\\modified\\', '\\merit\\');
        }
        baseFilePath = baseFilePath.replace(currentFileName, baseFileName);
    }
    else {
        baseFileName = currentFileName;
        baseFilePath = currentFilePath;
    }
    ;
    depozytFileName = baseFileName;
    depozytFilePath = baseFilePath.replace(workspaceFolder, depozytPath);
    let lastDotIndex = baseFileName.lastIndexOf('.');
    modifiedFileName = baseFileName.slice(0, lastDotIndex) + '.m' + baseFileName.slice(lastDotIndex);
    modifiedFilePath = baseFilePath.replace('\\merit\\', '\\modified\\');
    modifiedFilePath = modifiedFilePath.replace('\\xpertis\\', '\\modified\\xpertis\\');
    modifiedFilePath = modifiedFilePath.replace(baseFileName, modifiedFileName);
    return { currentFileName, modifiedFilePath, baseFilePath, modifiedFileName, baseFileName, depozytFileName, depozytFilePath };
}
exports.formulaPath = formulaPath;
//# sourceMappingURL=modifiedFileUtil.js.map