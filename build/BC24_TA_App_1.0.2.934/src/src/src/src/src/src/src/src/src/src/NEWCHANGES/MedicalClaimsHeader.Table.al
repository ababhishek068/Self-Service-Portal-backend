table 51011 "Medical Claims Header"
{
    Caption = 'Medical Claims Header';
    DataClassification = ToBeClassified;
    DrillDownPageId="Medical Claims List";
    
    fields
    {
        field(1; "Claim No"; Code[20])
        {
            Caption = 'Claim No';

        }
        field(2; "Vendor No"; Code[20])
        {
            Caption = 'Vendor No';
            TableRelation=Vendor."No.";
            trigger OnValidate()
            begin
                ven.Reset();
                ven.SetRange(ven."No.","Vendor No");
                if ven.FindFirst() then begin
                "Vendor Name":=ven.Name;
                "Vendor TIN No":=ven."TIN No.";
                "Vendor VAT Reg No":=ven."VAT Registration No.";

                end;

                
            end;
        }
        field(3; "Vendor Name"; Text[50])
        {
            Caption = 'Vendor Name';
            Editable=false;
        }
        field(4; "Vendor TIN No"; Code[40])
        {
            Caption = 'TIN No';
            Editable=false;
        }
        field(5; "Vendor VAT Reg No"; Code[40])
        {
            Caption = 'VAT Reg No';
            Editable=false;
        }
        field(6; "Invoice No"; Code[20])
        { 
            Editable=true;
            Caption = 'Invoice No';
            TableRelation="Purch. Inv. Header"."No." where("Vendor Invoice No."=field("Vendor Invoice No"),"Pay-to Vendor No."=field("Vendor No"));
            trigger OnValidate()
            begin
                TestField("Vendor Invoice No");
                TestField("Vendor No");
                purchinv.Reset();
                purchinv.SetRange(purchinv."No.","Invoice No");
                purchinv.SetRange(purchinv."Pay-to Vendor No.","Vendor No");
                purchinv.SetRange(purchinv."Vendor Invoice No.","Vendor Invoice No");
                if purchinv.FindFirst() then begin
                    "Invoice Date":=purchinv."Posting Date";
                    purchinv.CalcFields("Amount Including VAT");
                    "Invoice Amount":=purchinv."Amount Including VAT";
                end;
            end; 
        }
        field(7; "Invoice Amount"; Decimal)
        {
            Caption = 'Invoice Amount';
            trigger OnValidate()
            begin
                if "Invoice Amount"<>0 then begin
                    "Total Company expense":="Invoice Amount"-"Amount to be Paid By Staff";

                end else begin

                end;
            end;
        }
        field(8; "No of Staff"; Integer)
        {
            Caption = 'No of Staff';
            Editable=false;
            CalcFormula = count("Medical Claim Lines" where("Claim No"=field("Claim No"),"Vendor No"=field("Vendor No"),"Invoice No"=field("Invoice No")));
            
            
            FieldClass = FlowField;
        }
        field(9; "Amount to be Paid By Staff"; Decimal)
        {
            Caption = 'Amount to be Paid By Staff';
            CalcFormula = sum("Medical Claim Lines"."Amount to recover from Staff" where("Claim No"=field("Claim No"),"Vendor No"=field("Vendor No"),"Invoice No"=field("Invoice No")));
            
            Editable = false;
            FieldClass = FlowField;
            trigger OnValidate()
            begin
                Validate("Invoice Amount");
            end;
            
        }
        field(10; "Total Company expense"; Decimal)
        {
            Caption = 'Total expense';
            //CalcFormula = sum("Medical Claim Lines".Amount-"Medical Claim Lines"."Amount to recover from Staff") where("Claim No"=field("Claim No"),"Vendor No"=field("Vendor No"),"Invoice No"=field("Invoice No")));
            
            Editable = false;
            //FieldClass = FlowField;
        }
        field(11; "Created By"; Code[50])
        {
            Caption = 'Created By';
        }
        field(12; "Created Date"; date)
        {
            Caption = 'Created By';
        }
        field(13; Status; Option)
        {
            Caption = 'Status';
            OptionMembers=open,approved,rejected;
            trigger OnValidate()
            begin
                TestField("Invoice Amount");
                if Status=Status::approved then begin
                    payrollperiod.Reset();
                    payrollperiod.SetRange(payrollperiod.Closed,false);
                    if payrollperiod.FindFirst() then begin
                        if payrollperiod."Date Opened"<>0D then begin
                            "Payroll Period":=payrollperiod."Date Opened";
                            "Payroll Month":=payrollperiod."Period Month";
                            "Payroll Year":=payrollperiod."Period Year";
                            rec.Modify();
                            claimlines.Reset();
                            claimlines.SetRange(claimlines."Claim No",rec."Claim No");
                            if claimlines.Find('-') then begin
                                repeat
                                claimlines."Payroll Period":=rec."Payroll Period";
                                claimlines.Modify();
                                until claimlines.Next=0;
                            end;
                            end;
                        end else begin
                            Error('There is no payroll period open!');

                        end;

                    end else begin
                        Error('There is no payroll period open!');
                    end;

                end;
            //end;
        }
        field(14; Remarks; Text[250])
        {
            Caption = 'Remarks';
            trigger OnValidate()
            begin
                TestField("Vendor No");
                TestField("Vendor Invoice No");
                TestField("Invoice No");
                TestField("Invoice Amount");
                TestField("Invoice Date");
            end;
        }
        field(15;"Invoice Date";date)
        {

        }    
        field(16;"Payroll Period";Date){
            Editable=false;
        }    
        field(17;"Payroll Month";Integer){
            Editable=false;
        }
        field(18;"Payroll Year";Integer){
            Editable=false;
        }
        field(19;"Vendor Invoice No";code[40]){}
    }
    keys
    {
        key(PK; "Claim No","Vendor No","Invoice No")
        {
            Clustered = true;
        }
    }
    var
    ven:Record vendor;
    payrollperiod: Record "PR Payroll Periods";
    purchinv: Record "Purch. Inv. Header";
    claimlines: Record "Medical Claim Lines";
    trigger OnInsert()
    begin
        "Created By":=UserId;
        "Created Date":=Today;

    end;
}
