unit Invoice;

{$mode delphi}

interface

type
  TInvoiceLine = record
    Description: string;
    Quantity: Integer;
    UnitPrice: Currency;
  end;

  TInvoiceLines = array of TInvoiceLine;

function LineTotal(const ALine: TInvoiceLine): Currency;
function InvoiceNet(const ALines: TInvoiceLines): Currency;
function VatAmount(const ANet: Currency; const ARatePercent: Integer): Currency;
function RoundCommercial(const AValue: Currency): Currency;

implementation

function LineTotal(const ALine: TInvoiceLine): Currency;
begin
  Result := ALine.Quantity * ALine.UnitPrice;
end;

function InvoiceNet(const ALines: TInvoiceLines): Currency;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to High(ALines) do
    Result := Result + LineTotal(ALines[I]);
end;

function RoundCommercial(const AValue: Currency): Currency;
begin
  // Kaufmaennisch auf 2 Nachkommastellen runden
  Result := Trunc(AValue * 100 + 0.5) / 100;
end;

function VatAmount(const ANet: Currency; const ARatePercent: Integer): Currency;
begin
  Result := RoundCommercial(ANet * ARatePercent / 100);
end;

end.
