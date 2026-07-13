
Page 51219 "HR Lookup Values List"
{
    PageType = List;
    SourceTable = "HR Lookup Values";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Qualification Type"; Rec."Qualification Type")
                {
                    ApplicationArea = Basic;
                    Visible = true;
                    ToolTip = 'Specifies the value of the Qualification Type field.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic;
                    Visible = true;
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field("Sub Category"; Rec."Sub Category")
                {
                    ApplicationArea = Basic;
                    Visible = true;
                    ToolTip = 'Specifies the value of the Sub Category field.';
                }
                field("Employee Type"; Rec."Employee Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Type field.';

                }
            }
        }
    }

    actions
    {
        area(navigation) { }
    }
}

