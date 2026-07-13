Report 50166 "PR Employee Pension"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PREmployeePension.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Employees"; "HR-Employee")
        {
            column(ReportForNavId_1; 1) { }
            column(PensionNo_HREmployees; "HR Employees"."Pension No.") { }
            column(FullName_HREmployees; "HR Employees"."Full Name") { }
            column(No_HREmployees; "HR Employees"."No.") { }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(SelectedYear; SelectedYear)
                {
                    ApplicationArea = Basic;
                    Caption = 'Selected Period';
                    ToolTip = 'Specifies the value of the Selected Period field.';
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin

        if SelectedYear = 0 then Error('Please select a Payroll Year');


        SelectedYearText := Format(SelectedYear);
        Evaluate(SelectedYearInteger, SelectedYearText);
    end;

    var
        SelectedYear: Option " ","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030","2031","2032","2033","2034","2035","2036","2037","2038","2039","2040","2041","2042","2043","2044","2045","2046","2047","2048","2049","2050","2051","2052","2053","2054";
        SelectedYearInteger: Integer;
        SelectedYearText: Text;
}

