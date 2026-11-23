#!/usr/bin/env bash
# Richtet das Demo-Repository auf github.com ein.
# Voraussetzungen: git, GitHub CLI (gh) angemeldet mit "gh auth login" (Scopes: repo, project, workflow).
# Aufruf:  OWNER=harrybin REPO=ekon-platform-demo ./setup-demo.sh
set -euo pipefail
OWNER="${OWNER:-harrybin}"
REPO="${REPO:-ekon-platform-demo}"
FULL="$OWNER/$REPO"

echo "== 1. Repository anlegen und Code pushen"
git init -b main >/dev/null 2>&1 || true
git add . && git commit -m "Initial demo content" >/dev/null 2>&1 || true
gh repo create "$FULL" --public --source=. --push --description "EKON 2026 – GitHub als Plattform (Demo)"

echo "== 2. Labels"
gh label create epic        -R "$FULL" -c 561257 -f || true
gh label create feature     -R "$FULL" -c 831B84 -f || true
gh label create task        -R "$FULL" -c E331D0 -f || true
gh label create copilot-ready -R "$FULL" -c 150027 -f || true

echo "== 3. Issues inkl. Sub-Issues"
EPIC_URL=$(gh issue create -R "$FULL" -t "Epic: Online-Rechnung" -l epic -b "Kunden erhalten Rechnungen digital als PDF und per Mail.")
EPIC_NO=${EPIC_URL##*/}
sub() { # $1 Titel, $2 Label
  local url no id
  url=$(gh issue create -R "$FULL" -t "$1" -l "$2" -b "Teil von #$EPIC_NO")
  no=${url##*/}
  id=$(gh api "repos/$FULL/issues/$no" --jq .id)
  gh api -X POST "repos/$FULL/issues/$EPIC_NO/sub_issues" -F sub_issue_id="$id" >/dev/null
}
sub "Feature: PDF-Export" feature
sub "Feature: Mailversand" feature
sub "PDF-Layout mit Firmenlogo" task
sub "Steuer-Logik fuer Auslandskunden" task
sub "Rundung pro Zeile statt pro Summe" task

gh issue create -R "$FULL" -t "Rabattstaffel fuer Grosskunden" -l feature -l copilot-ready -b "$(cat <<'BODY'
## Ziel
Grosskunden erhalten abhaengig vom Nettobetrag einer Rechnung einen Rabatt.

## Akzeptanzkriterien
- Neue Funktion `DiscountPercent(const ANet: Currency): Integer` in `src/Invoice.pas`
- unter 1.000 EUR: 0 %
- ab 1.000 EUR: 3 %
- ab 10.000 EUR: 5 %
- FPCUnit-Tests fuer alle Grenzwerte (999,99 / 1.000,00 / 9.999,99 / 10.000,00)
- `./build.sh` laeuft gruen
BODY
)" >/dev/null

echo "== 4. Feature-Branch + Pull Request fuer die Collaboration-Demo"
git checkout -b feature/rundungsregel
sed -i 's/Kaufmaennisch auf 2 Nachkommastellen runden/Kaufmaennisch auf 2 Nachkommastellen runden (Rundungsregel DIN 1333)/' src/Invoice.pas
git commit -am "Document rounding rule" >/dev/null
git push -u origin feature/rundungsregel
gh pr create -R "$FULL" -B main -H feature/rundungsregel -t "Feature: Rundungsregel" -b "Dokumentiert die Rundungsregel. Closes nichts – Demo-PR fuer Rulesets und Reviews."
git checkout main

echo "== 5. Environments dev und prod (prod mit Required Reviewer + nur main)"
USER_ID=$(gh api "users/$OWNER" --jq .id)
gh api -X PUT "repos/$FULL/environments/dev" >/dev/null
gh api -X PUT "repos/$FULL/environments/prod" --input - >/dev/null <<JSON
{ "reviewers": [ { "type": "User", "id": $USER_ID } ],
  "deployment_branch_policy": { "protected_branches": false, "custom_branch_policies": true } }
JSON
gh api -X POST "repos/$FULL/environments/prod/deployment-branch-policies" -f name=main >/dev/null

echo "== 6. Security-Features"
gh api -X PUT "repos/$FULL/vulnerability-alerts" >/dev/null
gh api -X PUT "repos/$FULL/automated-security-fixes" >/dev/null
gh api -X PATCH "repos/$FULL" --input - >/dev/null <<'JSON'
{ "security_and_analysis": {
    "secret_scanning": { "status": "enabled" },
    "secret_scanning_push_protection": { "status": "enabled" } } }
JSON
gh api -X PATCH "repos/$FULL/code-scanning/default-setup" -f state=configured -f query_suite=default >/dev/null || \
  echo "   CodeQL Default Setup bitte manuell aktivieren (Settings > Advanced Security)."

echo "== 7. Ruleset main-protection"
gh api -X POST "repos/$FULL/rulesets" --input docs/ruleset-main-protection.json >/dev/null

echo "Fertig. Manuelle Schritte (Projects-Board, Copilot, Fallback-Screenshots) siehe Anleitung."
