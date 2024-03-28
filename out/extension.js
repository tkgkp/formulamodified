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
const tmp = __importStar(require("tmp"));
const fs = __importStar(require("fs"));
const os = __importStar(require("os"));
const childProcess = __importStar(require("child_process"));
//Dodatkowe funkcje
//import { getPathAsUri } from './fileUtils';
const fileUtils = __importStar(require("./modifiedFileUtil"));
const symbolList_1 = require("./symbolList");
const depozytList_1 = require("./depozytList");
const modifiedProvider_1 = require("./modifiedProvider");
const prcProvider_1 = require("./prcProvider");
let fileExplorerProviderDepozyt;
let config = vscode.workspace.getConfiguration('formulamodified');
// This method is called when your extension is activated
// Your extension is activated the very first time the command is executed
function activate(context) {
    // Use the console to output diagnostic information (console.log) and errors (console.error)
    // This line of code will only be executed once when your extension is activated
    console.log('Uruchomiono wsparcie dla wdrożeń jezyka FORMULA (Merit)');
    vscode.workspace.onDidChangeConfiguration(event => {
        if (event.affectsConfiguration('formulamodified')) {
            // Tutaj umieść kod, który ma zostać wykonany po zmianie ustawień
            let config = vscode.workspace.getConfiguration('formulamodified');
        }
    });
    // Wsparcie języka FORMULA dla plików modified i definicji w plikach modified
    context.subscriptions.push(vscode.languages.registerDefinitionProvider({ pattern: '**/*.{fml,rpm,rpi,prc}' }, new modifiedProvider_1.formulaModifiedProvider()));
    // Symbole procedur w plikach prc
    context.subscriptions.push(vscode.languages.registerDocumentSymbolProvider({ pattern: '**/*.{prc,m.prc}' }, new prcProvider_1.PrcDocumentSymbolProvider()));
    //Dodatkowy pasek boczny funkcje ze zmianami w pliku m.*
    let treeDataProvider = new symbolList_1.SymbolListProvider();
    vscode.window.registerTreeDataProvider('myViewModifiedFunction', treeDataProvider);
    vscode.workspace.onDidOpenTextDocument(() => {
        treeDataProvider.refresh();
    });
    vscode.window.onDidChangeActiveTextEditor(() => {
        treeDataProvider.refresh();
    });
    //Dodatkowy pasek boczny eksploratora plików - z plikami zmienionymi w depozycie
    const depozytPath = config.get('depozytPath');
    if (depozytPath) {
        fileExplorerProviderDepozyt = new depozytList_1.depozytListProvider(depozytPath);
        vscode.window.registerTreeDataProvider('myViewModifiedDepozyt', fileExplorerProviderDepozyt);
    }
    else {
        vscode.window.showInformationMessage('Brak ścieżki do depozytu w konfiguracji rozszerzenia.');
    }
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
        const filePathInfo = fileUtils.formulaPath(editor.document.fileName);
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
        const filePathInfo = fileUtils.formulaPath(editor.document.fileName);
        if (!filePathInfo.currentFileName.includes('.m.')) {
            await fileUtils.createOrOpenFile({ filePath: filePathInfo.modifiedFilePath });
        }
        else {
            await fileUtils.createOrOpenFile({ filePath: filePathInfo.baseFilePath });
        }
        ;
    });
    context.subscriptions.push(OpenModified);
    let OpenModifiedExpa = vscode.commands.registerCommand('formulamodified.OpenModifiedExp', async (item) => {
        const filePathInfo = fileUtils.formulaPath(item.resourceUri.fsPath);
        if (!filePathInfo.currentFileName.includes('.m.')) {
            await fileUtils.createOrOpenFile({ filePath: filePathInfo.modifiedFilePath });
        }
        else {
            await fileUtils.createOrOpenFile({ filePath: filePathInfo.baseFilePath });
        }
        ;
    });
    context.subscriptions.push(OpenModifiedExpa);
    // Komenda otwierająca plik z funkcją z pliku modified i ustawiająca się na tej samej funkcji
    let GoToModifiedFunction = vscode.commands.registerCommand('formulamodified.GoToModifiedFunction', async (item) => {
        const editor = vscode.window.activeTextEditor;
        const config = vscode.workspace.getConfiguration('formulamodified');
        const openFileInNewTab = config.get('openFileInNewTab');
        const openFileInNewPanel = config.get('openFileInNewPanel');
        if (!editor) {
            vscode.window.showErrorMessage('Rozszerzenie uruchamia się tylko podczas pracy w edytorze.');
            return;
        }
        ;
        const correspondingFilePath = editor.document.fileName.includes('.m.') ? fileUtils.formulaPath(editor.document.fileName).baseFilePath : fileUtils.formulaPath(editor.document.fileName).modifiedFilePath;
        const document = await vscode.workspace.openTextDocument(correspondingFilePath);
        // Otwórz edytor dla tego dokumentu
        const correspondingEditor = await vscode.window.showTextDocument(document, { preview: !openFileInNewTab, viewColumn: openFileInNewPanel ? vscode.ViewColumn.Beside : vscode.ViewColumn.Active, preserveFocus: false });
        // Wyszukaj funkcję w dokumencie
        const text = document.getText();
        const regex = new RegExp(`^\\\\${item}\\b$`, 'm');
        const match = regex.exec(text);
        if (match) {
            // Ustaw kursor na początku funkcji
            const position = document.positionAt(match.index);
            correspondingEditor.selection = new vscode.Selection(position, position);
            // Przewiń ekran do miejsca, w którym ustawiony jest kursor
            correspondingEditor.revealRange(new vscode.Range(position, position), vscode.TextEditorRevealType.AtTop);
        }
    });
    context.subscriptions.push(GoToModifiedFunction);
    let GoToDepozytFunction = vscode.commands.registerCommand('formulamodified.GoToDepozytFunction', async (item) => {
        const editor = vscode.window.activeTextEditor;
        const config = vscode.workspace.getConfiguration('formulamodified');
        const openFileInNewTab = config.get('openFileInNewTab');
        const openFileInNewPanel = config.get('openFileInNewPanel');
        if (!editor) {
            vscode.window.showErrorMessage('Rozszerzenie uruchamia się tylko podczas pracy w edytorze.');
            return;
        }
        ;
        const correspondingFilePath = fileUtils.formulaPath(editor.document.fileName).depozytFilePath;
        const document = await vscode.workspace.openTextDocument(correspondingFilePath);
        // Otwórz edytor dla tego dokumentu
        const correspondingEditor = await vscode.window.showTextDocument(document, { preview: !openFileInNewTab, viewColumn: openFileInNewPanel ? vscode.ViewColumn.Beside : vscode.ViewColumn.Active, preserveFocus: false });
        // Wyszukaj funkcję w dokumencie
        const text = document.getText();
        const regex = new RegExp(`^\\\\${item}\\b$`, 'm');
        const match = regex.exec(text);
        if (match) {
            // Ustaw kursor na początku funkcji
            const position = document.positionAt(match.index);
            correspondingEditor.selection = new vscode.Selection(position, position);
            // Przewiń ekran do miejsca, w którym ustawiony jest kursor
            correspondingEditor.revealRange(new vscode.Range(position, position), vscode.TextEditorRevealType.AtTop);
        }
    });
    context.subscriptions.push(GoToDepozytFunction);
    // Funkcja porównuje funkcje z pliku aktualnie otwarty z plikiem korespondującym z nim
    let DiffModifiedFunction = vscode.commands.registerCommand('formulamodified.DiffModifiedFunction', async (item) => {
        const editor = vscode.window.activeTextEditor;
        const config = vscode.workspace.getConfiguration('formulamodified');
        const openDiffInNewTab = config.get('openDiffInNewTab');
        if (!editor) {
            vscode.window.showErrorMessage('Rozszerzenie uruchamia się tylko podczas pracy w edytorze.');
            return;
        }
        ;
        const currentFilePath = editor.document.uri;
        const correspondingFilePath = editor.document.fileName.includes('.m.') ? vscode.Uri.file(fileUtils.formulaPath(editor.document.fileName).baseFilePath) : vscode.Uri.file(fileUtils.formulaPath(editor.document.fileName).modifiedFilePath);
        // Wyszukaj definicje funkcji w obu plikach
        const currentFunctionDefinition = await findFunctionDefinition(currentFilePath, item);
        const correspondingFunctionDefinition = await findFunctionDefinition(correspondingFilePath, item);
        // Uzyskaj nazwy plików
        const currentFileName = path.basename(currentFilePath.fsPath);
        const correspondingFileName = path.basename(correspondingFilePath.fsPath);
        const modifiedFileName = currentFileName.includes('.m.') ? currentFileName : correspondingFileName;
        const modifiedFilePath = currentFileName.includes('.m.') ? currentFilePath : correspondingFilePath;
        if (currentFunctionDefinition === null || correspondingFunctionDefinition === null) {
            vscode.window.showErrorMessage('Nie można znaleźć definicji funkcji.');
            return;
        }
        const currentTempFile = await createWritableTempFile(currentFunctionDefinition, currentFilePath.fsPath);
        const correspondingTempFile = await createWritableTempFile(correspondingFunctionDefinition, currentFilePath.fsPath);
        const modifiedTempFilePath = currentFileName.includes('.m.') ? currentTempFile : correspondingTempFile;
        vscode.workspace.onDidSaveTextDocument(async (document) => {
            if (document.uri.fsPath === modifiedTempFilePath.fsPath) {
                const userResponse = await vscode.window.showInformationMessage(`Czy chcesz zastosować zmiany w funkcji ${item} w pliku ${modifiedFileName}  ?`, 'Tak', 'Nie');
                if (userResponse === 'Tak') {
                    const newFunctionContent = fs.readFileSync(modifiedTempFilePath.fsPath, 'utf8');
                    await applyChangesToFunction(modifiedFilePath, item, newFunctionContent);
                }
            }
        });
        // Użyj nazw plików w tytule porównania
        await vscode.commands.executeCommand('vscode.diff', currentTempFile, correspondingTempFile, `${currentFileName} vs ${correspondingFileName}`, { preview: !openDiffInNewTab });
    });
    context.subscriptions.push(DiffModifiedFunction);
    // Funkcja porównuje funkcje z pliku aktualnie otwartego z plikiem z depozytu
    let DiffDepozytFunction = vscode.commands.registerCommand('formulamodified.DiffDepozytFunction', async (item) => {
        const editor = vscode.window.activeTextEditor;
        const config = vscode.workspace.getConfiguration('formulamodified');
        const openDiffInNewTab = config.get('openDiffInNewTab');
        if (!editor) {
            vscode.window.showErrorMessage('Rozszerzenie uruchamia się tylko podczas pracy w edytorze.');
            return;
        }
        ;
        const currentFilePath = editor.document.uri;
        const correspondingFilePath = vscode.Uri.file(fileUtils.formulaPath(editor.document.fileName).depozytFilePath);
        // Wyszukaj definicje funkcji w obu plikach
        const currentFunctionDefinition = await findFunctionDefinition(currentFilePath, item);
        const correspondingFunctionDefinition = await findFunctionDefinition(correspondingFilePath, item);
        // Uzyskaj nazwy plików
        const currentFileName = path.basename(currentFilePath.fsPath);
        const correspondingFileName = path.basename(correspondingFilePath.fsPath);
        const modifiedFileName = currentFileName.includes('.m.') ? currentFileName : correspondingFileName;
        const modifiedFilePath = currentFileName.includes('.m.') ? currentFilePath : correspondingFilePath;
        if (currentFunctionDefinition === null || correspondingFunctionDefinition === null) {
            vscode.window.showErrorMessage('Nie można znaleźć definicji funkcji.');
            return;
        }
        const currentTempFile = await createWritableTempFile(currentFunctionDefinition, currentFilePath.fsPath);
        const correspondingTempFile = await createWritableTempFile(correspondingFunctionDefinition, currentFilePath.fsPath);
        const modifiedTempFilePath = currentFileName.includes('.m.') ? currentTempFile : correspondingTempFile;
        vscode.workspace.onDidSaveTextDocument(async (document) => {
            if (document.uri.fsPath === modifiedTempFilePath.fsPath) {
                const userResponse = await vscode.window.showInformationMessage(`Czy chcesz zastosować zmiany w funkcji ${item} w pliku ${modifiedFileName}  ?`, 'Tak', 'Nie');
                if (userResponse === 'Tak') {
                    const newFunctionContent = fs.readFileSync(modifiedTempFilePath.fsPath, 'utf8');
                    await applyChangesToFunction(modifiedFilePath, item, newFunctionContent);
                }
            }
        });
        await vscode.commands.executeCommand('vscode.diff', currentTempFile, correspondingTempFile, `${currentFileName} vs ${correspondingFileName}`, { preview: !openDiffInNewTab });
    });
    async function applyChangesToFunction(filePath, functionName, newFunctionContent) {
        const functionDefinition = await findFunctionDefinition(filePath, functionName);
        if (functionDefinition !== null) {
            const text = fs.readFileSync(filePath.fsPath, 'utf8');
            const newText = text.replace(functionDefinition, newFunctionContent);
            fs.writeFileSync(filePath.fsPath, newText, 'utf8');
        }
    }
    let CopyFromDepozyt = vscode.commands.registerCommand('formulamodified.CopyFromDepozyt', async (item) => {
        const currentFilePath = item.resourceUri.fsPath;
        const destinationFilePath = fileUtils.formulaPath(currentFilePath).baseFilePath;
        const destinationFileName = fileUtils.formulaPath(currentFilePath).baseFileName;
        const config = vscode.workspace.getConfiguration('formulamodified');
        const refreshDepozyt = config.get('refreshDepozyt');
        copyFile(currentFilePath, destinationFilePath).then(() => {
            vscode.window.showInformationMessage(`Plik ${destinationFileName} został skopiowany.`);
            // Odśwież zawartość katalogu
            if (refreshDepozyt) {
                fileExplorerProviderDepozyt.refresh();
            }
        }).catch((error) => {
            vscode.window.showErrorMessage(`Nie udało się skopiować pliku ${destinationFileName}: ${error.message}`);
        });
    });
    context.subscriptions.push(CopyFromDepozyt);
    let OpenFromDepozyt = vscode.commands.registerCommand('formulamodified.OpenFromDepozyt', async (item) => {
        const currentFilePath = item.resourceUri.fsPath;
        const destinationFilePath = fileUtils.formulaPath(currentFilePath).depozytFilePath;
        vscode.workspace.openTextDocument(destinationFilePath).then((document) => {
            vscode.window.showTextDocument(document);
        });
    });
    context.subscriptions.push(OpenFromDepozyt);
    let OpenFromProjekt = vscode.commands.registerCommand('formulamodified.OpenFromProjekt', async (item) => {
        const currentFilePath = item.resourceUri.fsPath;
        const destinationFilePath = fileUtils.formulaPath(currentFilePath).baseFilePath;
        vscode.workspace.openTextDocument(destinationFilePath).then((document) => {
            vscode.window.showTextDocument(document);
        });
    });
    context.subscriptions.push(OpenFromProjekt);
    let OpenFromModified = vscode.commands.registerCommand('formulamodified.OpenFromModified', async (item) => {
        const currentFilePath = item.resourceUri.fsPath;
        const destinationFilePath = fileUtils.formulaPath(currentFilePath).modifiedFilePath;
        vscode.workspace.openTextDocument(destinationFilePath).then((document) => {
            vscode.window.showTextDocument(document);
        });
    });
    context.subscriptions.push(OpenFromModified);
    let RefreshDepozyt = vscode.commands.registerCommand('formulamodified.RefreshDepozyt', () => {
        fileExplorerProviderDepozyt.refresh();
    });
    context.subscriptions.push(RefreshDepozyt);
    let CompareDepozyt = vscode.commands.registerCommand('formulamodified.CompareDepozyt', async (item) => {
        const modifiedFilePath = fileUtils.formulaPath(item.resourceUri.fsPath);
        const config = vscode.workspace.getConfiguration('formulamodified');
        const diffProgram = config.get('compareProgram') === 'meld' ? 'meld' : config.get('compareProgram') === 'winmerge' ? 'winmergeu.exe /ignorespace' : 'meld --ignore-all-space';
        if (fs.existsSync(modifiedFilePath?.baseFilePath) && fs.existsSync(modifiedFilePath?.modifiedFilePath)) {
            // Uruchom porównywanie plików
            childProcess.exec(`${diffProgram} ${modifiedFilePath?.depozytFilePath} ${modifiedFilePath?.modifiedFilePath} ${modifiedFilePath?.baseFilePath}`, (error) => {
                if (error) {
                    vscode.window.showErrorMessage(`Błąd podczas uruchamiania Meld: ${error.message}`);
                }
            });
        }
        else if (!fs.existsSync(modifiedFilePath?.baseFilePath)) {
            // Uruchom porównywanie z dwoma plikami
            childProcess.exec(`${diffProgram} ${modifiedFilePath?.depozytFilePath} ${modifiedFilePath?.baseFilePath}`, (error) => {
                if (error) {
                    vscode.window.showErrorMessage(`Błąd podczas uruchamiania Meld: ${error.message}`);
                }
            });
        }
        else {
            vscode.window.showInformationMessage('Brak plików do porównania.');
        }
    });
    context.subscriptions.push(CompareDepozyt);
    let DiffAllFunction = vscode.commands.registerCommand('formulamodified.DiffAllFunction', async (item) => {
        const editor = vscode.window.activeTextEditor;
        const config = vscode.workspace.getConfiguration('formulamodified');
        const depozytPath = config.get('depozytPath');
        if (!depozytPath) {
            vscode.window.showErrorMessage('Brak ścieżki do depozytu w konfiguracji rozszerzenia. \nPorównywanie nie jest możliwe.');
            return;
        }
        else if (!editor) {
            vscode.window.showErrorMessage('Rozszerzenie uruchamia się tylko podczas pracy w edytorze.');
            return;
        }
        else {
            const currentFilePath = editor.document.uri;
            const modifiedFilePath = fileUtils.formulaPath(currentFilePath.fsPath);
            const baseFilePath = vscode.Uri.file(modifiedFilePath.baseFilePath);
            const modFilePath = vscode.Uri.file(modifiedFilePath.modifiedFilePath);
            const depFilePath = vscode.Uri.file(modifiedFilePath.depozytFilePath);
            // Wyszukaj definicje funkcji w obu plikach
            const depozytFunctionDefinition = await findFunctionDefinition(depFilePath, item);
            const modFunctionDefinition = await findFunctionDefinition(modFilePath, item);
            const baseFunctionDefinition = await findFunctionDefinition(baseFilePath, item);
            const baseTempFile = await createTempFile(baseFunctionDefinition ? baseFunctionDefinition : "", baseFilePath.fsPath);
            const modTempFile = await createWritableTempFile(modFunctionDefinition ? modFunctionDefinition : "", modFilePath.fsPath);
            const depTempFile = await createTempFile(depozytFunctionDefinition ? depozytFunctionDefinition : "", depFilePath.fsPath);
            const modFileName = path.basename(modFilePath.fsPath);
            const baseFileName = path.basename(baseFilePath.fsPath);
            const originalContent = fs.readFileSync(modTempFile.fsPath, 'utf8');
            const config = vscode.workspace.getConfiguration('formulamodified');
            const diffProgram = config.get('compareProgram') === 'meld' ? 'meld --ignore-all-space' : config.get('compareProgram') === 'winmerge' ? `winmergeu.exe /ignorespace /dl "depozyt: ${baseFileName}" /dm "modified: ${modFileName}" /dr "projekt: ${baseFileName}"` : 'meld ';
            if (baseFunctionDefinition === null || modFunctionDefinition === null) {
                vscode.window.showErrorMessage('Nie można znaleźć definicji funkcji do porównania.');
                return;
            }
            try {
                if (depozytFunctionDefinition === null || depFilePath === null) {
                    vscode.window.showErrorMessage('Nie można znaleźć definicji z depozytu do porównania.\nPorównane zostaną funkcje z projektu i modified.');
                    childProcess.execSync(`${diffProgram} ${baseTempFile.fsPath} ${modTempFile.fsPath}`);
                }
                else {
                    childProcess.execSync(`${diffProgram} ${depTempFile.fsPath}  ${modTempFile.fsPath} ${baseTempFile.fsPath}`);
                }
            }
            catch (error) {
                if (error instanceof Error) {
                    vscode.window.showErrorMessage(`Błąd podczas uruchamiania porównywania: ${error.message}`);
                }
                else {
                    vscode.window.showErrorMessage(`Nieznany błąd podczas uruchamiania porównywania.`);
                }
            }
            // Porównaj zapamiętaną zawartość z aktualną zawartością pliku po zakończeniu programu do porównywania
            const newContent = fs.readFileSync(modTempFile.fsPath, 'utf8');
            if (newContent !== originalContent) {
                vscode.window.showInformationMessage(`Czy chcesz zastosować zmiany w funkcji ${item} w pliku ${modFileName}?`, 'Tak', 'Nie').then(async (userResponse) => {
                    if (userResponse === 'Tak') {
                        await applyChangesToFunction(modFilePath, item, newContent);
                        // Odśwież dekoracje po zastosowaniu zmian
                        treeDataProvider.refresh();
                    }
                });
            }
        }
    });
    context.subscriptions.push(DiffAllFunction);
    async function findFunctionDefinition(filePath, functionName) {
        if (!fs.existsSync(filePath.fsPath)) {
            vscode.window.showErrorMessage(`Nie znaleziono pliku: ${filePath.fsPath}`);
            return null;
        }
        const document = await vscode.workspace.openTextDocument(filePath);
        const text = document.getText();
        const lines = text.split('\n');
        let startLine = -1;
        let endLine = -1;
        const fileExtension = path.extname(filePath.fsPath);
        // Find the start of the function definition
        for (let i = 0; i < lines.length; i++) {
            if (fileExtension === '.prc') {
                const regex = new RegExp(`^proc\\s+${functionName}`);
                if (regex.test(lines[i])) {
                    startLine = i;
                    break;
                }
            }
            else {
                if (lines[i].startsWith(`\\${functionName}\r`) || lines[i].endsWith(`\\${functionName}`)) {
                    startLine = i;
                    break;
                }
            }
        }
        // If the function was not found, return null
        if (startLine === -1) {
            return null;
        }
        // Find the end of the function definition
        for (let i = startLine + 1; i < lines.length; i++) {
            if (fileExtension === '.prc') {
                if (lines[i].trim() === 'end proc') {
                    endLine = i + 1;
                    break;
                }
            }
            else {
                if (lines[i].startsWith('\\') && lines[i].trim().split(' ').length === 1) {
                    endLine = i;
                    break;
                }
            }
        }
        // If no line starting with '\' and containing a single word was found, the function ends at the end of the file
        if (endLine === -1) {
            endLine = lines.length;
        }
        // Return the function definition
        return lines.slice(startLine, endLine).join('\n');
    }
    async function createTempFile(content, currentFilePath) {
        const extension = path.extname(currentFilePath);
        const tempFile = tmp.fileSync({ postfix: extension });
        fs.writeFileSync(tempFile.name, content);
        return vscode.Uri.file(tempFile.name);
    }
    async function createWritableTempFile(content, filePath) {
        // Utwórz unikalną nazwę pliku tymczasowego na podstawie ścieżki pliku
        const tempFileName = path.basename(filePath) + '.' + Date.now();
        const tempFilePath = path.join(os.tmpdir(), tempFileName);
        // Zapisz zawartość do pliku tymczasowego
        fs.writeFileSync(tempFilePath, content);
        // Zwróć Uri pliku tymczasowego
        return vscode.Uri.file(tempFilePath);
    }
    async function copyFile(sourcePath, destinationPath) {
        return new Promise((resolve, reject) => {
            // Pobierz oryginalne uprawnienia pliku
            fs.stat(destinationPath, (err, stats) => {
                if (err) {
                    reject(err);
                    return;
                }
                const originalPermissions = stats.mode;
                // Zmień uprawnienia na zapisywalne
                fs.chmod(destinationPath, 0o777, (err) => {
                    if (err) {
                        reject(err);
                        return;
                    }
                    // Kopiuj plik
                    fs.copyFile(sourcePath, destinationPath, (err) => {
                        if (err) {
                            reject(err);
                            return;
                        }
                        // Przywróć oryginalne uprawnienia
                        fs.chmod(destinationPath, originalPermissions, (err) => {
                            if (err) {
                                reject(err);
                            }
                            else {
                                resolve();
                            }
                        });
                    });
                });
            });
        });
    }
}
exports.activate = activate;
;
// This method is called when your extension is deactivated
function deactivate() { }
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map