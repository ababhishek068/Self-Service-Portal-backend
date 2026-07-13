page 51109 "HR Long Listing List"
{
    CardPageID = "HR Long listing Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "HR Employee Requisitions";
    SourceTableView = WHERE(Status = CONST(Approved), Closed = const(false));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Requisition No."; Rec."Requisition No.")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Requisition No. field.';
                }
                field("Job Description"; Rec."Job Description")
                {
                    ToolTip = 'Specifies the value of the Job Description field.';
                }
                field("Requisition Date"; Rec."Requisition Date")
                {
                    ToolTip = 'Specifies the value of the Requisition Date field.';
                }
                field(Requestor; Rec.Requestor)
                {
                    ToolTip = 'Specifies the value of the Requestor field.';
                }
                field("Reason For Request"; Rec."Reason For Request")
                {
                    ToolTip = 'Specifies the value of the Reason For Request field.';
                }
                field(Closed; Rec.Closed)
                {
                    ToolTip = 'Specifies the value of the Closed field.';
                }

            }
        }
        area(factboxes)
        {
            systempart(Outlook; Outlook) { }
        }
    }

    actions { }
}

