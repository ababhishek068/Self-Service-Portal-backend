report 50361 "Compensation Benchmarking Temp"
{
    ApplicationArea = All;
    Caption = 'Compensation Benchmarking Template';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './NewLayouts/Compensation.rdl';

    dataset
    {
        dataitem(HREmployee; "HR-Employee")
        {
            column(DepartmentCode; "Department Code")
            {
            }
            column(DepartmentName; "Department Name")
            {
            }
            column(FullPartTime; "Full / Part Time")
            {
            }
            column(Gender; Gender)
            {
            }
            column(FullName; "Full Name")
            {
            }
            column(GlobalDimension1Name; "Global Dimension 1 Name")
            {
            }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
            column(Grade; Grade)
            {
            }
            column(JobID; "Job ID")
            {
            }
            column(JobTitle; "Job Title")
            {
            }
            column(SalaryGrade; "Salary Grade")
            {
            }

        }

    }
    trigger OnInitReport()
    begin
        compinfo.get;
        compinfo.CalcFields(Picture);
        //AddressCC:=compinfo.Address;

    end;

    var
        jobs: record "HR Jobs";
        jobgrades: record "HR Job Grades";
       // salarygrades: Record "Sal Grades";
        compinfo: record "Company Information";
        AddressCC: label 'Address City/Town';
        subcitycc: label 'Zone/Sub-city';
        Woredacc: label 'Woreda';
        Kebelecc: label 'Kebele';
        Hnocc: label 'H.No.';
        TIN: label 'TIN';
        VATREGNO: label 'VAT Reg. No';
}
