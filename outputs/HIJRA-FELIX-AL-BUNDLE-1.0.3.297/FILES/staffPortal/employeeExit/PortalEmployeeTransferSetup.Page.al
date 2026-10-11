page 52130 "Portal Employee Transfer Setup"
{
    Caption = 'Portal Employee Transfer Setup';
    PageType = Card;
    SourceTable = "Portal Employee Transfer Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(ApprovalRouting)
            {
                Caption = 'Approval Routing';

                field("Immediate Supervisor User ID"; Rec."Immediate Supervisor User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Used when the requester has no Approver ID on their User Setup card. Routes Transfer and Resignation to this supervisor first.';
                }
                field("HR Approver User ID"; Rec."HR Approver User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the HR user who receives Employee Transfer and Employee Resignation requests only after the Immediate Supervisor approves them.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get(SetupKeyTok) then begin
            Rec.Init();
            Rec."Primary Key" := SetupKeyTok;
            Rec.Insert(true);
        end;
    end;

    var
        SetupKeyTok: Label 'TRANSFER', Locked = true;
}
