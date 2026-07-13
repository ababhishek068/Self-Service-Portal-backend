Page 50067 "Grants Manager Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "Job Cue";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            cuegroup(PendingProjects)
            {
                Caption = 'Pending Projects';
                field(Projects; Rec.Projects)
                {
                    ApplicationArea = Basic;
                    Caption = 'Projects Pending Approvals';
                    ToolTip = 'Specifies the value of the Projects Pending Approvals field.';
                }

                actions
                {
                    action(JobCreateSalesInvoice)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Job Create Sales Invoice';
                        Image = CreateJobSalesInvoice;
                        RunObject = Report "Job Create Sales Invoice";
                        ToolTip = 'Executes the Job Create Sales Invoice action.';
                    }
                }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;

        Rec.SetFilter("Date Filter", '>=%1', WorkDate);
        Rec.SetFilter("Date Filter2", '<%1&<>%2', WorkDate, 0D);
    end;
}

