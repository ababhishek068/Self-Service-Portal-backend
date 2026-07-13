page 51111 "HR Shortlisting List"
{
    CardPageID = "HR Shortlisting Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "HR Employee Requisitions";
    SourceTableView = WHERE(Closed = CONST(false));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Requisition No."; Rec."Requisition No.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Requisition No. field.';
                }
                field("Job Description"; Rec."Job Description")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Job Description field.';
                }
                field("Requisition Date"; Rec."Requisition Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Requisition Date field.';
                }
                field(Requestor; Rec.Requestor)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Requestor field.';
                }
                field("Reason For Request"; Rec."Reason For Request")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Reason For Request field.';
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Closed field.';
                }
                field("Closing Date"; Rec."Closing Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Closing Date field.';
                }
            }
        }
        area(factboxes)
        {
            part(Control1102755006; "HR Jobs Factbox")
            {
                ApplicationArea = basic;
                SubPageLink = "Job ID" = FIELD("Job ID");
            }
            systempart(Control1102755005; Outlook) { }
        }
    }

    actions { }
}

