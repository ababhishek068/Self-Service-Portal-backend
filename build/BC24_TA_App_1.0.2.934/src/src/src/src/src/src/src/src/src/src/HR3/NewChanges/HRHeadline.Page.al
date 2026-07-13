page 51285 "HR Headline"
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

                field(InActiveEmployeeCountText; InActiveEmployeeCountText)
                {
                    ApplicationArea = All;
                    Visible = InActiveStaffCount <> 0;
                    ToolTip = 'Specifies the value of the InActiveEmployeeCountText field.';
                }

            }
        }
    }

    trigger OnOpenPage()
    var
        HREmp: Record "HR-Employee";

    begin
        HREmp.Reset();
        HREmp.SetRange(Status, HREmp.Status::Active);
        ActiveStaffCount := HREmp.Count();
        ActiveEmployeeCountText := ActiveEmployeesLbl + Format(ActiveStaffCount);

        HREmp.Reset();
        HREmp.SetFilter(Status, '<>%1', HREmp.Status::Active);
        InActiveStaffCount := HREmp.Count();
        InActiveEmployeeCountText := InActiveEmployeesLbl + Format(InActiveStaffCount);


        Welcome := WelcomeLbl;
    end;

    var
        WelcomeLbl: Label 'Welcome: Human Resource and Payroll Role Center';
        ActiveEmployeesLbl: Label 'Active employees are ';
        InActiveEmployeesLbl: Label 'In-Active employees are ';
        Welcome: Text;
        ActiveEmployeeCountText: Text;
        InActiveEmployeeCountText: Text;
        ActiveStaffCount: Integer;
        InActiveStaffCount: Integer;

}