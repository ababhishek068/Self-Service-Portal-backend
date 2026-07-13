report 52202480 "NHIF Report"
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payrollreports/SHIFSummary.rdl';

    dataset
    {
        dataitem(DataItemName; "pr Period Transactions")
        {
            RequestFilterFields = "payroll period";

            column(IDNumber; idnumber)
            {
            }
            column(Name; fName)
            {
            }
            column(LName; lastName)
            {
            }
            column(NHIFNo; NHIFNo)
            {
            }
            column(StaffNumber; "employee code")
            {
            }
            column(Amount; amount)
            {
            }
            column(pinNumber; pinNumber)
            {

            }
            column(phoneNumber; phoneNumber)
            {

            }
            trigger OnPreDataItem()
            begin
                Setfilter("Transaction Code", '%1', 'SHIF');
            end;

            trigger onaftergetrecord()
            begin
                fName := '';
                lastname := '';
                IDNumber := '';
                nhifno := '';
                pinNumber := '';
                phoneNumber := '';

                HREmployee.reset();
                if HREmployee.get("employee code") then begin
                    fName := HREmployee."First Name";
                    lastname := HREmployee."Last Name";
                    IDNumber := HREmployee."ID Number";
                    nhifno := HREmployee."NHIF No.";
                    pinNumber := HREmployee."TIN No.";
                    phoneNumber := HREmployee."Home Phone Number";
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
            }
        }

        actions
        {

        }
    }

    var

        HREmployee: record "hr-employee";

        IDNumber: code[30];

        NHIFNo: Code[20];

        FName: text[80];
        LastName: Text[50];
        pinNumber: Text[50];
        phoneNumber: Text;
}