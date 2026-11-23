# Copilot-Anweisungen fuer dieses Repository

- Sprache: Object Pascal, kompiliert mit Free Pascal im Delphi-Modus (`{$mode delphi}`), kompatibel zu Delphi 11+.
- Geschaeftslogik liegt in `src/`, Tests in `tests/` (FPCUnit). Jede neue Funktion bekommt einen Test.
- Bauen und testen: `./build.sh` (muss gruen sein, bevor ein PR geoeffnet wird).
- Geldbetraege immer als `Currency`, niemals `Double`. Rundung nur ueber `RoundCommercial`.
- Bezeichner auf Englisch, Kommentare auf Deutsch. Keine globalen Variablen.
- `tools/report_service` ist Begleit-Code in Python; dort nur parametrisierte SQL-Abfragen verwenden.
