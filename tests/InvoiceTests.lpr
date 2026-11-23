program InvoiceTests;

{$mode delphi}

uses
  Classes, consoletestrunner, fpcunit, testregistry, Invoice;

type
  TInvoiceTest = class(TTestCase)
  published
    procedure LineTotalMultipliesQuantity;
    procedure InvoiceNetSumsLines;
    procedure VatIsRounded;
  end;

procedure TInvoiceTest.LineTotalMultipliesQuantity;
var
  L: TInvoiceLine;
begin
  L.Description := 'Lizenz';
  L.Quantity := 3;
  L.UnitPrice := 19.99;
  AssertEquals(59.97, Double(LineTotal(L)), 0.001);
end;

procedure TInvoiceTest.InvoiceNetSumsLines;
var
  Lines: TInvoiceLines;
begin
  SetLength(Lines, 2);
  Lines[0].Quantity := 1; Lines[0].UnitPrice := 100;
  Lines[1].Quantity := 2; Lines[1].UnitPrice := 25;
  AssertEquals(150.0, Double(InvoiceNet(Lines)), 0.001);
end;

procedure TInvoiceTest.VatIsRounded;
begin
  AssertEquals(19.0, Double(VatAmount(100, 19)), 0.001);
end;

var
  App: TTestRunner;
begin
  RegisterTest(TInvoiceTest);
  App := TTestRunner.Create(nil);
  try
    App.Initialize;
    App.Title := 'Invoice tests';
    App.Run;
  finally
    App.Free;
  end;
end.
