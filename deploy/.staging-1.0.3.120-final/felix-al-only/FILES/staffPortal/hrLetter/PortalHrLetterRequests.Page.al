/// <summary>
/// HR's view of Self Service Portal letter requests. HR types the remarks on the line,
/// then uses Approve / Reject / Ready for Collection / Complete. The employee sees the
/// status and the remarks in the portal immediately.
/// </summary>
page 52140 "Portal HR Letter Requests"
{
    ApplicationArea = All;
    Caption = 'Portal HR Letter Requests';
    PageType = List;
    SourceTable = "Portal HR Letter Request";
    UsageCategory = Lists;
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    CardPageId = "Portal HR Letter Request Card";

    layout
    {
        area(Content)
        {
            repeater(Requests)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Letter Type"; Rec."Letter Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Required By Date"; Rec."Required By Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Submitted On"; Rec."Submitted On")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("HR Remarks"; Rec."HR Remarks")
                {
                    ApplicationArea = All;
                    ToolTip = 'Type the reason before approving or rejecting; the employee sees it in the portal.';
                }
                field("HR Decision By"; Rec."HR Decision By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("HR Decision On"; Rec."HR Decision On")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    DecideCurrent(true);
                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    DecideCurrent(false);
                end;
            }
            action(ReadyForCollection)
            {
                ApplicationArea = All;
                Caption = 'Ready for Collection';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.TestField(Status, Rec.Status::Approved);
                    Rec.Status := Rec.Status::ReadyForCollection;
                    Rec."Updated On" := CurrentDateTime;
                    Rec.Modify(true);
                end;
            }
            action(Complete)
            {
                ApplicationArea = All;
                Caption = 'Complete';
                Image = Completed;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if not (Rec.Status in [Rec.Status::Approved, Rec.Status::ReadyForCollection]) then
                        Error('Only approved letters can be completed.');
                    Rec.Status := Rec.Status::Completed;
                    Rec."Updated On" := CurrentDateTime;
                    Rec.Modify(true);
                end;
            }
        }
    }

    local procedure DecideCurrent(Approve: Boolean)
    begin
        if not (Rec.Status in [Rec.Status::Submitted, Rec.Status::InProgress]) then
            Error('Request %1 has already been decided.', Rec."No.");
        if DelChr(Rec."HR Remarks", '=', ' ') = '' then
            Error('Type the HR Remarks on the line first — the employee sees this reason in the portal.');
        if Approve then
            Rec.Status := Rec.Status::Approved
        else
            Rec.Status := Rec.Status::Rejected;
        Rec."HR Decision By" := CopyStr(UserId, 1, MaxStrLen(Rec."HR Decision By"));
        Rec."HR Decision On" := CurrentDateTime;
        Rec."Updated On" := CurrentDateTime;
        Rec.Modify(true);
    end;
}
