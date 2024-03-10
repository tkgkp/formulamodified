# Zestaaw formuł do pracy wdrożeniowej w projektach Merit by Asseco BS

Rozszerzenie do porównania plików zmodyfikowanych w trakcie wdrożenia dla języka FORMULA (Merit).

## Funkcje

1. **Porównanie plików**: Rozszerzenie umożliwia porównanie plików m.fml i fml, co pozwala na łatwe zidentyfikowanie zmian wprowadzonych w trakcie wdrożenia.

2. **Podgląd zmian**: Rozszerzenie oferuje podgląd zmian w plikach, co pozwala na szybkie zrozumienie, co zostało zmienione bez konieczności otwierania obu plików.

3. **Nawigacja po symbolach**: Rozszerzenie umożliwia nawigację po zmodyfikowanych symbolach w plikach, co ułatwia zrozumienie struktury kodu.

## Instalacja

Aby zainstalować rozszerzenie, otwórz Visual Studio Code, przejdź do widoku Extensions (Ctrl+Shift+X), wybierz opcje Zainstaluj z pliku.

## Skróty klawiszowe

Możesz przypisać funkcje rozszerzenia do skrótów klawiszowych dla szybszego dostępu. Oto jak to zrobić:

1. Otwórz menu File -> Preferences -> Keyboard Shortcuts (lub użyj skrótu `Ctrl+K Ctrl+S`).
2. Kliknij ikonę pliku z ołówkiem w prawym górnym rogu, aby otworzyć plik `keybindings.json`.
3. Dodaj nowy wpis dla funkcji rozszerzenia. Na przykład, aby przypisać funkcję porównania plików do `Ctrl+Shift+C`, dodaj następujący wpis:

```json
{
  "key": "ctrl+shift+c",
  "command": "formulamodified.???????"
}
```

Funkcje dostępne do przypisania

### "formulamodified.CompareModified",

     Porównaj z plikiem modified lub dodaj plik modified do projektu

### "formulamodified.OpenModified",

     Otwórz plik korespondujący z aktualnym (modified/std)
