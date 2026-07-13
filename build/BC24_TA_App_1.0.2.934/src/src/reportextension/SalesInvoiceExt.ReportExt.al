reportextension 50001 "Sales Invoice Ext." extends "Standard Sales - Invoice"
{
    dataset
    {
        add(Header)
        {
            column(compPic; CompInfo.Picture) { }
            column(PreparedBy; "Prepared By") { }
            column(Currency_Code; "Currency Code") { }
            column(currencySymbolLbl; currencySymbolLbl) { }
            column(SymbolCurrency; SymbolCurrency) { }
        }
        modify(Header)
        {
            trigger OnAfterAfterGetRecord()
            begin
                CalcFields("Prepared By");
                currencySymbolLbl := '';
                if Header."Currency Code" <> '' then
                    currencySymbolLbl := 'Currency Code';

                SymbolCurrency := GetCurrencySymbol();

                if CountrySetup.Get(Header."Bill-to Country/Region Code") then
                    CustomerCountry := CountrySetup.Name;
            end;
        }

    }
    trigger OnPreReport()
    begin
        if CompInfo.Get() then begin
            CompInfo.CalcFields(CompInfo.Picture);
            CompInfo.CalcFields(CompInfo."Company Watermark");
        end;
    end;

    var
        CompInfo: Record "Company Information";
        CountrySetup: Record "Country/Region";
        CustomerRec: Record Customer;
        SymbolCurrency: Text;
        currencySymbolLbl: Text;
        CustomerCountry: Text;

}
