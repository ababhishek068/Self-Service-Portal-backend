Page 50794 "HMS Setup Diagnosis List"
{
    PageType = List;
    SourceTable = "HMS Setup Diagnosis";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Diagnosis; Rec.Diagnosis)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Diagnosis field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(NewDiagnosis)
            {
                ApplicationArea = Basic;
                Caption = 'New Diagnosis';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS Setup Diagnosis Card";
                ToolTip = 'Executes the New Diagnosis action.';
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

