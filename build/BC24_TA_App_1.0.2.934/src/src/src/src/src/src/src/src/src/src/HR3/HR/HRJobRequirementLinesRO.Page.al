Page 51002 "HR Job Requirement Lines(RO)"
{
    Caption = 'HR Job Requirements';

    PageType = List;
    SourceTable = "HR Jobs Requirements";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
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
                    Editable = false;
                    ToolTip = 'Specifies the value of the Qualification Description field.';
                }
                field(NeedCode; Rec."Need Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Need code field.';
                }

                field(Control1102755017; Rec."Qualification Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification Description field.';
                }
            }
        }
    }

    actions { }
}

