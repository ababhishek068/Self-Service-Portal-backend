/// <summary>HR view of complete portal Training Need Assessments and their routing.</summary>
page 52120 "Portal Training Assessments"
{
    Caption = 'Portal Training Need Assessments';
    PageType = List;
    SourceTable = "Portal Training Assessment";
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTableView = sorting("Application No") order(descending);

    layout
    {
        area(Content)
        {
            repeater(Assessments)
            {
                field("Application No"; Rec."Application No") { ApplicationArea = All; }
                field("Employee No."; Rec."Employee No.") { ApplicationArea = All; }
                field("Training Need Code"; Rec."Training Need Code") { ApplicationArea = All; }
                field("Other Training Name"; Rec."Other Training Name") { ApplicationArea = All; }
                field("Requester User ID"; Rec."Requester User ID") { ApplicationArea = All; }
                field("Supervisor User ID"; Rec."Supervisor User ID") { ApplicationArea = All; }
                field("Approval Status"; ApprovalStatus) { ApplicationArea = All; Caption = 'Approval Status'; }
                field("Training Type"; Rec."Training Type") { ApplicationArea = All; }
                field("Duration Days"; Rec."Duration Days") { ApplicationArea = All; }
                field("Target Group"; Rec."Target Group") { ApplicationArea = All; }
                field("No. of Participants"; Rec."No. of Participants") { ApplicationArea = All; }
                field(Quarter; Rec.Quarter) { ApplicationArea = All; }
                field(Priority; Rec.Priority) { ApplicationArea = All; }
                field("Recommended Vendor"; Rec."Recommended Vendor") { ApplicationArea = All; }
                field("Estimated Budget"; Rec."Estimated Budget") { ApplicationArea = All; }
                field(Purpose; Rec.Purpose) { ApplicationArea = All; }
                field(Remark; Rec.Remark) { ApplicationArea = All; }
                field("Submitted On"; Rec."Submitted On") { ApplicationArea = All; }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        TrainingHeader: Record "HR Training Applications";
    begin
        Clear(ApprovalStatus);
        if TrainingHeader.Get(Rec."Application No") then
            ApprovalStatus := Format(TrainingHeader.Status);
    end;

    var
        ApprovalStatus: Text[30];
}
