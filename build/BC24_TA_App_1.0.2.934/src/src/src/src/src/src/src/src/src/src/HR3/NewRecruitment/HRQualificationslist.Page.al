page 51252 "HR Qualifications list"
{
    PageType = List;
    SourceTable = "HR Job Qualifications";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Qualification Type"; Rec."Qualification Type")
                {
                    ToolTip = 'Specifies the value of the Qualification Type field.';
                }
                field(Code; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Level; Rec.Level)
                {
                    ToolTip = 'Specifies the value of the Level field.';
                }
                field(Order; Rec.Order)
                {
                    ToolTip = 'Specifies the value of the Order field.';
                }
                field("Category Description"; Rec."Category Description")
                {
                    ToolTip = 'Specifies the value of the Category Description field.';
                }
                field(Category; Rec.Category)
                {
                    ToolTip = 'Specifies the value of the Category field.';
                }
            }
        }
    }

    actions { }
}

