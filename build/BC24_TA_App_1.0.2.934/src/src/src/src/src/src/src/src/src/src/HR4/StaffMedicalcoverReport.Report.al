Report 50273 "Staff Medical cover Report."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/StaffMedicalcoverReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Employees"; "HR-Employee")
        {
            column(ReportForNavId_1; 1) { }
            column(HomePhoneNumber_HREmployees; "HR Employees"."Home Phone Number") { }
            column(CellularPhoneNumber_HREmployees; "HR Employees"."Cellular Phone Number") { }
            column(EMail_HREmployees; "HR Employees"."E-Mail") { }
            column(IDNumber_HREmployees; "HR Employees"."ID Number") { }
            column(Gender_HREmployees; "HR Employees".Gender) { }
            column(Title_HREmployees; "HR Employees".Title) { }
            column(Position_HREmployees; "HR Employees".Position) { }
            column(Level_HREmployees; "HR Employees".Level) { }
            column(JobID_HREmployees; "HR Employees"."Job ID") { }
            column(No_HREmployees; "HR Employees"."No.") { }
            column(FirstName_HREmployees; "HR Employees"."First Name") { }
            column(MiddleName_HREmployees; "HR Employees"."Middle Name") { }
            column(LastName_HREmployees; "HR Employees"."Last Name") { }
            column(Initials_HREmployees; "HR Employees".Initials) { }
            column(FullName_HREmployees; "HR Employees"."Full Name") { }
            column(City_HREmployees; "HR Employees".City) { }
            column(Region_HREmployees; "HR Employees".Region) { }
            column(DateOfBirth_HREmployees; "HR Employees"."Date Of Birth") { }
            column("Count"; COUNTS) { }
            column(Categories; Cate) { }
            column(Cname; CompInfo.Name) { }
            column(Caddress; CompInfo.Address) { }
            column(ccity; CompInfo.City) { }
            column(Cphone; CompInfo."Phone No.") { }
            column(Cpicture; CompInfo.Picture) { }
            column(Cemail; CompInfo."E-Mail") { }

            trigger OnAfterGetRecord()
            begin
                HRMedicalSchemeMembers.Reset;
                HRMedicalSchemeMembers.SetRange(HRMedicalSchemeMembers."Employee No", "HR Employees"."No.");
                if HRMedicalSchemeMembers.Find('-') then begin
                    Cate := HRMedicalSchemeMembers."Scheme No";
                end;
                COUNTS := COUNTS + 1;
                //IF Cate='' THEN CurrReport.SKIP;
            end;

            trigger OnPreDataItem()
            begin
                COUNTS := 0;
                CompInfo.Get;
                CompInfo.CalcFields(Picture);
                Cate := '';
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnInitReport()
    begin
        if userSetUp.Get(UserId) then begin
            if userSetUp."Medical Team" = false then
                Error('Permission denied');
        end;
    end;

    var
        COUNTS: Integer;
        CompInfo: Record "Company Information";
        HRMedicalSchemeMembers: Record "HR Medical Scheme Members";
        Cate: Code[30];
        userSetUp: Record "User Setup";
}

