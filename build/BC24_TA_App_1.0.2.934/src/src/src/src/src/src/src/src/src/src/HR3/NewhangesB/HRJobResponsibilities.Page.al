Page 51316 "HR Job Responsibilities"
{
    Caption = 'HR Job Responsibilities';
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = ListPart;
    PromotedActionCategories = 'New,Process,Reports,Qualification';
    SourceTable = "Employee Responsibility";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'Job Details';
                field("Job ID"; Rec."Job ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Job ID field.';
                }
                field(ResponsibilityDescription; Rec."Responsibility Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Description field.';
                }

            }
        }

    }
}

