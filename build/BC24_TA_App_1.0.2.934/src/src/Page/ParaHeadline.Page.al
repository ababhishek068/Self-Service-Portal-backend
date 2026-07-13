page 50176 "Para Headline"
{
    PageType = HeadlinePart;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                ShowCaption = false;
                field(Welcome; Welcome)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Welcome field.';
                }
                field(ActiveEmployeeCountText; ActiveEmployeeCountText)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ActiveEmployeeCountText field.';
                }
                field(PARACountText; PARACountText)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PARACountText field.';
                    //Visible = ServiceCount <> 0;
                }
                field(ServiceCountText; ServiceCountText)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ServiceCountText field.';
                    //Visible = ServiceCount <> 0;
                }
                field(TVETCountText; TVETCountText)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TVETCountText field.';
                    // Visible = TvetCount <> 0;
                }
                field(ExitCountText; ExitCountText)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ExitCountText field.';
                    //  Visible = InActiveStaffCount <> 0;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        HREmp: Record "Registration Form";

    begin
        HREmp.Reset();
        // HREmp.SetRange(Status, HREmp.Status::Active);
        ActiveStaffCount := HREmp.Count();
        ActiveEmployeeCountText := ActiveEmployeesLbl + Format(ActiveStaffCount);

        HREmp.Reset();
        HREmp.SetFilter(Status, '%1', HREmp.Status::Exited);
        InActiveStaffCount := HREmp.Count();
        ExitCountText := ExitLbl + Format(InActiveStaffCount);

        HREmp.Reset();
        HREmp.SetFilter(Status, '%1', HREmp.Status::Service);
        ServiceCount := HREmp.Count();
        ServiceCountText := ServiceLbl + Format(ServiceCount);

        HREmp.Reset();
        HREmp.SetFilter(Status, '%1', HREmp.Status::TVET);
        TvetCount := HREmp.Count();
        TVETCountText := TVETLbl + Format(TvetCount);

        HREmp.Reset();
        HREmp.SetFilter(Status, '%1', HREmp.Status::Confirmed);
        ParaCount := HREmp.Count();
        ParaCountText := PARALbl + Format(ParaCount);

        Welcome := WelcomeLbl;
    end;

    var
        WelcomeLbl: Label 'Welcome: Paramilitary & National Service Rolecenter';
        ActiveEmployeesLbl: Label 'Active Recruits are ';
        TVETLbl: Label 'Recruits at TVET are ';
        ServiceLbl: Label 'Recruits at National Service are ';
        ParaLbl: Label 'Recruits at Paramilitary are ';
        ExitLbl: Label 'Recruits at Exited are ';
        Welcome: Text;
        ActiveEmployeeCountText: Text;
        TVETCountText: Text;
        PARACountText: Text;
        ServiceCountText: Text;
        ExitCountText: Text;
        ActiveStaffCount: Integer;
        InActiveStaffCount: Integer;
        ServiceCount: Integer;
        TvetCount: Integer;
        ParaCount: Integer;

}