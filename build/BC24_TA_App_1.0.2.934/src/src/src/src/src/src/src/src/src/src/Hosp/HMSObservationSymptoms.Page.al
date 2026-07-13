Page 51056 "HMS Observation Symptoms"
{
    PageType = ListPart;
    SourceTable = "HMS Observation Symptoms";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(System; Rec.System)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the System field.';
                }
                field(SymptomCode; Rec."Symptom Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Symptom Code field.';
                }
                field(SymptomDescription; Rec."Symptom Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Symptom Description field.';
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Duration field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Characteristics; Rec.Characteristics)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Characteristics field.';
                }
            }
        }
    }

    actions { }
}

