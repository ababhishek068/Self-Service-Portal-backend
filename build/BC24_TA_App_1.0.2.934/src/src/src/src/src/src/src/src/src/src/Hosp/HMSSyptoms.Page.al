Page 50832 "HMS Syptoms"
{
    PageType = List;
    SourceTable = "HMS Symptoms Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Treatmentno; Rec."Treatment no")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Treatment no field.';
                }
                field(SyptomCode; Rec."Syptom Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Syptom Code field.';
                }
                field(SymptomName; Rec."Symptom Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Symptom Name field.';
                }
            }
        }
    }

    actions { }
}

