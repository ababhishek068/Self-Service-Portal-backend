Page 51107 "HR Job Qualification Types - L"
{
    Caption = 'HR Job Qualification Types';
    PageType = List;
    SourceTable = "HR Job Qualification Types";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(QualificationType; Rec."Qualification Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification Type field.';
                }
                field(QualificationCode; Rec."Qualification Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification Code field.';
                }
                field(QualificationDescription; Rec."Qualification Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }

    actions { }
}

