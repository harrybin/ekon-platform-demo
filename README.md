# EKON Platform Demo

Demo-Repository zum Vortrag „Nur ein paar Repositories? Wie GitHub vom Code-Archiv zur kompletten KI- und Delivery-Plattform mutiert ist“ (EKON 2026, Düsseldorf).

## Demos

1. **Zusammenarbeit und Governance:** Ruleset-Vorlage in `docs/`, CODEOWNERS, Issue-Vorlage und Pull Request für die Rundungsregel.
2. **CI/CD:** Pascal-Build mit Debug-/Release-Matrix, Testergebnis-Artefakten, Build-Provenance und manuellem Deployment in `dev` und `prod`.
3. **Security:** absichtlich verwundbarer Flask-Endpunkt in `tools/report_service/` und veraltete Abhängigkeiten für CodeQL und Dependabot.
4. **Copilot und Agents:** Repository-Anweisungen, Pascal-spezifische Anweisungen, Prompt-Datei, Custom Agent und Copilot-Setup-Workflow.

Die vollständige Einrichtung und die erforderlichen manuellen GitHub-Schritte stehen in der begleitenden Demo-Anleitung. GitHub-Projektboards sowie Copilot- und Environment-Freigaben müssen in den Repository-Einstellungen ergänzt werden.

## Lokal bauen und testen

Voraussetzung ist Free Pascal mit FPCUnit. Danach:

```bash
./build.sh
```

Die Tests schreiben XML-Ergebnisse nach `out/test-results.xml`. Das Projekt enthält absichtlich unsicheren Demo-Code und ist nicht für den produktiven Einsatz bestimmt.

Lizenz: MIT, siehe `LICENSE`.
