Page 51092 "HR Appraisal Period List"
{
    PageType = List;
    SourceTable = "HR Appraisal Periods - UP";
    ApplicationArea = All;

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
                field("Period Start Date"; Rec."Period Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Period Start Date field.';
                }
                field("Period End Date"; Rec."Period End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Period End Date field.';
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Open field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000007; Notes)
            {
                Editable = false;
            }
        }
    }

    actions { }
}

