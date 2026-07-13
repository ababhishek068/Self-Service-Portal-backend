Page 50931 "HR Job Responsiblities Lines"
{
    CardPageID = "HR Job Responsibilities";
    PageType = List;
    SourceTable = "Employee Responsibility";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(ResponsibilityCode; Rec."Responsibility Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Responsibility Code field.';
                }
                field(ResponsibilityDescription; Rec."Responsibility Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Description field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }

    actions { }
}

