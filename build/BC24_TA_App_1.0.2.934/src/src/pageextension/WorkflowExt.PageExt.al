pageextension 50054 "Workflow Ext" extends Workflow
{
    layout { }
    trigger OnOpenPage()
    begin
        if UserRec.get(database.UserId) then begin
            IF UserRec."Can Manage Workflow" = FALSE then
                ERROR('Please note that you dont have the rights to change workflow!');
        end else begin
            ERROR('Please note that you dont have the rights to change workflow!');
        end;
    end;

    var
        UserRec: record "User Setup";
}