namespace ABH_UAT.ABH_UAT;

page 51514 "Orientation Header-Open"
{
    ApplicationArea = All;
    Caption = 'Orientation Header-Open';
    PageType = Card;
    SourceTable = "Staff Orientation Header";
    SourceTableView=WHERE(Status=CONST(Open));
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("Employee No"; Rec."Employee No")
                {
                    ToolTip = 'Specifies the value of the Employee No field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                    Editable=false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                }
                field("Global Dimension 3 Code"; Rec."Global Dimension 3 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 3 Code field.', Comment = '%';
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the value of the Job Title field.', Comment = '%';
                }
                field("Mobile No"; Rec."Mobile No")
                {
                    ToolTip = 'Specifies the value of the Mobile No field.', Comment = '%';
                }
                field(Manager; Rec.Manager)
                {
                    ToolTip = 'Specifies the value of the Manager field.', Comment = '%';
                }
                field("Manager's Name"; Rec."Manager's Name")
                {
                    ToolTip = 'Specifies the value of the Manager''s Name field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Employment Date"; Rec."Employment Date")
                {
                    ToolTip = 'Specifies the value of the Employment Date field.', Comment = '%';
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.', Comment = '%';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the value of the Due Date field.', Comment = '%';
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
            }
            part(checklist; "Orientation Checklist Lines")
            {
                SubPageLink = "Employee No"=FIELD("Employee No");
            }
        }
    }
}
