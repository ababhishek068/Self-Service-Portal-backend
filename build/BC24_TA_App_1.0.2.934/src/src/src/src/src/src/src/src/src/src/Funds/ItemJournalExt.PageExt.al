pageextension 50036 "Item Journal Ext" extends "Item Journal"
{
    layout { }
    actions { }
    trigger OnOpenPage()
    var
        UserRec: record "User Setup";
    begin
        UserRec.Get(Database.UserId);
        UserRec.TestField("Can Create Item");
    end;
}