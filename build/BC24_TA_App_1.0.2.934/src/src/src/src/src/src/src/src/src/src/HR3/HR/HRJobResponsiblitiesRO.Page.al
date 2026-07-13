Page 50848 "HR Job Responsiblities (RO)"
{
    Caption = 'Job Responsiblities';
    PageType = List;
    SourceTable = "Employee Responsibility";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(StartDate; Rec."Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(ResponsibilityCode; Rec."Responsibility Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Code field.';
                }
                field(EndDate; Rec."End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Position field.';
                }
            }
        }
    }

    actions { }
}

