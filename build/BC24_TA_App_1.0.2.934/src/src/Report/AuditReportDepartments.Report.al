Report 50066 "Audit Report - Departments"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/AuditReportDepartments.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Audit Programmes"; "Audit Programmes")
        {
            DataItemTableView = sorting(Code) where(Status = filter(Approved));
            RequestFilterFields = "Code";
            column(ReportForNavId_3; 3) { }
            column(Title_AuditProgrammes; "Audit Programmes".Title) { }
            column(Address_CompanyInformation; "Company Information".Address) { }
            column(Address2_CompanyInformation; "Company Information"."Address 2") { }
            column(City_CompanyInformation; "Company Information".City) { }
            column(PhoneNo_CompanyInformation; "Company Information"."Phone No.") { }
            column(Picture_CompanyInformation; "Company Information".Picture) { }
            column(EMail_CompanyInformation; "Company Information"."E-Mail") { }
            column(Name_CompanyInformation; "Company Information".Name) { }
            column(website_CompanyInformation; "Company Information"."Home Page") { }
            column(dateToday; dateToday) { }
            dataitem(Audits; Audits)
            {
                DataItemLink = "Audit Programme" = field(Code);
                DataItemTableView = sorting(Code);
                RequestFilterFields = "Code";
                column(ReportForNavId_4; 4) { }
                column(AuditNo_Audits; Audits."Audit No.") { }
                dataitem(Department; "Dimension Value")
                {
                    DataItemTableView = sorting("Dimension Code", Code) where("Dimension Code" = filter('DEPARTMENT'));
                    RequestFilterFields = "Code";
                    RequestFilterHeading = 'Department';
                    column(ReportForNavId_21; 21) { }
                    column(Name_Department; Department.Name) { }
                    column(complianceNo; complianceNo) { }
                    column(totalFindings; totalFindings) { }
                    column(minorNo; minorNo) { }
                    column(majorNo; majorNo) { }
                    column(observationNo; observationNo) { }
                    dataitem(Findings; "Audit Checklists")
                    {
                        DataItemLink = Department = field(Code);
                        DataItemTableView = sorting(Code) where("Finding Status" = filter(Accepted));
                        column(ReportForNavId_20; 20) { }

                        trigger OnAfterGetRecord()
                        begin
                            if Findings.Count <> 0 then begin
                                totalFindings := totalFindings + 1;
                                if (Findings.Classification = Findings.Classification::"Compliance/Positive") then
                                    complianceNo := complianceNo + 1
                                else
                                    if (Findings.Classification = Findings.Classification::"Major Non-conformity") then
                                        majorNo := majorNo + 1
                                    else
                                        if (Findings.Classification = Findings.Classification::"Minor Non-conformity") then
                                            minorNo := minorNo + 1
                                        else
                                            if (Findings.Classification = Findings.Classification::Observation) then
                                                observationNo := observationNo + 1;
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            Findings.SetFilter("Audit Code", Audits.Code);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        totalFindings := 0;
                        complianceNo := 0;
                        majorNo := 0;
                        minorNo := 0;
                        observationNo := 0;
                    end;
                }
            }

            trigger OnPreDataItem()
            begin
                if "Company Information".Get then
                    "Company Information".CalcFields("Company Information".Picture);
                dateToday := Today;
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        "Company Information": Record "Company Information";
        dateToday: Date;
        complianceNo: Integer;
        observationNo: Integer;
        minorNo: Integer;
        majorNo: Integer;
        totalFindings: Integer;
}

