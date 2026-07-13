table 50981 "Loan Guarantee Lines"
{
    Caption = 'Loan Guarantee Lines';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Guarantee No"; Code[20])
        {
            Caption = 'Guarantee No';
            

        }
        field(2; "Guarantor Code"; Code[20])
        {
            Caption = 'Guarantor Code';
            TableRelation="HR-Employee"."No." where(Status=const(active));
            Editable=true;
            trigger OnValidate()
            var
            countoftimes: Integer;
            begin
                hremps.Reset();
                hremps.SetRange(hremps."No.","Guarantor Code");
                if hremps.FindFirst() then begin

                    "Guarantor Name":=hremps."First Name"+''+hremps."Middle Name"+''+hremps."Last Name";
                    Status:=hremps.Status;
                end;
                countoftimes:=0;
                loanlines.Reset();
                loanlines.SetRange(loanlines."Guarantor Code",rec."Guarantor Code");
                if loanlines.Find('-') then begin
                    repeat
                    countoftimes:=countoftimes+1;
                    until loanlines.next=0;
                end;
                if countoftimes>2 then 
                Error('An employee cannot guarantee more than 2 loans at a time');

            end;
        }
        field(3; "Guarantor Name"; Text[50])
        {
            Caption = 'Guarantor Name';
            Editable=false;
        }
        field(4; "Amount Guaranteed"; Decimal)
        {
            Caption = 'Amount Guaranteed';
            MinValue=1;
            
        }
        field(5; "Amount to Pay"; Decimal)
        {
            Caption = 'Amount to Pay';
            MinValue=1;
             trigger OnValidate()
            var
            
            totaldefault: Decimal;
            begin
                //Balance:="Amount Guaranteed"-"Amount to Pay";
                totaldefault:=0;
                loanheader.Reset();
                loanheader.SetRange(loanheader."Ref No",Rec."Ref No");
                loanheader.SetRange(loanheader."Loan Guarantee No",rec."Guarantee No");
                if loanheader.FindFirst() then begin
                    loanlines.Reset();
                    loanlines.SetRange(loanlines."Guarantee No",rec."Guarantee No");
                    loanlines.SetRange(loanlines."Ref No",rec."Ref No");
                    loanlines.SetRange(loanlines.Status,loanlines.Status::Active);
                    if loanlines.Find('-') then begin
                        repeat
                        totaldefault:=totaldefault+loanlines."Amount to Pay";
                        until loanlines.next=0;
                        if totaldefault>loanheader."Amount Defaulted" then begin
                            Error('Line amounts must total amount defaulted');
                        end;
                        
                    end;
                end;

            end;
        
        }
        field(6; Balance; Decimal)
        {
            Caption = 'Balance';
            Editable=false;
        }
        field(7; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = New,"Pending Approval",Active,InActive;
            Editable=false;
        }
        field(8;"Ref No";Code[50]){

        }
        field(9;Closed;Boolean){
            Editable=false;
            TableRelation="Loan Guarantee Header".Closed where("Ref No"=field("Ref No"),"Loan Guarantee No"=field("Guarantee No"));
        }
        field(10;"Amount paid";Decimal)
        {
            //CalcFormula = sum("PR Period Transactions".Amount where("Employee Code" = field("No."), "Transaction Code" = filter('GA'), "Period Closed" = filter(true)));
            CalcFormula=sum("PR Period Transactions".Amount where("Employee Code"=field("Guarantor Code"),"Transaction Code" = filter('GA'), "Period Closed" = filter(true),"Reference No"=field("Guarantee No")));
            DecimalPlaces = 2 : 2;
            FieldClass = FlowField;
            Editable = false;
            trigger OnValidate()
            begin
                Balance:="Amount to Pay"-"Amount paid";
            end;

        }
        field(11;Installment;Decimal){}
    }
    keys
    {
        key(PK; "Guarantee No","Guarantor Code","Ref No")
        {
            Clustered = true;
        }
    }
    var
    hremps: record "HR-Employee";
    loanheader: Record "Loan Guarantee Header";
    loanlines: Record "Loan Guarantee Lines";

    
}

