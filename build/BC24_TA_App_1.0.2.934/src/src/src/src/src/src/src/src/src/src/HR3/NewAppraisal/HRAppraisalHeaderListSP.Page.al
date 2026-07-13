Page 51117 "HR Appraisal Header List - SP"
{
    CardPageID = "HR Appraisal Header Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "HR Appraisal Header - UP";
    SourceTableView = where(Status = const(Supervisor));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Appraisal No"; Rec."Appraisal No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appraisal No field.';
                }
                field("Supervisor User ID."; Rec."Supervisor User ID.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Supervisor User ID. field.';
                }
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Picture field.';
                }
                field("Appraisal Period"; Rec."Appraisal Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appraisal Period field.';
                }
                field("Appraisal Stage"; Rec."Appraisal Stage")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appraisal Stage field.';
                }
                field(Sent; Rec.Sent)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sent field.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field(Recommendations; Rec.Recommendations)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Recommendations field.';
                }
                field("Date of First Appointment"; Rec."Date of First Appointment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of First Appointment field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000012; Notes) { }
        }
    }

    actions { }
}

