pageextension 50070 "Gen Journals Ext" extends "General Journal Batches"
{
    trigger OnOpenPage()
    begin
        if usersetup.Get(UserId) then begin
            if usersetup."Post JVs" = false then
                Error('This feature has been suspended. Please contact System administrator');
        end;

    end;

    var
        usersetup: Record "User Setup";

}


