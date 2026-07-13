Page 50378 "Asset Incident List"
{
    CardPageID = "Asset Incident Card";
    Editable = false;
    PageType = List;
    SourceTable = "Asset Incident";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(IncidentNo; Rec."Incident No.")
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Incident No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(IncidentType; Rec."Incident Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Incident Type field.';
                }
                field(DateReported; Rec."Date Reported")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Date Reported field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Style = Attention;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

    actions { }
}

