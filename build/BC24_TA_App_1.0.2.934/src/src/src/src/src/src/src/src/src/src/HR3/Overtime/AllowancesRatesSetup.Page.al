
Page 51537 "Allowances Rates  Setup"
{
    PageType = List;
    SourceTable = "Allowances Rates Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Allowance Code";"Allowance Code")
                {
                    ApplicationArea = Basic;
                }
                field("Allowance Name";"Allowance Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Job Title";"Job Title")
                {
                    ApplicationArea = Basic;
                    Visible=false;
                }
                field("Job Description";"Job Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible=false;
                }
                field("6AM-6PM";"6AM-6PM"){}
                field("6PM-10PM";"6PM-10PM"){}
                field("10PM-6AM";"10Pm-6AM"){}
                field(Weekend;rec.Weekend){
                    ApplicationArea = Basic;
                }
                
                field("Public Holiday Rate";rec."Public Holiday Rate"){
                    ApplicationArea = Basic;
                }
                field("Formula Based On";rec."Formula Based On"){
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if Usersetup.Get(UserId) then begin
          if not Usersetup."View Payroll" then
            Error('Permission denied');
         end else begin
          Error('User Not Setup',UserId);
         end;
    end;

    var
        Usersetup: Record "User Setup";
        hrcalendar: Record "HR Leave Calendar";
        hrcalendarlines: Record "HR Leave Calendar Lines";
}

