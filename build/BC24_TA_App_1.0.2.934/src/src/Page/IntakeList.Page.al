Page 50134 "Intake List"
{
    PageType = List;
    SourceTable = Intake;
    CardPageId = "Intake Card";
    UsageCategory = Lists;
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Current; Rec.Current)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current field.';
                }
                field("Current Semester"; Rec."Current Semester")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Current Semester field.';
                }
                field(ReportingDate; Rec."Reporting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reporting Date field.';
                }
                field(ReportingEndDate; Rec."Reporting End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reporting End Date field.';
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Closed field.';
                }
                field(Fees2ndInstalmentDeadline; Rec."Fees 2nd Instalment Deadline")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Fees 2nd Instalment Deadline field.';
                }
                field(Programme; Rec.Programme)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme field.';
                }
            }
        }
    }

    actions { }
}

