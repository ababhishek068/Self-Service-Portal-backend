page 51465 "Internal Emp History Lines"
{
    PageType = ListPart;
    SourceTable = "Internal Employment History";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(From; Rec.From)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From field.';
                }
                field(ToDate; Rec."To Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To Date field.';
                }
                field("Ref No";"Ref No"){}
                field("Global Dimension 1 Code"; "Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code") { }
                field("Global Dimension 3 Code"; "Global Dimension 3 Code") { }
                //field(Process; Process) { }
                //field(Sector; Sector) { }
                field("Job ID"; "Job ID") { }
                field(JobTitle; Rec."Job Title")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Title field.';
                }
                field(KeyExperience; Rec."Key Experience")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Key Experience field.';
                }
                field(SalaryOnLeaving; Rec."Salary On Leaving")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Salary On Leaving field.';
                }
                field("Reason for Change"; "Reason for Change") { }
                field("Reason Description"; "Reason Description") { }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comment field.';
                }
            }
        }
    }

    actions { }
}

