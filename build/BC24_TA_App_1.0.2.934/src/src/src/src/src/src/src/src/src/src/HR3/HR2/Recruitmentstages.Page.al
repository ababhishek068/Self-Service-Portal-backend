Page 51328 "Recruitment stages"
{
    PageType = ListPart;
    SourceTable = "HR Recruitment Stages";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Qualified Applicants"; Rec."Qualified Applicants")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Qualified Applicants field.';
                }


            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(StageShortlisting)
            {
                Caption = 'Shortlist By Stage';
                ApplicationArea = basic;
                ToolTip = 'Executes the Shortlist By Stage action.';
                trigger OnAction()
                var
                    jApp: Record "HR Job Applicants";
                    Shortlisting: report "HR Applicants Shortlisting";
                begin
                    jApp.SetRecFilter;
                    jApp.SetFilter(jApp."Stage Filter", Rec.code);
                    jApp.SetFilter(jApp."Employee Requisition No", Rec."Employee Requisition Filter");
                    Shortlisting.SetTableView(jApp);
                    Shortlisting.Run;
                end;

            }
        }
    }
}

