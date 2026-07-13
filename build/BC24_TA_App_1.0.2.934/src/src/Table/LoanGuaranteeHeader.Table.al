table 50980 "Loan Guarantee Header"
{
    Caption = 'Loan Guarantee Header';
    DataClassification = ToBeClassified;
    DrillDownPageId ="Loan Guarantee List";
    
    fields
    {
        field(1; "Loan Guarantee No"; Code[20])
        {
            Caption = 'Loan Guarantee No';
        }
        field(2; "Loan Date"; Date)
        {
            Caption = 'Loan Date';
        }
        field(3; "Ref No"; Code[50])
        {
            Caption = 'Ref No';
            NotBlank=true;
        }
        field(4; Loanee; Code[20])
        {
            Caption = 'Loanee';
            TableRelation="HR-Employee"."No." where(Status=const(InActive));
            trigger OnValidate()
            begin
                TestField("Ref No");
                hremps.Reset();
                hremps.SetRange(hremps."No.",Loanee);
                if hremps.FindFirst() then begin

                    "Loanee Name":=hremps."First Name"+' '+hremps."Middle Name"+' '+hremps."Last Name";
                end
            end;
        }
        field(5; "Loanee Name"; Text[100])
        {
            Caption = 'Loanee Name';
            Editable=false;
        }
        field(6; "Principal Amount"; Decimal)
        {
            Caption = 'Principal Amount';
        }
        field(7; "Amount Defaulted"; Decimal)
        {
            Caption = 'Amount Defaulted';
        }
        field(8; "Date Defaulted"; Date)
        {
            Caption = 'Date Defaulted';
        }
        field(9; "Amount Recovered"; Decimal)
        {
            Caption = 'Amount Recovered';
        }
        field(10; Balance; Decimal)
        {
            Caption = 'Balance';
        }
        field(11; Closed; Boolean)
        {
            Caption = 'Closed';
        }
        field(12; Status; Option)
        {
            Caption = 'Status';
            OptionMembers=New,Pending,Approved,Rejected;
            trigger OnValidate()
            var
            loanheader: Record "Loan Guarantee Header";
            loanl: record "Loan Guarantee Lines";
            lineamounts: Decimal;
            begin
                if rec.Status=Rec.Status::Approved then begin
                    lineamounts:=0;
                    loanl.Reset();
                    loanl.SetRange(loanl."Ref No",rec."Ref No");
                    loanl.SetRange(loanl."Guarantee No",rec."Loan Guarantee No");
                    
                    if loanl.Find('-') then begin
                        repeat
                        if loanl.Status=loanl.Status::Active then
                        lineamounts:=lineamounts+loanl."Amount to Pay";
                        until loanl.next=0;
                    end;

                end;
                if lineamounts<>0 then begin
                    if lineamounts<>Rec."Amount Defaulted" then begin
                        Error('Line Amounts to pay must be equal to amount defaulted');
                    end;

                end else begin
                    Error('Lines must have amounts');

                end;
                fnupdateguarantee(rec."Ref No",rec."Loan Guarantee No");
                rec."Send to Payroll":=true;
            end;
        }
        field(13;"Installment";Decimal){
            Editable=false;
        }
        field(14;"Send to Payroll";Boolean){
            Editable=false;
        }
        field(15;"Settlement Receipt No";Code[50]){
            trigger OnValidate()
            begin
                TestField("Settlement Amount");
            end;
        }
        field(16;"Settlement Amount";Decimal){
            trigger OnValidate()
            begin
                TestField("Amount Defaulted");
                TestField(Status,Status::Approved);
                TestField("Send to Payroll");
                if "Settlement Amount"<>"Amount Defaulted" then begin
                    Error('Defaulter must settle full amount');
                end;
            end;
        }
    }
    keys
    {
        key(PK;"Loan Guarantee No","Ref No",Loanee)
        {
            Clustered = true;
        }
    }
    var
    hremps: Record "HR-Employee";
    loanguaranteelines: Record "Loan Guarantee Lines";
    procedure fnupdateguarantee(refno:Code[50];guaranteeno:code[50])
    begin
        loanguaranteelines.Reset();
        loanguaranteelines.SetRange(loanguaranteelines."Ref No",refno);
        loanguaranteelines.SetRange(loanguaranteelines."Guarantee No",guaranteeno);
        if loanguaranteelines.Find('-') then begin
            repeat
            loanguaranteelines.TestField(loanguaranteelines.Installment);            
            hremps.Reset();
            hremps.SetRange(hremps."No.",loanguaranteelines."Guarantor Code");
            if hremps.FindFirst() then begin
                hremps."Loan Guarantee?":=true;
                hremps.Modify;
            end;

            until loanguaranteelines.next=0;
        end;

    end;
}
