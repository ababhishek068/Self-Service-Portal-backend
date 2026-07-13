Page 51268 "HR Employee Requisitions List"
{
    CardPageID = "HR Employee Requisition Card";
    DelayedInsert = true;
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Job,Functions,Employee';
    ShowFilter = true;
    SourceTable = "HR Employee Requisitions";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                Editable = false;
                field(RequisitionNo; Rec."Requisition No.")
                {
                    ApplicationArea = Basic;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Requisition No. field.';
                }
                field(JobID; Rec."Job ID")
                {
                    ApplicationArea = Basic;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Job ID field.';
                }
                field(JobDescription; Rec."Job Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Description field.';
                }
                field("Employee-Type"; "Employee-Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if employee isinternal or Outsourced.';
                }

                field(ReasonForRequest; Rec."Reason For Request")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reason For Request field.';
                }
                field(RequiredPositions; Rec."Required Positions")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Required Positions field.';
                }
                field(TypeofContractRequired; Rec."Type of Contract Required")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Type of Contract Required field.';
                }

                field(Closed; Rec.Closed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Closed field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755008; Outlook) { }
        }
    }

    actions { }


    procedure TESTFIELDS()
    begin
        Rec.TestField("Requisition Date");
        //  TestField("Recruitment Closing Date");
        Rec.TestField("Type of Contract Required");
        Rec.TestField("Requisition Type");
        Rec.TestField("Required Positions");
        if Rec."Reason For Request" = Rec."reason for request"::Other then
            Rec.TestField("Reason for Request(Other)");
    end;
}

