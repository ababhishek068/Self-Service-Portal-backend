Page 51199 "Conference Requests"
{
    Caption = 'Conference Requests';
    CardPageID = "Conference Card";
    PageType = List;
    SourceTable = "Conference Attendance";
    SourceTableView = where(Status = filter(New));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ReqNo; Rec."Req No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Req No. field.';
                }
                field(ReqCategory; Rec."Req. Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Req. Category field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(DegreeProgram; Rec."Degree Program")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Degree Program field.';
                }
                field(DateofPresentation; Rec."Date of Presentation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Presentation field.';
                }
                field(RequestedDate; Rec."Requested Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requested Date field.';
                }
                field(RequestedBy; Rec."Requested By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requested By field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

    actions { }
}

