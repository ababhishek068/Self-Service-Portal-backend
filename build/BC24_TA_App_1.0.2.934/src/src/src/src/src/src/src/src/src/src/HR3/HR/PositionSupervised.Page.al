Page 50935 "Position Supervised"
{
    PageType = ListPart;
    SourceTable = "Position Supervised";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(JobID; Rec."Position Supervised")
                {
                    ApplicationArea = Basic;
                    Caption = 'Job ID';
                    ToolTip = 'Specifies the value of the Job ID field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
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

