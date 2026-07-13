Page 51180 "HMS Dosage Setup"
{
    PageType = List;
    SourceTable = "HMS Dosage Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DoseCode; Rec."Dose Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dose Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(CalculateDosage; Rec."Calculate Dosage")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Calculate Dosage field.';
                }
            }
        }
    }

    actions { }
}

