#!/usr/bin/env bash
# Baut und testet die Pascal-Bibliothek mit Free Pascal im Delphi-Modus.
set -euo pipefail
mkdir -p out
fpc -Mdelphi -Fusrc -FEout tests/InvoiceTests.lpr
./out/InvoiceTests --all --format=xml > out/test-results.xml
./out/InvoiceTests --all --format=plain
