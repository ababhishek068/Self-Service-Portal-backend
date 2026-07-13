table 50970 "Overtime Lines"
{
    Caption = 'Overtime Lines';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; Entry_No; Integer)
        {
            Caption = 'Entry_No';
            AutoIncrement=true;
        }
        field(2; PeriodCode; Code[50])
        {
            Caption = 'PeriodCode';
            Editable=false;
        }
        field(3; PeriodMonth; Integer)
        {
            Caption = 'PeriodMonth';
            Editable=false;
        }
        field(4; PeriodYear; Integer)
        {
            Caption = 'PeriodYear';
            Editable=false;
        }
        field(5; PayrollPeriod; Date)
        {
            Caption = 'PayrollPeriod';
            Editable=false;
        }
        field(6; "Employee code"; Code[20])
        {
            Caption = 'Employee code';
            TableRelation="HR-Employee"."No." where(Status=const(Active));
            trigger onvalidate()
            begin
            emprec.Reset();
            emprec.SetRange(emprec."No.","Employee code");
            if emprec.FindFirst() then begin

          "Employee Name":=emprec."Full Name";
          precords.Reset();
          precords.SetRange(precords."Employee Code","Employee code");
          if precords.FindFirst() then begin
            if precords."Suspend Pay"=false then begin
            "Basic Pay":=precords."Basic Pay";
            end else if precords."Suspend Pay"=true then begin
                Error('This employee is currently suspended');
            end;

          end else begin
          Error('please define basic pay of this staff');

          end;

            end


            end;
        }
        field(7; "Employee Name"; Text[50])
        {
            Caption = 'Employee Name';
            Editable=false;
        }
        field(8; "6AM-6PM"; Decimal)
        {
            Caption = '6AM-6PM';
            trigger OnValidate()
            
            begin
                TestField(Rec."Basic Pay");
                rates.Reset();
                rates.SetRange(rates."6AM-6PM");
                if rates.FindFirst() then begin
                    rates.TestField("Formula Based On");
                    rates.TestField("6AM-6PM");
                    rates.TestField("6PM-10PM");
                    rates.TestField("10PM-6AM");
                    rates.TestField(Weekend);
                    rates.TestField("Public Holiday Rate");
                    if rates."6AM-6PM"<>0 then begin
                        rec."6AM-6PM Amount":=rates."6AM-6PM"*rec."6AM-6PM"*("Basic Pay"/rates."Formula Based On");

                    end else if rates."6AM-6PM"=0 then begin

                    end;
                    Validate(rec."6AM-6PM Amount");
                end;
            end;
        }
        field(9; "6PM-10PM"; Decimal)
        {
            Caption = '6PM-10PM';
            trigger OnValidate()
            
            begin
                TestField("Basic Pay");
                rates.Reset();
                rates.SetRange(rates."6PM-10PM");
                if rates.FindFirst() then begin
                    rates.TestField("Formula Based On");
                     rates.TestField("6AM-6PM");
                    rates.TestField("6PM-10PM");
                    rates.TestField("10PM-6AM");
                    rates.TestField(Weekend);
                    rates.TestField("Public Holiday Rate");
                    if rates."6PM-10PM"<>0 then begin
                        rec."6PM-10PM total":=rates."6PM-10PM"*rec."6PM-10PM"*("Basic Pay"/rates."Formula Based On");

                    end else if rates."6PM-10PM"=0 then begin

                    end;
                    Validate(rec."6PM-10PM total");

                end;
            end;
        }
        field(10; Weekend; Decimal)
        {
            Caption = 'Weekend';
            trigger OnValidate()
            
            begin
                TestField("Basic Pay");
                rates.Reset();
                rates.SetRange(rates.Weekend);
                if rates.FindFirst() then begin
                    rates.TestField("Formula Based On");
                     rates.TestField("6AM-6PM");
                    rates.TestField("6PM-10PM");
                    rates.TestField("10PM-6AM");
                    rates.TestField(Weekend);
                    rates.TestField("Public Holiday Rate");
                    if rates.Weekend<>0 then begin
                        rec."Weekend Total":=rates.Weekend*rec.Weekend*("Basic Pay"/rates."Formula Based On");

                    end else if rates.Weekend=0 then begin

                    end;
                    Validate(rec."Weekend Total");

                end;
            end;
            
        }
        field(11; Holiday; Decimal)
        {
            Caption = 'Holiday';
            trigger OnValidate()
            
            begin
                TestField("Basic Pay");
                rates.Reset();
                rates.SetRange(rates.Weekend);
                if rates.FindFirst() then begin
                    rates.TestField("Formula Based On");
                     rates.TestField("6AM-6PM");
                    rates.TestField("6PM-10PM");
                    rates.TestField("10PM-6AM");
                    rates.TestField(Weekend);
                    rates.TestField("Public Holiday Rate");
                    if rates."Public Holiday Rate"<>0 then begin
                       rec."Holiday Total":=rates."Public Holiday Rate"*rec.Holiday*("Basic Pay"/rates."Formula Based On");

                    end else if rates.Weekend=0 then begin

                    end;
                    Validate(rec."Holiday Total");
                end;
            end;
        }
        field(12; "Line Total"; Decimal)
        {
            Caption = 'Line Total';
            Editable=false;
        }
        field(13;"6AM-6PM Amount";Decimal){
            Editable=false;
            
            trigger OnValidate()
            // clear(line )
            begin
                rec."Line Total":=rec."6AM-6PM Amount"+rec."6PM-10PM total"+rec."Weekend Total"+rec."Holiday Total"+rec."10PM-6AM Total";
            end;
        }
        field(14;"6PM-10PM total";Decimal){
            Editable=false;
            trigger OnValidate()
            // clear(line )
            begin
                rec."Line Total":=rec."6AM-6PM Amount"+rec."6PM-10PM total"+rec."Weekend Total"+rec."Holiday Total"+rec."10PM-6AM Total";
            end;
        }
        field(15;"Weekend Total";Decimal){Editable=false;
        trigger OnValidate()
            // clear(line )
            begin
                rec."Line Total":=rec."6AM-6PM Amount"+rec."6PM-10PM total"+rec."Weekend Total"+rec."Holiday Total"+rec."10PM-6AM Total";
            end;}
        field(16;"Holiday Total";Decimal){Editable=false;
        trigger OnValidate()
            // clear(line )
            begin
                rec."Line Total":=rec."6AM-6PM Amount"+rec."6PM-10PM total"+rec."Weekend Total"+rec."Holiday Total"+rec."10PM-6AM Total";
            end;}
        field(17;OvertimeID;Integer){}
        field(18;"Basic Pay";Decimal){}
        field(19;"10PM-6AM";Decimal){
            trigger OnValidate()
            
            begin
                TestField("Basic Pay");
                rates.Reset();
                rates.SetRange(rates."6AM-6PM");
                if rates.FindFirst() then begin
                    rates.TestField("Formula Based On");
                    rates.TestField("6AM-6PM");
                    rates.TestField("6PM-10PM");
                    rates.TestField("10PM-6AM");
                    rates.TestField(Weekend);
                    rates.TestField("Public Holiday Rate");
                    if rates."10PM-6AM"<>0 then begin
                        rec."10PM-6AM total":=rates."10PM-6AM"*rec."10PM-6AM"*("Basic Pay"/rates."Formula Based On");

                    end else if rates."6AM-6PM"=0 then begin

                    end;
                    Validate(rec."10PM-6AM Total");
                end;
            end;
        }
        field(20;"10PM-6AM Total";Decimal){
            trigger OnValidate()
            begin
                rec."Line Total":=rec."6AM-6PM Amount"+rec."6PM-10PM total"+rec."Weekend Total"+rec."Holiday Total"+rec."10PM-6AM Total";
            end;
        }
    }
    keys
    {
        key(PK; PayrollPeriod,"Employee code")
        {
            Clustered = true;
        }
    }
    var
    emprec: Record "HR-Employee";
    rates: Record "Allowances Rates Setup";
    precords: Record "PR Salary Card";
}
