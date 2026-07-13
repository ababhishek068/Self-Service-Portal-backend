Page 51053 "HMS Patient Medical Condition"
{
    PageType = ListPart;
    SourceTable = "HMS Patient Medical Condition";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(MedicalCondition; Rec."Medical Condition")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Medical Condition field.';
                }

                field(DateFrom; Rec."Date From")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date From field.';
                }
                field(DateTo; Rec."Date To")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date To field.';
                }
                field(Yes; Rec.Yes)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Yes field.';
                }
                field(Details; Rec.Details)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Details field.';
                }
            }
        }
    }

    actions { }
}

