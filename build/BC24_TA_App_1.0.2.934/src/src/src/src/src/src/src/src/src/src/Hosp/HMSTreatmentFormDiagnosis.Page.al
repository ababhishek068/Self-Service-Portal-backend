Page 50820 "HMS Treatment Form Diagnosis"
{
    PageType = ListPart;
    SourceTable = "HMS Treatment Form Diagnosis";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(DiagnosisNo; Rec."Diagnosis No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Diagnosis No. field.';
                }
                field(DiagnosisCode; Rec."Diagnosis Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Diagnosis Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Confirmed; Rec.Confirmed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Confirmed field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }

    actions { }
}

