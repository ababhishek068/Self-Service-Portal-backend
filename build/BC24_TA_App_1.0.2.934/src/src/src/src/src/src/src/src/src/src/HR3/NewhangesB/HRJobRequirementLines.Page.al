Page 51318 "HR Job Requirement Lines"
{
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
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Qualification Type field.';
                }
                field(QualificationCategory; Rec."Qualification Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification Category field.';
                }
                field(QualificationCode; Rec."Qualification Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Qualification Code field.';
                }
                field(QualificationDescription; Rec."Qualification Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Qualification Description field.';
                }

                field("Minimum Score"; Rec."Minimum Score")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minimum Score field.';
                }
                field(Mandatory; Rec.Mandatory)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Mandatory field.';
                }
            }
        }
    }

    actions { }
}