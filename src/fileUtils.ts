import * as  path from 'path';
import * as fs from 'fs';
import * as vscode from 'vscode';


export function getPathAsUri({ filePath }: { filePath: string; }): string {
    const normalizedPath = path.resolve(filePath);
    const uri = 'file://' + normalizedPath.replace(/\\/g, '/');
    return uri;
}

export async function createOrOpenFile({ filePath }: { filePath: string; }): Promise< vscode.TextDocument | undefined> {
    const fullPath = path.resolve(filePath);

    try {
        // Sprawdź, czy plik istnieje
        await fs.promises.access(fullPath, fs.constants.F_OK);

        // Plik istnieje - otwórz go w edytorze
        const document = await vscode.workspace.openTextDocument(fullPath);
        vscode.window.showTextDocument(document, { viewColumn: vscode.ViewColumn.Beside });
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
                vscode.window.showTextDocument(document, { viewColumn: vscode.ViewColumn.Beside });
                return document;
            } catch (error) {
                vscode.window.showErrorMessage(`Wystąpił błąd podczas tworzenia pliku ${filePath}: ${error}`);
                return undefined;
            }
        } else {
            vscode.window.showInformationMessage('Zrezygnowano z utworzenia pliku.');
            return undefined;
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

// Funkcja do oznaczania plików w podkatalogach obu ścieżek
export async function markFilesInDirectories(directory1: string, directory2: string): Promise<void> {
    const files1 = await getFilesInDirectory(directory1);
    const files2 = await getFilesInDirectory(directory2);

    files1.forEach(async file => {
        if (files2.includes(file.replace('.','.m.'))) {
            const filePath1 = path.join(directory1, file);
            const filePath2 = path.join(directory2, file);
            await markFile(filePath1);
            await markFile(filePath2);
        }
    });
}

// Funkcja pomocnicza do rekurencyjnego pobierania plików w katalogu
async function getFilesInDirectory(directory: string): Promise<string[]> {
    let files: string[] = [];
    try {
        const fileEntries = await vscode.workspace.fs.readDirectory(vscode.Uri.file(directory));
        for (const [name, type] of fileEntries) {
            if (type === vscode.FileType.File) {
                files.push(name);
            } else if (type === vscode.FileType.Directory) {
                const subdirectory = path.join(directory, name);
                const subdirectoryFiles = await getFilesInDirectory(subdirectory);
                subdirectoryFiles.forEach(subFile => {
                    const relativePath = path.join(name, subFile);
                    files.push(relativePath);
                });
            }
        }
    } catch (error) {
        console.error('Error reading directory:', error);
    }
    return files;
}

// Funkcja pomocnicza do oznaczania pliku w edytorze
async function markFile(filePath: string): Promise<void> {
    const uri = vscode.Uri.file(filePath);
    const document = await vscode.workspace.openTextDocument(uri);
    const editor = await vscode.window.showTextDocument(document);

    // Tutaj możesz dodać dowolne oznaczenie pliku
    // Na przykład możesz zmienić kolor tła w pasku bocznym, w zakładce pliku lub dodać znacznik na pasku bocznym

    // Przykład: Zmiana koloru tła zakładki pliku
    const decorationType = vscode.window.createTextEditorDecorationType({
        backgroundColor: 'yellow' // Zmiana koloru na żółty
    });
    editor.setDecorations(decorationType, [new vscode.Range(0, 0, document.lineCount, 0)]);
}

// Funkcja zwracająca informacje na temat plików powiązanych (.m.)
interface FilePathInfo {
    currentFileName: string;
    modifiedFilePath: string;
    modifiedFileName: string;
    baseFilePath: string;
    baseFileName: string;
}

export function filePathModified(editor: vscode.TextEditor): FilePathInfo{
	const currentFilePath = editor.document.fileName;
	const currentFileName = path.basename(currentFilePath);
	let modifiedFileName = currentFileName;
	let modifiedFilePath = currentFilePath;
	let baseFileName = currentFileName;
	let baseFilePath = currentFilePath;

	if (currentFileName.includes('.m.')) {
		baseFileName = currentFileName.replace('.m.', '.');
		baseFilePath = currentFilePath.replace('\\modified\\', '\\merit\\');
		baseFilePath = baseFilePath.replace(currentFileName, baseFileName);
	}
	else {
		modifiedFileName = currentFileName.replace('.', '.m.');
		modifiedFilePath = currentFilePath.replace('\\merit\\', '\\modified\\');
		modifiedFilePath = modifiedFilePath.replace(currentFileName, modifiedFileName);
	};
	return {currentFileName, modifiedFilePath, baseFilePath, modifiedFileName, baseFileName};
}
