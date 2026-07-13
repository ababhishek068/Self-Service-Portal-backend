Page 50301 "Proposal Check List"
{
    PageType = List;
    SourceTable = "Proposal Check List";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Task; Rec.Task)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Task field.';
                }
                field(ResponsibleOffice; Rec."Responsible Office")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsible Office field.';
                }
                field(DueDate; Rec."Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Due Date field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control11; Notes) { }
            systempart(Control12; MyNotes) { }
            systempart(Control13; Links) { }
            systempart(Control14; Outlook) { }
        }
    }

    actions { }
}

