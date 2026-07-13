Page 51079 "HR Stage Requirement Lines"
{
    PageType = List;
    SourceTable = "HR Stage Requirements";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Qualification Type"; Rec."Qualification Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification Type field.';
                }
                field("Qualification Category"; Rec."Qualification Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification Category field.';
                }
                field("Qualification Code"; Rec."Qualification Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification Code field.';
                }


                field(QualificationDescription; Rec."Qualification Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Qualification Description field.';
                }
                field(GradeAttained; Rec."Grade Attained")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Grade Attained field.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Priority field.';
                }
                field(DesiredScore; Rec."Desired Score")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Desired Score field.';
                }
                field(TotalStageDesiredScore; Rec."Total (Stage)Desired Score")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Total (Stage)Desired Score field.';
                }
                field(Mandatory; Rec.Mandatory)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Mandatory field.';
                }
                field(Interview; Rec.Interview)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Interview field.';
                }
            }
        }
    }

    actions { }
}

