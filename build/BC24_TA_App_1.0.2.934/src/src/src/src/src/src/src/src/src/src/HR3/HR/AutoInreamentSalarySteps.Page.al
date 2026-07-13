Page 50407 "Auto. Inreament Salary Steps"
{
    Caption = 'Salary Steps Per Grade';
    DataCaptionFields = "Employee Category", "Salary Grade", Step;
    Description = 'Salary Steps Per Grade';
    PageType = List;
    SourceTable = "Auto. Inreament Salary Steps";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Step; Rec.Step)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Step field.';
                }
                field(BasicSalary; Rec."Basic Salary")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Basic Salary field.';
                }
            }
        }
    }

    actions { }
}

