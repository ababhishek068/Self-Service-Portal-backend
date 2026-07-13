namespace ABH_UAT.ABH_UAT;

report 50370 "Cost Share"
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payrollreports/costshare.rdl';

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
            column(sn;sn){}
            column(initialbal;initialbal){}
            column(empstartdate;empstartdate){}
            column(actualcontribution;actualcontribution){}
            column(costshareperc;costshareperc){}
            column(basic;basic){}
            trigger OnPreDataItem()
            begin
                Setfilter("Transaction Code", '%1', 'COSTSHARE');
                sn:=0;
            end;

            trigger onaftergetrecord()
            begin
                sn:=sn+1;
                fName := '';
                lastname := '';
                IDNumber := '';
                nhifno := '';
                pinNumber := '';
                phoneNumber := '';
                actualcontribution:=0;
                runningbal:=0;
                curcontribution:=0;
                initialbal:=0; 
                empstartdate:=0D;  
                basic:=0;
                perc:=0;
                costshareperc:='';              

                HREmployee.reset();
                if HREmployee.get("employee code") then begin
                    HREmployee.TestField("TIN No.");
                    HREmployee.TestField("Cost Share Start Date");
                    HREmployee.TestField("Cost Share Outstanding Balance");
                    fName := HREmployee."First Name";
                    lastname := HREmployee."Last Name";
                    IDNumber := HREmployee."ID Number";
                    nhifno := HREmployee."NHIF No.";
                    pinNumber := HREmployee."TIN No.";
                    phoneNumber := HREmployee."Home Phone Number";
                    empstartdate:=HREmployee."Date Of Joining the Company";
                    initialbal:=HREmployee."Cost Share Outstanding Balance";
                    HREmployee.CalcFields("CostShare Contributions");
                    actualcontribution:=HREmployee."CostShare Contributions";
                    fname:=HREmployee."First Name"+' '+HREmployee."Middle Name"+' '+HREmployee."Last Name";
                    prtrans.Reset();
                    prtrans.SetRange(prtrans."Employee Code",HREmployee."No.");
                    prtrans.SetRange(prtrans."Transaction Code",'BPAY');
                    prtrans.SetRange(prtrans."Payroll Period","Payroll Period");
                    if prtrans.FindFirst() then begin
                        basic:=prtrans.Amount;
                    end;

                    vitalsetup.Get();
                    //perc:=vitalsetup."Cost share percentage";
                    costshareperc:=Format(perc)+''+'%';

                    
            
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
        prtrans:Record "PR Period Transactions";
        actualcontribution:Decimal;
        curcontribution:Decimal;
        initialbal: Decimal;
        runningbal: Decimal;
        empstartdate:date;
        sn: Integer;
        basic: Decimal;
        perc: Decimal;
        costshareperc: Text[50];
        vitalsetup: Record "PR Vital Setup Info";
}