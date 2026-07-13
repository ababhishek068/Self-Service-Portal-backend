Page 51216 "Emp Disciplinary Cases"
{
    PageType = ListPart;
    SourceTable = "Employee Disciplinary Cases";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(RefferenceNo; Rec."Refference No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Refference No field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(DisciplinaryCase; Rec."Disciplinary Case")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disciplinary Case field.';
                }
                field(CasesDiscusion; Rec."Cases Discusion")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cases Discusion field.';
                }
                field(RecommendedAction; Rec."Recommended Action")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Recommended Action field.';
                }
                field(CaseDescription; Rec."Case Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Case Description field.';
                }
                field(AccusedDefence; Rec."Accused Defence")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Accused Defence field.';
                }
                field(Witness1; Rec."Witness #1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Witness #1 field.';
                }
                field(Witness2; Rec."Witness #2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Witness #2 field.';
                }
                field(ActionTaken; Rec."Action Taken")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Action Taken field.';
                }
                field(DateTaken; Rec."Date Taken")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Taken field.';
                }
                field(DocumentLink; Rec."Document Link")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document Link field.';
                }
                field(DisciplinaryRemarks; Rec."Disciplinary Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disciplinary Remarks field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
            }
        }
    }

    actions { }
}

