table 51012 "Medical Claim Lines"
{
    Caption = 'Medical Claim Lines';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; EntryNo; Integer)
        {
            Caption = 'EntryNo';
            Editable=false;
            AutoIncrement=true;
        }
        field(2; "Claim No"; Code[20])
        {
            Caption = 'Claim No';
        }
        field(3; "Vendor No"; Code[20])
        {
            Caption = 'Vendor No';
        }
        field(4; "Invoice No"; Code[20])
        {
            Caption = 'Invoice No';
        }
        field(5; "Staff No"; Code[20])
        {
            Caption = 'Staff No';
            TableRelation="HR-Employee"."No." where(Status=filter(Active));
            trigger OnValidate()
            begin
                hremps.Reset();
                hremps.SetRange(hremps."No.","Staff No");
                if hremps.FindFirst() then begin
                    "Staff Name":=hremps."First Name"+' '+hremps."Middle Name"+' '+hremps."Last Name";
                end;
                vitalsetup.Get();
                vitalsetup.TestField("Claims Code");
                "Medical Allowance Code":=vitalsetup."Claims Code";
            end;
        }
        field(6; "Staff Name"; Text[50])
        {
            Caption = 'Staff Name';
        }
        field(7; "Treatment Start Date"; Date)
        {
            Caption = 'Treatment Start Date';
        }
        field(8; "Treatement End Date"; Date)
        {
            Caption = 'Treatement End Date';
        }
        field(9; "Bill Amount"; Decimal)
        {
            Caption = 'Bill Amount';
            trigger OnValidate()
            
            begin
                // vitalsetup.Get();
                // vitalsetup.TestField("% Staff Claim");
                // vitalsetup.TestField("% GlasFrames");
                // "Amount to recover from Staff":=(vitalsetup."% Staff Claim"/100)*"Bill Amount";
            end;
        }
        field(10; "Amount to recover from Staff"; Decimal)
        {
            Caption = 'Amount to recover from Staff';
            Editable=false;
        }
        field(11;"Amount paid";Decimal){
            Editable=false;
            CalcFormula = sum("PR Employee Transactions".Amount where("Employee Code"=field("Staff No"),"Payroll Period"=field("Payroll Period"),"Transaction Code"=field("Medical Allowance Code")));            
            
            FieldClass = FlowField;
            trigger OnValidate()
            begin
                Balance:="Amount to recover from Staff"-"Amount paid";
            end;
        }
        field(12;"Balance";Decimal){
            Editable=false;
        }
        field(13;"Payroll Period";date){
            Editable=false;
        }
        field(14;"Medical Allowance Code";Code[20])
        {

        }
        field(15;"Glass-Frame Amount";Decimal){
            trigger OnValidate()
            begin
            vitalsetup.Get();
                vitalsetup.TestField("% Staff Claim");
                vitalsetup.TestField("% GlasFrames");
                TestField("Bill Amount");
                if "Glass-Frame Amount"<>0 then
                "Amount to recover from Staff":=(vitalsetup."% GlasFrames"/100)*"Bill Amount"+"General Health amount";
            end;
        }
        field(16;"General Health amount";Decimal){
             trigger OnValidate()
            begin
            vitalsetup.Get();
                vitalsetup.TestField("% Staff Claim");
                vitalsetup.TestField("% GlasFrames");
                TestField("Bill Amount");
                if "General Health amount"<>0 then
                "Amount to recover from Staff":=(vitalsetup."% Staff Claim"/100)*"Bill Amount"+"Glass-Frame Amount";
                
               
            end;
        }
    }
    keys
    {
        key(PK; "Claim No","Vendor No","Invoice No","Staff No")
        {
            Clustered = true;
        }
        key(pk2;"Staff No")
        {
            
        }
    }
    var
    hremps: Record "HR-Employee";
    vitalsetup: Record "PR Vital Setup Info";
}
