Page 50933 "Other Incidents"
{
    PageType = Document;
    SourceTable = "Other Incidents";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(IncidentDate; Rec."Incident Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Incident Date field.';
                }
                field(Incident; Rec.Incident)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Incident field.';
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

