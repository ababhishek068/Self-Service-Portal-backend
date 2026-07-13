namespace ABH_UAT.ABH_UAT;

page 51502 "Commitee Creation"
{
    ApplicationArea = All;
    Caption = 'Commitee Creation';
    PageType = Card;
    SourceTable = "Tender Commitee Appointment";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("Appointment No"; Rec."Appointment No")
                {
                    ToolTip = 'Specifies the value of the Appointment No field.', Comment = '%';
                }
                field("Committee ID"; Rec."Committee ID")
                {
                    ToolTip = 'Specifies the value of the Committee ID field.', Comment = '%';
                }
                field("Committee Name"; Rec."Committee Name")
                {
                    ToolTip = 'Specifies the value of the Committee Name field.', Comment = '%';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Specifies the value of the Creation Date field.', Comment = '%';
                }
                field("Deadline For Report Submission"; Rec."Deadline For Report Submission")
                {
                    ToolTip = 'Specifies the value of the Deadline For Report Submission field.', Comment = '%';
                }
                field("No. Series"; Rec."No. Series")
                {
                    ToolTip = 'Specifies the value of the No. Series field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                }
                field("Tender/Quotation No"; Rec."Tender/Quotation No")
                {
                    ToolTip = 'Specifies the value of the Tender/Quotation No field.', Comment = '%';
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.', Comment = '%';
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field.', Comment = '%';
                }
            }
        }
    }
}
