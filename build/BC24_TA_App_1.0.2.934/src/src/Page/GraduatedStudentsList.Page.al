Page 50072 "Graduated Students List"
{
    PageType = List;
    SourceTable = "Graduated Students";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(StudentNo; Rec."Student No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student No field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
            }
        }
    }

    actions { }
}

