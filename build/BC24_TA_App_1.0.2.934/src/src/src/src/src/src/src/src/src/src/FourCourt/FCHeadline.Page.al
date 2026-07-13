page 51391 "FC Headline"
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

                field(ServiceCountText; ServiceCountText)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ServiceCountText field.';
                    //Visible = ServiceCount <> 0;
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
        HREmp: Record "Salesperson/Purchaser";
        Pumps: Record Pump;
        Tanks: Record Tanks;

    begin
        HREmp.Reset();
        // HREmp.SetRange(Status, HREmp.Status::Active);
        ActiveStaffCount := HREmp.Count();
        ActiveEmployeeCountText := ActiveEmployeesLbl + Format(ActiveStaffCount);

        Pumps.Reset();
        InActiveStaffCount := Pumps.Count();
        ExitCountText := ExitLbl + Format(InActiveStaffCount);

        Tanks.Reset();
        ServiceCount := Tanks.Count();
        ServiceCountText := ServiceLbl + Format(ServiceCount);






        Welcome := WelcomeLbl;
    end;

    var
        WelcomeLbl: Label 'Welcome: Fore Court Rolecenter';
        ActiveEmployeesLbl: Label 'Total Number of Pump Attendance are ';
        ServiceLbl: Label 'Total Number of tanks are ';
        ExitLbl: Label 'Total Number of pumps are ';
        Welcome: Text;
        ActiveEmployeeCountText: Text;
        ServiceCountText: Text;
        ExitCountText: Text;
        ActiveStaffCount: Integer;
        InActiveStaffCount: Integer;


        ServiceCount: Integer;

}