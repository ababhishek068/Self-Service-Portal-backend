tableextension 50050 ExtPurchOrder extends "Purchase Header"
{
    fields
    {
        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            begin
                if "Currency Code" <> '' then
                    curr.Reset();
                curr.SetRange(curr."Starting Date", Today);
                curr.SetRange(curr."Currency Code", "Currency Code");
                if not curr.find() then begin
                    //Error('Currency code for today must be set up');
                end;


            end;
        }
    }

    var
        curr: Record "Currency Exchange Rate";
        curcodes: record Currency;
}
