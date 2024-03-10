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
exports.deactivate = exports.activate = void 0;
// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
const vscode = __importStar(require("vscode"));
const path = __importStar(require("path"));
//Dodatkowe funkcje
//import { getPathAsUri } from './fileUtils';
const fileUtils = __importStar(require("./fileUtils"));
const symbolList_1 = require("./symbolList");
// This method is called when your extension is activated
// Your extension is activated the very first time the command is executed
function activate(context) {
    // Use the console to output diagnostic information (console.log) and errors (console.error)
    // This line of code will only be executed once when your extension is activated
    console.log('Uruchomiono wsparcie dla wdrożeń jezyka FORMULA (Merit)');
    //Dodatkowy pasek boczny
    let treeDataProvider = new symbolList_1.SymbolListProvider();
    vscode.window.registerTreeDataProvider('myViewModifiedFunction', treeDataProvider);
    vscode.workspace.onDidOpenTextDocument(() => {
        treeDataProvider.refresh();
    });
    vscode.window.onDidChangeActiveTextEditor(() => {
        treeDataProvider.refresh();
    });
    // The command has been defined in the package.json file
    // Now provide the implementation of the command with registerCommand
    // The commandId parameter must match the command field in package.json
    let CompareModified = vscode.commands.registerCommand('formulamodified.CompareModified', async () => {
        const editor = vscode.window.activeTextEditor;
        if (!editor) {
            vscode.window.showErrorMessage('Rozszerzenie uruchamia się tylko podczas pracy w edytorze.');
            return;
        }
        ;
        let currentFile;
        currentFile = editor.document;
        const currentFilePath = editor.document.fileName;
        const currentFileName = path.basename(currentFilePath);
        const filePathInfo = fileUtils.filePathModified(editor);
        let secondFile;
        if (!currentFileName.includes('.m.')) {
            secondFile = await fileUtils.createOrOpenFile({ filePath: filePathInfo.modifiedFilePath });
        }
        else {
            secondFile = await fileUtils.createOrOpenFile({ filePath: filePathInfo.baseFilePath });
        }
        ;
        if (currentFile && secondFile) {
            vscode.commands.executeCommand('vscode.diff', currentFile.uri, secondFile.uri);
        }
        else {
            vscode.window.showInformationMessage('Obydwa lub jeden z plików jest pusty lub brak jest pliku na dysku.\nPorównanie nie jest możliwe.');
        }
    });
    context.subscriptions.push(CompareModified);
    let OpenModified = vscode.commands.registerCommand('formulamodified.OpenModified', async () => {
        const editor = vscode.window.activeTextEditor;
        if (!editor) {
            vscode.window.showErrorMessage('Rozszerzenie uruchamia się tylko podczas pracy w edytorze.');
            return;
        }
        ;
        const filePathInfo = fileUtils.filePathModified(editor);
        if (!filePathInfo.currentFileName.includes('.m.')) {
            await fileUtils.createOrOpenFile({ filePath: filePathInfo.modifiedFilePath });
        }
        else {
            await fileUtils.createOrOpenFile({ filePath: filePathInfo.baseFilePath });
        }
        ;
    });
    context.subscriptions.push(OpenModified);
    //	Funkcja kopiująca orginalną funkcję z pliku STD do pliku modified
    let CopyFunctionToOtherFile = vscode.commands.registerCommand('formulamodified.CopyFunctionToOtherFile', async () => {
        const editor = vscode.window.activeTextEditor;
        if (!editor) {
            vscode.window.showErrorMessage('Rozszerzenie uruchamia się tylko podczas pracy w edytorze.');
            return;
        }
        // Pobierz aktualną pozycję kursora
        const position = editor.selection.active;
        // Pobierz informacje o symbolach w dokumencie
        const symbolInfo = await vscode.commands.executeCommand('vscode.executeDocumentSymbolProvider', editor.document.uri);
        console.log('Current file:', symbolInfo);
        // Sprawdź, czy w miejscu kursora znajduje się funkcja
        const functionSymbol = symbolInfo.find(symbol => symbol.range.contains(position));
        if (!functionSymbol) {
            vscode.window.showErrorMessage('Nie można znaleźć funkcji.');
            return;
        }
        console.log('Second file:', functionSymbol);
        // Pobierz zakres symbolu funkcji
        const functionRange = functionSymbol.range;
        // Pobierz treść funkcji na podstawie jej zakresu
        const functionContent = editor.document.getText(functionRange);
        // Zapisz treść funkcji do schowka
        await vscode.env.clipboard.writeText(functionContent);
        // Utwórz nowy plik
        // todo: dodać funkcję tworzenia pliku
        const newFilePath = 'C:\\Macrologic\\temp\\test.txt';
        const uri = vscode.Uri.file(newFilePath);
        const document = await vscode.workspace.openTextDocument(uri);
        const editor2 = await vscode.window.showTextDocument(document);
        // Wklej skopiowaną funkcję do nowego pliku
        await vscode.commands.executeCommand('editor.action.clipboardPasteAction');
        vscode.window.showInformationMessage('Funkcja została skopiowana do innego pliku.');
    });
    context.subscriptions.push(CopyFunctionToOtherFile);
    //	Funkcja porównuje oryginalną funkcję z pliku STD do funkcji pliku modified
    // todo: dodać funkcję porównującą
    let CompareFunctionWithOtherFile = vscode.commands.registerCommand('formulamodified.CompareFunctionWithOtherFile', async () => {
        const editor = vscode.window.activeTextEditor;
        if (!editor) {
            vscode.window.showErrorMessage('Rozszerzenie uruchamia się tylko podczas pracy w edytorze.');
            return;
        }
        // Pobierz aktualną pozycję kursora
        const position = editor.selection.active;
    });
    context.subscriptions.push(CompareFunctionWithOtherFile);
}
exports.activate = activate;
;
// This method is called when your extension is deactivated
function deactivate() { }
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map