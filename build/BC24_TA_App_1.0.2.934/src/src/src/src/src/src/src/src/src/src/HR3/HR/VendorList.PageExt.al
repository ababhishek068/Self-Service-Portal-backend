pageextension 50058 "Vendor List" extends "Vendor List"
{
    layout { }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnOpenPage()
    begin
        Rec.SetFilter("Vendor Type", '<>%1', Rec."Vendor Type"::Council);
    end;
}