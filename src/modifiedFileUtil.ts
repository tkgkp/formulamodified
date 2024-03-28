import * as  path from 'path';
import * as fs from 'fs';
import * as vscode from 'vscode';


export function getPathAsUri({ filePath }: { filePath: string; }): string {
    const normalizedPath = path.resolve(filePath);
    const uri = 'file://' + normalizedPath.replace(/\\/g, '/');
    return uri;
}

export async function createOrOpenFile({ filePath }: { filePath: string; }): Promise<vscode.TextDocument | undefined> {
    const fullPath = path.resolve(filePath);
    const config = vscode.workspace.getConfiguration('formulamodified');
    const openFileInNewTab = config.get('openFileInNewTab');
    const openFileInNewPanel = config.get('openFileInNewPanel');

    let document: vscode.TextDocument | undefined;

    try {
        // Sprawdź, czy plik istnieje
        await fs.promises.access(fullPath, fs.constants.F_OK);

        // Plik istnieje - sprawdź, czy jest już otwarty
        const uri = vscode.Uri.file(fullPath);
        const openedEditor = vscode.window.visibleTextEditors.find(editor => editor.document.uri.fsPath === uri.fsPath);

        if (openedEditor) {
            // Plik jest już otwarty - przełącz na niego
            await vscode.window.showTextDocument(openedEditor.document, openedEditor.viewColumn);
        } else {
            // Plik nie jest otwarty - otwórz go w edytorze
            const document = await vscode.workspace.openTextDocument(uri);
            vscode.window.showTextDocument(document, { preview: !openFileInNewTab, viewColumn: openFileInNewPanel ? vscode.ViewColumn.Beside : vscode.ViewColumn.Active, preserveFocus: false });
        }

        return document;
    } catch (error) {
        // Plik nie istnieje - zapytaj użytkownika, czy chce go utworzyć
        const answer = await vscode.window.showInformationMessage(
            `Plik ${filePath} nie istnieje. Czy chcesz go utworzyć?`,
            'Tak',
            'Anuluj'
        );

        if (answer === 'Tak') {
            try {
                // Utwórz plik
                await fs.promises.writeFile(filePath, '');

                // Otwórz plik w edytorze
                const document = await vscode.workspace.openTextDocument(fullPath);
                vscode.window.showTextDocument(document, { preview: !openFileInNewTab, viewColumn: openFileInNewPanel ? vscode.ViewColumn.Beside : vscode.ViewColumn.Active, preserveFocus: false });
                return document;
            } catch (error) {
                // Obsłuż błąd podczas tworzenia pliku
                console.error(error);
            }
        }
    }
}

export async function createFile(filePath: string): Promise<void> {
    try {
        // Utwórz plik
        await fs.promises.writeFile(filePath, '');
        console.log(`Plik ${filePath} został utworzony.`);
    } catch (error) {
        console.error(`Wystąpił błąd podczas tworzenia pliku ${filePath}:`, error);
    }
}



// Funkcja zwracająca informacje na temat plików powiązanych (.m.)
interface FilePathInfo {
    currentFileName: string;
    modifiedFilePath: string;
    modifiedFileName: string;
    baseFilePath: string;
    baseFileName: string;
    depozytFilePath: string;
    depozytFileName: string;
}

export function formulaPath(filePath: string): FilePathInfo{
	const normalizePath = (path: string) => path.replace(/\\\\/g, "\\").toLowerCase();
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

    if  (depozytPath !== "" && currentFilePath.includes(depozytPath)) {
        baseFileName = currentFileName;
        baseFilePath = currentFilePath.replace(depozytPath, workspaceFolder);
    }
    else if (currentFileName.includes('.m.')) {
		baseFileName = currentFileName.replace('.m.', '.');

        if(currentFilePath.includes('\\xpertis\\')){
            baseFilePath = currentFilePath.replace('\\modified\\xpertis\\', '\\xpertis\\');
        } else {
        baseFilePath = currentFilePath.replace('\\modified\\', '\\merit\\');
        }

		baseFilePath = baseFilePath.replace(currentFileName, baseFileName);
	}
    else {
        baseFileName = currentFileName;
        baseFilePath = currentFilePath;
	};

    depozytFileName = baseFileName;
    depozytFilePath = baseFilePath.replace(workspaceFolder, depozytPath);

    let lastDotIndex = baseFileName.lastIndexOf('.');
    modifiedFileName = baseFileName.slice(0, lastDotIndex) + '.m' + baseFileName.slice(lastDotIndex);
    modifiedFilePath = baseFilePath.replace('\\merit\\', '\\modified\\');
    modifiedFilePath = modifiedFilePath.replace('\\xpertis\\', '\\modified\\xpertis\\');
    modifiedFilePath = modifiedFilePath.replace(baseFileName, modifiedFileName);

	return {currentFileName, modifiedFilePath, baseFilePath, modifiedFileName, baseFileName, depozytFileName, depozytFilePath};
}

  export function getFunctionAtCursor(position: vscode.Position, symbols: vscode.DocumentSymbol[]): {name: string, content: string} | null {
        let editor = vscode.window.activeTextEditor;
        if (!editor) {
            return null; // Brak aktywnego edytora
        }
        for (let symbol of symbols) {
            if (symbol.range.contains(position)) {
                let start = symbol.range.start;
                let end = symbol.range.end;
                let content = editor.document.getText(new vscode.Range(start, end));
                return {name: symbol.name, content: content};
            }
        }
        return null;
    }