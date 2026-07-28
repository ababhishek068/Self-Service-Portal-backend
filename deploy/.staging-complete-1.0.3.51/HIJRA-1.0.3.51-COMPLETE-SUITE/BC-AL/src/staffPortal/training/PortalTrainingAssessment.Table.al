/// <summary>Complete SSP Training Need Assessment keyed by the ERP training application.</summary>
table 52120 "Portal Training Assessment"
{
    Caption = 'Portal Training Need Assessment';
    DataClassification = CustomerContent;
    DrillDownPageId = "Portal Training Assessments";
    LookupPageId = "Portal Training Assessments";

    fields
    {
        field(1; "Application No"; Code[20]) { Caption = 'Training Application No.'; }
        field(2; "Employee No."; Code[20]) { Caption = 'Employee No.'; }
        field(3; Purpose; Text[500]) { Caption = 'Purpose / Expected Outcome'; }
        field(4; "Other Training Name"; Text[100]) { Caption = 'Other Training Name'; }
        field(5; "Training Type"; Text[30]) { Caption = 'Training Type'; }
        field(6; "Duration Days"; Decimal) { Caption = 'Duration (Days)'; }
        field(7; "Target Group"; Text[100]) { Caption = 'Target Group'; }
        field(8; "No. of Participants"; Integer) { Caption = 'No. of Participants'; }
        field(9; Quarter; Code[10]) { Caption = 'Quarter'; }
        field(10; Priority; Text[20]) { Caption = 'Priority'; }
        field(11; "Recommended Vendor"; Text[100]) { Caption = 'Recommended Vendor / Provider'; }
        field(12; "Estimated Budget"; Text[50]) { Caption = 'Estimated Budget'; }
        field(13; Remark; Text[250]) { Caption = 'Remark'; }
        field(14; "Submitted On"; DateTime) { Caption = 'Submitted On'; Editable = false; }
        field(15; "Training Need Code"; Code[30]) { Caption = 'Training Need'; }
        field(16; "Requester User ID"; Code[50]) { Caption = 'Requester User ID'; }
        field(17; "Supervisor User ID"; Code[50]) { Caption = 'Immediate Supervisor'; }
        field(18; "Department Code"; Code[20]) { Caption = 'Department'; }
        field(19; "Training Start Date"; Date) { Caption = 'Training Period Start'; }
        field(20; "Training End Date"; Date) { Caption = 'Training Period End'; }
    }

    keys
    {
        key(PK; "Application No") { Clustered = true; }
        key(Employee; "Employee No.") { }
    }

    trigger OnInsert()
    begin
        "Submitted On" := CurrentDateTime;
    end;
}
